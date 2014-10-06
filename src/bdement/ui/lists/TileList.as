package bdement.ui.lists
{

	import bdement.ui.containers.TileGroup;
	import bdement.ui.effects.ListPageEffect;
	import flash.display.DisplayObject;

	[DefaultProperty("data")]
	public class TileList extends TileGroup implements IList
	{

		////////////////////////////////////////////////////////////
		//   ATTRIBUTES 
		////////////////////////////////////////////////////////////

		private var _list:AbstractList;

		////////////////////////////////////////////////////////////
		//   CONSTRUCTOR 
		////////////////////////////////////////////////////////////

		public function TileList(rows:int = 1, cols:int = 1, horizontalGap:Number = 10, verticalGap:Number = 10, itemRenderer:Class = null, data:* = null)
		{
			super(rows, cols, horizontalGap, verticalGap);

			_list = new AbstractList(this);
			_list.itemRenderer = itemRenderer;
			_list.data = data;
		}

		////////////////////////////////////////////////////////////
		//   PUBLIC API 
		////////////////////////////////////////////////////////////

		public override function dispose():void
		{
			_list.dispose();
			super.dispose();
		}

		////////////////////////////////////////////////////////////
		//   GETTERS / SETTERS 
		////////////////////////////////////////////////////////////

		public function get data():*
		{
			return _list.data;
		}

		public function set data(value:*):void
		{
			_list.data = value;
		}

		public function get divider():DisplayObject
		{
			return _list.divider;
		}

		public function set divider(divider:DisplayObject):void
		{
			_list.divider = divider;
		}

		public function get itemRenderer():Class
		{
			return _list.itemRenderer;
		}

		public function set itemRenderer(value:Class):void
		{
			_list.itemRenderer = value;
		}

		public function get itemsPerPage():int
		{
			return _list.itemsPerPage;
		}

		public function set itemsPerPage(itemsPerPage:int):void
		{
			_list.itemsPerPage = itemsPerPage;
		}

		public function get list():AbstractList
		{
			return _list;
		}

		public function get page():int
		{
			return _list.page;
		}

		public function set page(page:int):void
		{
			_list.page = page;
		}

		public function get pageEffect():ListPageEffect
		{
			return _list.pageEffect;
		}

		public function set pageEffect(pageEffect:ListPageEffect):void
		{
			_list.pageEffect = pageEffect;
		}

		public function get pages():int
		{
			return _list.pages;
		}

		public function get selected():IItemRenderer
		{
			return _list.selected;
		}

		public function set selected(item:IItemRenderer):void
		{
			_list.selected = item;
		}

		public function get selectedIndex():int
		{
			return _list.selectedIndex;
		}
	}
}
