package bdement.ui.lists
{

	import bdement.ui.effects.ListPageEffect;
	import bdement.util.IDisposable;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import avmplus.getQualifiedClassName;

	[Event(name = "populated", type = "bdement.ui.lists.ListEvent")]
	[Event(name = "selected", type = "bdement.ui.lists.ListEvent")]
	internal final class AbstractList implements IList, IDisposable
	{

		////////////////////////////////////////////////////////////
		//   ATTRIBUTES 
		////////////////////////////////////////////////////////////

		private var _container:DisplayObjectContainer

		// the external data source, kept so it can be retrieved by external actors
		private var _data:*;

		// the internal container for the data, created so it can be iterated over in createChildren()
		private var _dataArray:Array;

		private var _divider:DisplayObject;

		private var _itemRenderer:Class = DefaultItemRenderer;

		private var _itemsPerPage:int = int.MAX_VALUE;

		private var _page:int = 0;

		private var _pageEffect:ListPageEffect;

		private var _selected:IItemRenderer;

		////////////////////////////////////////////////////////////
		//   CONSTRUCTOR 
		////////////////////////////////////////////////////////////

		public function AbstractList(container:DisplayObjectContainer)
		{
			super();
			_container = container;
		}

		////////////////////////////////////////////////////////////
		//   PUBLIC API 
		////////////////////////////////////////////////////////////

		public function dispose():void
		{
			data = [];

			if (_pageEffect is IDisposable)
			{
				IDisposable(_pageEffect).dispose();
				_pageEffect = null;
			}
		}

		public function getRendererByData(value:*):IItemRenderer
		{
			for each (var renderer:IItemRenderer in _container["children"])
			{
				if (renderer.data === value)
				{
					return renderer;
				}
			}
			return null;
		}

		////////////////////////////////////////////////////////////
		//   EVENT HANDLERS 
		////////////////////////////////////////////////////////////

		protected function onClickChild(event:MouseEvent):void
		{
			selected = IItemRenderer(event.currentTarget);
		}

		private function onEnterFrame(event:Event):void
		{
			_container.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			validate();
		}

		////////////////////////////////////////////////////////////
		//   PRIVATE METHODS 
		////////////////////////////////////////////////////////////

		private function createChildren():void
		{
			// remove old item renderers
			while (_container.numChildren > 0)
			{
				var oldChild:DisplayObject = _container.getChildAt(0);
				oldChild.removeEventListener(MouseEvent.CLICK, onClickChild);
				IItemRenderer(oldChild).dispose();
				_container.removeChild(oldChild);
			}

			// if we're changing item renderers before data is set, abort
			if (!_dataArray)
			{
				return;
			}

			// create/add new item renderers
			var startIndex:int = page * itemsPerPage;
			var endIndex:int = Math.min(startIndex + itemsPerPage - 1, _dataArray.length - 1);

			for (var index:int = startIndex; index <= endIndex; index++)
			{
				var renderer:IItemRenderer = new _itemRenderer();

				if (!(renderer is DisplayObjectContainer))
				{
					throw new Error("IList.itemRenderer must be a DisplayObjectContainer");
				}

				renderer.data = _dataArray[index];

				var child:DisplayObjectContainer = DisplayObjectContainer(renderer);
				child.addEventListener(MouseEvent.CLICK, onClickChild);
				_container.addChild(child);

				// set default selection to first item
				if (!_selected)
				{
					_selected = renderer;
				}
			}

			container.dispatchEvent(new ListEvent(ListEvent.POPULATED));
		}

		private function invalidate():void
		{
			_container.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		private function validate():void
		{
			createChildren();
		}

		////////////////////////////////////////////////////////////
		//   GETTERS / SETTERS 
		////////////////////////////////////////////////////////////

		public function get container():DisplayObjectContainer
		{
			return _container;
		}

		public function get data():*
		{
			return _data.concat();
		}

		public function set data(value:*):void
		{
			_data = value;
			_dataArray = new Array();

			if (_data)
			{
				var className:String = getQualifiedClassName(_data);

				if (!(_data is Dictionary) && (className.indexOf("Vector") == -1) && !(_data is Array))
				{
					throw new Error("List.data must be either an Array, Vector, or Dictionary!");
				}

				// push each element into an array so it can be iterated over in createChildren()
				for each (var element:* in _data)
				{
					_dataArray.push(element);
				}
			}

			createChildren();
		}

		public function get divider():DisplayObject
		{
			return _divider;
		}

		public function set divider(divider:DisplayObject):void
		{
			_divider = divider;
			createChildren();
		}

		public function get itemRenderer():Class
		{
			return _itemRenderer;
		}

		public function set itemRenderer(value:Class):void
		{
			_itemRenderer = value;

			if (!_itemRenderer)
			{
				_itemRenderer = DefaultItemRenderer;
			}

			createChildren();
		}

		public function get itemsPerPage():int
		{
			return _itemsPerPage;
		}

		public function set itemsPerPage(itemsPerPage:int):void
		{
			_itemsPerPage = itemsPerPage;
			createChildren();
		}

		public function get page():int
		{
			return _page;
		}

		public function set page(page:int):void
		{
			if (page == _page)
			{
				return;
			}

			if (_pageEffect)
			{
				_pageEffect.prePlay(_container, _page, page);
			}

			_page = Math.min(Math.max(0, page), pages - 1);

			createChildren();

			if (_pageEffect)
			{
				_pageEffect.play(_container);
			}
		}

		public function get pageEffect():ListPageEffect
		{
			return _pageEffect;
		}

		public function set pageEffect(pageEffect:ListPageEffect):void
		{
			_pageEffect = pageEffect;
		}

		public function get pages():int
		{
			if (!_dataArray)
			{
				return 0;
			}

			return Math.ceil(_dataArray.length / itemsPerPage);
		}

		public function get selected():IItemRenderer
		{
			return _selected;
		}

		public function set selected(value:IItemRenderer):void
		{
			_selected = value;
			_container.dispatchEvent(new ListEvent(ListEvent.SELECTED));
		}

		public function get selectedIndex():int
		{
			return _container.getChildIndex(DisplayObject(_selected));
		}
	}
}
