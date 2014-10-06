package bdement.loading.loaditems
{

	import bdement.loading.events.LoadErrorEvent;
	import bdement.loading.events.LoadEvent;
	import bdement.logging.ILogger;
	import bdement.logging.getLogger;
	import flash.events.Event;
	import flash.utils.getTimer;

	public final class BatchLoadItem extends LoadItem
	{

		////////////////////////////////////////////////////////////
		//   CLASS ATTRIBUTES 
		////////////////////////////////////////////////////////////

		private static var logger:ILogger = getLogger(BatchLoadItem);

		////////////////////////////////////////////////////////////
		//   ATTRIBUTES 
		////////////////////////////////////////////////////////////

		private var _items:Array;

		private var _itemsComplete:int = 0;

		////////////////////////////////////////////////////////////
		//   CONSTRUCTOR 
		////////////////////////////////////////////////////////////

		public function BatchLoadItem(items:Array, priority:int = 0)
		{
			_items = items;
			var id:String = String(getTimer());
			super(id, priority);
		}

		////////////////////////////////////////////////////////////
		//   PUBLIC API 
		////////////////////////////////////////////////////////////

		public override function load():void
		{
			for each (var item:ILoadItem in _items)
			{
				addLoadListeners(item);
				item.load();
			}
		}

		////////////////////////////////////////////////////////////
		//   EVENT HANDLERS 
		////////////////////////////////////////////////////////////

		protected function onLoadCancel(event:LoadEvent):void
		{
			var loadItem:LoadItem = LoadItem(event.target);
			completeItem(loadItem);
		}

		protected override function onLoadComplete(event:Event):void
		{
			var loadItem:LoadItem = LoadItem(event.target);

			logger.debug("onLoadComplete", "Item in batch loaded " + loadItem.url);

			completeItem(loadItem);
		}

		protected function onLoadError(event:LoadErrorEvent):void
		{
			var loadItem:LoadItem = LoadItem(event.target);

			logger.error("onLoadError", "Error loading item in batch: " + loadItem.url);

			completeItem(loadItem);
		}

		////////////////////////////////////////////////////////////
		//   PRIVATE METHODS 
		////////////////////////////////////////////////////////////

		private function addLoadListeners(loadItem:ILoadItem):void
		{
			loadItem.addEventListener(LoadErrorEvent.ERROR, onLoadError, false, 0, true);
			loadItem.addEventListener(LoadEvent.CANCEL, onLoadCancel, false, 0, true);
			loadItem.addEventListener(LoadEvent.COMPLETE, onLoadComplete, false, 0, true);
		}

		private function completeItem(loadItem:ILoadItem):void
		{
			removeLoadListeners(loadItem);

			_itemsComplete++;

			if (_itemsComplete >= _items.length)
			{
				logger.debug("completeItem", "Batch complete " + url);

				dispatchEvent(new LoadEvent(LoadEvent.COMPLETE));
			}
		}

		private function removeLoadListeners(loadItem:ILoadItem):void
		{
			loadItem.removeEventListener(LoadErrorEvent.ERROR, onLoadIOError);
			loadItem.removeEventListener(LoadEvent.CANCEL, onLoadCancel);
			loadItem.removeEventListener(LoadEvent.COMPLETE, onLoadComplete);
		}

		////////////////////////////////////////////////////////////
		//   GETTERS / SETTERS 
		////////////////////////////////////////////////////////////

		[ArrayElementType("bdement.loading.loaditems.ILoadItem")]
		public function get items():Array
		{
			return _items.concat();
		}

		public override function get url():String
		{
			var url:String = "";

			for each (var item:LoadItem in _items)
			{
				url += item.url + ",";
			}

			return url.substr(0, url.length - 1);
		}
	}
}


