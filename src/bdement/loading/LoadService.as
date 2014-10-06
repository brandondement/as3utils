package bdement.loading
{

	import com.greensock.loading.core.LoaderItem;
	import bdement.assets.AssetCache;
	import bdement.loading.events.LoadErrorEvent;
	import bdement.loading.events.LoadEvent;
	import bdement.loading.loaditems.BatchLoadItem;
	import bdement.loading.loaditems.ILoadItem;
	import bdement.loading.loaditems.LoadItem;
	import bdement.logging.ILogger;
	import bdement.logging.getLogger;
	import bdement.util.URL;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;

	/**
	 *
	 * var loadService:ILoadService = new LoadService();
	 *
	 * var loadItem:ILoadItem;
	 *
	 * loadItem	= new BitmapLoadItem("http://server/image.png",	LoadPriority.HIGH);
	 * loadItem = new SWFLoadItem("http://server/image.png",	LoadPriority.MEDIUM);
	 * loadItem = new SoundLoadItem("http://server/image.png",	LoadPriority.LOW);
	 * loadItem = new XMLLoadItem("http://server/image.png",	LoadPriority.PRELOAD);
	 * loadItem = new TextLoadItem("http://server/image.png",	LoadPriority.IMMEDIATE);
	 *
	 * loadItem.priority										= LoadPriority.IMMEDIATE;
	 * loadItem.url												= "http://server/asset.jpg";
	 * trace(loadItem.progress);								// 0.0 - 1.0
	 *
	 * loadItem.addEventListener(IOErrorEvent.IO_ERROR,			onIOError);
	 * loadItem.addEventListener(LoadEvent.COMPLETE,			onLoadComplete);
	 *
	 * loadService.load(loadItem);
	 * loadService.cancel(loadItem);
	 *
	 * var bitmap:Bitmap				= Bitmap(bitmapLoadItem.asset);		// will be null until LoadEvent.COMPLETE is fired
	 * bitmap							= bitmapLoadItem.bitmap;			// will be null until LoadEvent.COMPLETE is fired
	 *
	 * var displayObject:DisplayObject	= DisplayObject(swfLoadItem.asset);	// will be null until LoadEvent.COMPLETE is fired
	 * displayObject					= swfLoadItem.displayObject;		// will be null until LoadEvent.COMPLETE is fired
	 *
	 * var sound:Sound					= Sound(soundLoadItem.asset);		// will be null until LoadEvent.COMPLETE is fired
	 * sound							= soundLoadItem.sound;				// will be null until LoadEvent.COMPLETE is fired
	 *
	 * var xml:XML						= XML(xmlLoadItem.asset);			// will be null until LoadEvent.COMPLETE is fired
	 * xml								= xmlLoadItem.xml;					// will be null until LoadEvent.COMPLETE is fired
	 *
	 * var text:String					= String(textLoadItem.asset);		// will be null until LoadEvent.COMPLETE is fired
	 * text								= textLoadItem.text;				// will be null until LoadEvent.COMPLETE is fired
	 *
	 */
	public final class LoadService implements ILoadService
	{

		////////////////////////////////////////////////////////////
		//   CLASS ATTRIBUTES 
		////////////////////////////////////////////////////////////

		private static var _instance:LoadService;

		////////////////////////////////////////////////////////////
		//   ATTRIBUTES 
		////////////////////////////////////////////////////////////

		private var _isPaused:Boolean = false;

		private var _loadsInProgress:LoadsInProgressMap;

		private var _loadsWaiting:LoadsWaitingMap;

		private var _logger:ILogger = getLogger(this);

		private var _maxConnections:int = int.MAX_VALUE;

		////////////////////////////////////////////////////////////
		//   CONSTRUCTOR 
		////////////////////////////////////////////////////////////

		public function LoadService()
		{
			if (_instance)
			{
				_logger.error("LoadService", "There can only be 1 instance of LoadService per application!");
			}

			_instance = this;

			_loadsInProgress = new LoadsInProgressMap();
			_loadsWaiting = new LoadsWaitingMap();
		}

		////////////////////////////////////////////////////////////
		//   PUBLIC API 
		////////////////////////////////////////////////////////////

		public function cancel(loadItem:ILoadItem):void
		{
			loadItem.cancel();
			_loadsInProgress.remove(loadItem);
			_loadsWaiting.remove(loadItem);
			loadNext();
		}

		public function load(loadItem:ILoadItem):void
		{
			// look to see if that asset is already in progress
			if (_loadsInProgress.contains(loadItem))
			{
				_logger.debug("load", "Another instance of " + loadItem.url + " is already laoding");

				// if the asset is already in progress, include this one in
				// the "in progress" list
				_loadsInProgress.add(loadItem);
			}
			else
			{
				_logger.debug("load", "Queueing " + loadItem.url + " for later");

				// if the asset wasn't in progress, add it to the waiting list
				_loadsWaiting.add(loadItem);
			}

			loadNext();
		}

		public function pause():void
		{
			_isPaused = true;
		}

		public function resume():void
		{
			// we want to avoid extra calls to loadNext(), so only resume
			// if we're paused, otherwise do nothing
			if (_isPaused)
			{
				_isPaused = false;
				loadNext();
			}
		}

		////////////////////////////////////////////////////////////
		//   EVENT HANDLERS 
		////////////////////////////////////////////////////////////

		private function onLoadCancel(event:LoadEvent):void
		{
			var loadItem:LoadItem = LoadItem(event.target);
			_loadsInProgress.remove(loadItem);
			_loadsWaiting.remove(loadItem);
			loadNext();
		}

		private function onLoadItemComplete(event:LoadEvent):void
		{
			var completedLoadItem:LoadItem = LoadItem(event.target);

			_logger.debug("onLoadItemComplete", "Loaded " + completedLoadItem.url);

			// intercept the LoadEvent so we can dispatch it (and duplicates) below 
			event.stopImmediatePropagation();

			// get a list of LoadItems that were loading the same thing
			// (includes the original and any duplicates)
			var concurrentLoadItems:Vector.<ILoadItem> = _loadsInProgress.remove(completedLoadItem);

			// apply the asset to the concurrent LoadItems and dispatch their COMPLETE events
			for each (var dupeLoadItem:LoadItem in concurrentLoadItems)
			{
				removeLoadItemListeners(dupeLoadItem);

				if (completedLoadItem is BatchLoadItem)
				{
					duplicateBatch(BatchLoadItem(completedLoadItem), BatchLoadItem(dupeLoadItem));
				}

				_logger.debug("onLoadItemComplete", "Duplicating " + dupeLoadItem.url + " for concurrent load item");

				var clone:* = AssetCache.clone(completedLoadItem.asset);
				dupeLoadItem.asset = clone;
				dupeLoadItem.dispatchEvent(new LoadEvent(LoadEvent.COMPLETE));
			}

			loadNext();
		}

		private function onLoadItemIOError(event:LoadErrorEvent):void
		{
			var loadItem:LoadItem = LoadItem(event.target);
			removeLoadItemListeners(loadItem);
			loadNext();
		}

		////////////////////////////////////////////////////////////
		//   PRIVATE METHODS 
		////////////////////////////////////////////////////////////

		private function addLoadItemListeners(loadItem:ILoadItem):void
		{
			loadItem.addEventListener(LoadErrorEvent.ERROR, onLoadItemIOError, false, 0, false);
			loadItem.addEventListener(LoadEvent.COMPLETE, onLoadItemComplete, false, 0, false);
			loadItem.addEventListener(LoadEvent.CANCEL, onLoadCancel, false, 0, false);
		}

		private function duplicateBatch(completedBatch:BatchLoadItem, duplicateBatch:BatchLoadItem):void
		{
			var dupeItems:Array = duplicateBatch.items;
			var completeItems:Array = completedBatch.items;

			for each (var dupe:LoadItem in dupeItems)
			{
				for each (var complete:LoadItem in completeItems)
				{
					if (complete.url == dupe.url)
					{
						dupe.asset = complete.asset;
					}
				}
			}
		}

		private function loadNext():void
		{
			// stop if we're already loading too many
			if (_loadsInProgress.toVector().length >= _maxConnections)
			{
				return;
			}

			// stop if there's nothing to load
			if (_loadsWaiting.isEmpty)
			{
				// We've finished loading all assets...? yes, for now
				return;
			}

			// stop if we're paused
			if (_isPaused)
			{
				return;
			}

			// get the next item to load
			var loadItem:LoadItem = LoadItem(_loadsWaiting.getNext());

			// listen to the "master" load item for this URL
			addLoadItemListeners(loadItem);

			// find any duplicates that were waiting
			var dupes:Vector.<ILoadItem> = _loadsWaiting.remove(loadItem);

			// add duplicates to the "in progress" list
			for each (var dupe:ILoadItem in dupes)
			{
				_loadsInProgress.add(dupe)
			}

			_logger.debug("loadNext", "Loading " + loadItem.url);

			loadItem.load();
		}

		private function removeLoadItemListeners(loadItem:ILoadItem):void
		{
			loadItem.removeEventListener(LoadErrorEvent.ERROR, onLoadItemIOError);
			loadItem.removeEventListener(LoadEvent.COMPLETE, onLoadItemComplete);
			loadItem.removeEventListener(LoadEvent.CANCEL, onLoadCancel);
		}

		////////////////////////////////////////////////////////////
		//   GETTERS / SETTERS 
		////////////////////////////////////////////////////////////

		public function get loadsInProgress():Vector.<ILoadItem>
		{
			return _loadsInProgress.toVector();
		}

		public function get loadsWaiting():Vector.<ILoadItem>
		{
			return _loadsWaiting.toVector();
		}

		public function get maxConnections():int
		{
			return _maxConnections;
		}

		public function set maxConnections(value:int):void
		{
			_logger.debug("set maxConnections", "maxConnections now " + value + " (was " + _maxConnections + ")");
			_maxConnections = value;
		}
	}
}


