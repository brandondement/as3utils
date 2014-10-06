package bdement.assets
{

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	public final class AssetCache
	{

		////////////////////////////////////////////////////////////
		//   ATTRIBUTES 
		////////////////////////////////////////////////////////////

		private var _cache:Dictionary;

		////////////////////////////////////////////////////////////
		//   CONSTRUCTOR 
		////////////////////////////////////////////////////////////

		public function AssetCache()
		{
			constructor();
		}

		private function constructor():void
		{
			// explicitly use strong references in this dictionary,
			// that's what a cache is for!
			_cache = new Dictionary(false);
		}

		////////////////////////////////////////////////////////////
		//   CLASS METHODS 
		////////////////////////////////////////////////////////////

		public static function clone(asset:*):*
		{
			if (asset is ByteArray)
			{
				var clone:ByteArray = new ByteArray();
				clone.writeBytes(ByteArray(asset));
				return clone;
			}
			else if (asset is Bitmap)
			{
				return new Bitmap(Bitmap(asset).bitmapData, PixelSnapping.NEVER, true);
			}
			else if (asset is BitmapData)
			{
				return new Bitmap(BitmapData(asset), PixelSnapping.NEVER, true);
			}
			else if (asset is Array)
			{
				return new Array(asset);
			}
			return asset;
		}

		////////////////////////////////////////////////////////////
		//   PUBLIC API 
		////////////////////////////////////////////////////////////

		public function add(url:String, asset:*):void
		{
			_cache[url] = asset;
		}

		public function contains(url:String):Boolean
		{
			return _cache[url] != null;
		}

		public function get(url:String):*
		{
			var asset:Object = _cache[url];
			return clone(asset);
		}

		public function remove(url:String):*
		{
			var asset:Object = get(url);

			_cache[url] = null;
			delete _cache[url];

			return asset;
		}
	}
}
