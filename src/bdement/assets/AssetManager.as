package bdement.assets
{

	import bdement.loading.ILoadService;
	import bdement.loading.events.LoadErrorEvent;
	import bdement.loading.events.LoadEvent;
	import bdement.loading.loaditems.BatchLoadItem;
	import bdement.loading.loaditems.BitmapLoadItem;
	import bdement.loading.loaditems.ILoadItem;
	import bdement.loading.loaditems.LoadItem;
	import bdement.loading.loaditems.SWFLoadItem;
	import bdement.logging.ILogger;
	import bdement.logging.getLogger;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.utils.Dictionary;

	/**
	 * <xml>
	 *   <bundle id="bundleId" path=".">
	 *     <asset id="assetId" url="image.png" />
	 *   </bundle>
	 * </xml>
	 */
	public class AssetManager implements IAssetManager
	{

		////////////////////////////////////////////////////////////
		//   CONSTANTS 
		////////////////////////////////////////////////////////////

		private static const logger:ILogger = getLogger(AssetManager);

		////////////////////////////////////////////////////////////
		//   ATTRIBUTES 
		////////////////////////////////////////////////////////////

		public var assetCache:AssetCache;

		[Inject]
		public var loadService:ILoadService;

		private var _callbacks:Dictionary

		private var _xml:XML;

		////////////////////////////////////////////////////////////
		//   CONSTRUCTOR 
		////////////////////////////////////////////////////////////

		public function AssetManager()
		{
			assetCache = new AssetCache();
			_callbacks = new Dictionary(false);
		}

		////////////////////////////////////////////////////////////
		//   PUBLIC API 
		////////////////////////////////////////////////////////////

		public function getBitmap(assetId:String, completeCallback:Function):void
		{
			getAsset(assetId, completeCallback);
		}

		public function getSound(assetId:String, completeCallback:Function):void
		{
			getAsset(assetId, completeCallback);
		}

		public function getSWFObject(id:String, completeCallback:Function):void
		{
			getAsset(id, completeCallback);
		}

		public function isBundleLoaded(bundleId:String):Boolean
		{
			var bundle:XMLList = _xml.bundle.(@id == bundleId);
			var assets:XMLList = bundle.asset;

			// look to see if each asset in this bundle is cached
			for each (var asset:XML in bundle.asset)
			{
				var url:String = bundle.@path + asset.@url;

				if (!assetCache.contains(url))
				{
					return false;
				}
			}

			return true;
		}

		public function loadBundle(bundleId:String, completeCallback:Function):Array
		{
			var bundle:XMLList = _xml.bundle.(@id == bundleId);
			var assets:XMLList = bundle.asset;
			var loadItems:Array = new Array();

			// load any bundles that this bundle depends on
			if (bundle.@depends != "")
			{
				var dependencies:Array = bundle.@depends.split(",");

				for each (var dependency:String in dependencies)
				{
					var parentItems:Array = loadBundle(dependency, null);

					// if we got any parent items, add them to our list
					for each (var parentItem:LoadItem in parentItems)
					{
						loadItems.push(parentItem);
					}
				}
			}

			// create an array of loaditems to load the assets in this bundle
			for each (var asset:XML in assets)
			{
				var url:String = bundle.@path + asset.@url;
				var loadItem:LoadItem = createLoadItem(url, asset.@symbol);

				// if we already have this asset cached, no need to reload it
				if (assetCache.contains(url))
				{
					loadItem.asset = assetCache.get(url);
				}

				loadItems.push(loadItem);
			}

			// if the bundle is already cached, just call the callback
			if (isBundleLoaded(bundleId))
			{
				// logger.debug("bundle " + bundleId + " already cached");

				if (completeCallback != null)
				{
					completeCallback(loadItems);
				}

				return loadItems;
			}

			// logger.debug("Loading bundle " + bundleId);

			// load the bundle
			var batch:BatchLoadItem = new BatchLoadItem(loadItems);
			addLoadItemListeners(batch);

			// save the callback
			_callbacks[batch] = completeCallback;

			loadService.load(batch);

			return loadItems;
		}

		////////////////////////////////////////////////////////////
		//   EVENT HANDLERS 
		////////////////////////////////////////////////////////////

		protected function onAssetError(event:LoadErrorEvent):void
		{
			var loadItem:ILoadItem = ILoadItem(event.target);
			logger.error("Error loading " + loadItem.url);
		}

		protected function onAssetLoaded(event:Event):void
		{
			var loadItem:LoadItem = LoadItem(event.target);

			// logger.debug("onAssetLoaded", "loaded " + loadItem.url);

			completeItem(loadItem);
		}

		protected function onBundleComplete(event:Event):void
		{
			var batch:BatchLoadItem = BatchLoadItem(event.target);
			batch.removeEventListener(LoadEvent.COMPLETE, onBundleComplete);

			// logger.debug("onBundleComplete", "Bundle loaded " + batch.url);

			// add the loaded bundle to the asset cache
			for each (var item:LoadItem in batch.items)
			{
				completeItem(item);
			}

			callback(batch);
		}

		protected function onBundleError(event:LoadErrorEvent):void
		{
			logger.error("onBundleError", "method called");
		}

		////////////////////////////////////////////////////////////
		//   PRIVATE METHODS 
		////////////////////////////////////////////////////////////

		private function addLoadItemListeners(loadItem:ILoadItem):void
		{
			if (loadItem is BatchLoadItem)
			{
				loadItem.addEventListener(LoadEvent.COMPLETE, onBundleComplete);
				loadItem.addEventListener(LoadErrorEvent.ERROR, onBundleError);
				return;
			}

			loadItem.addEventListener(LoadEvent.COMPLETE, onAssetLoaded);
			loadItem.addEventListener(LoadErrorEvent.ERROR, onAssetError);
		}

		private function callback(loadItem:ILoadItem):void
		{
			// only proceed if the callback exists
			if (!_callbacks[loadItem])
			{
				return;
			}

			var f:Function = _callbacks[loadItem];

			// call the callback
			if (loadItem is BatchLoadItem)
			{
				var items:Array = BatchLoadItem(loadItem).items;
				f(items);
			}
			else if (loadItem is SWFLoadItem)
			{
				var symbol:DisplayObject = SWFLoadItem(loadItem).symbol;
				f(symbol);
			}
			else
			{
				f(loadItem.asset);
			}

			// cleanup
			_callbacks[loadItem] = null;
			delete _callbacks[loadItem];
		}

		private function completeItem(loadItem:ILoadItem):void
		{
			removeLoadItemListeners(loadItem);
			assetCache.add(loadItem.url, loadItem.asset);
			callback(loadItem);
		}

		private function createLoadItem(url:String, symbolName:String = null):LoadItem
		{
			var extension:String = url.substr(url.lastIndexOf(".") + 1).toLowerCase();

			// figure out what type of LoadItem we need to load this asset
			switch (extension)
			{
				case "jxr":
				case "png":
				case "gif":
				case "jpg":
				case "jpeg":
					return new BitmapLoadItem(url);
					break;

				case "swf":
					return new SWFLoadItem(url, symbolName);
					break;

				default:
					logger.warn("extension not supported: " + extension);
					break;
			}

			return null;
		}

		private function getAsset(id:String, callbackFunction:Function):void
		{
			var assetList:XMLList = _xml.descendants("asset").(@id == id);

			switch (assetList.length())
			{
				case 0:
					logger.error("Couldn't find asset with id: " + id);
					return;
				case 1:
					// this is what we want, nothing to do here 
					break;
				default:
					logger.error("Found more than 1 assets with ID " + id + "!");
					break;
			}

			var assetNode:XML = assetList[0];
			var bundle:XML = assetNode.parent();
			var url:String = bundle.@path + assetNode.@url;

			if (assetCache.contains(url))
			{
				// logger.debug("returning cached asset");
				var asset:* = assetCache.get(url);
				callbackFunction(asset);
				return;
			}

			// logger.debug("loading asset '" + id + "' from " + url);

			var loadItem:LoadItem = createLoadItem(url, assetNode.@symbol);
			addLoadItemListeners(loadItem);

			_callbacks[loadItem] = callbackFunction;

			loadService.load(loadItem);
		}

		private function removeLoadItemListeners(loadItem:ILoadItem):void
		{
			loadItem.removeEventListener(LoadEvent.COMPLETE, onBundleComplete);
			loadItem.removeEventListener(LoadEvent.COMPLETE, onAssetLoaded);

			loadItem.removeEventListener(LoadErrorEvent.ERROR, onAssetError);
			loadItem.removeEventListener(LoadErrorEvent.ERROR, onBundleError);
		}

		////////////////////////////////////////////////////////////
		//   GETTERS / SETTERS 
		////////////////////////////////////////////////////////////

		public function get xml():XML
		{
			return _xml;
		}

		public function set xml(value:XML):void
		{
			_xml = value;
		}
	}
}
