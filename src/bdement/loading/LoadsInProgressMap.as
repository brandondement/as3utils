package bdement.loading
{

	import bdement.loading.loaditems.ILoadItem;
	import bdement.loading.loaditems.LoadItem;
	import flash.utils.Dictionary;

	internal final class LoadsInProgressMap
	{

		////////////////////////////////////////////////////////////
		//   ATTRIBUTES 
		////////////////////////////////////////////////////////////

		private var _loadsInProgress:int = 0;

		/**
		 * Key: An asset's URL String
		 * Value: A Vector.<LoadItem> of LoadItems loading the URL
		 */
		private var _map:Dictionary;

		////////////////////////////////////////////////////////////
		//   CONSTRUCTOR 
		////////////////////////////////////////////////////////////

		public function LoadsInProgressMap()
		{
			constructor();
		}

		private function constructor():void
		{
			_map = new Dictionary(false);
		}

		////////////////////////////////////////////////////////////
		//   PUBLIC API 
		////////////////////////////////////////////////////////////

		public function add(loadItem:ILoadItem):void
		{
			var url:String = loadItem.url;

			if (_map[url] == null)
			{
				_map[url] = new <ILoadItem>[];
			}

			var loadItems:Vector.<ILoadItem> = _map[url];
			loadItems.push(loadItem);

			_loadsInProgress++;
		}

		public function contains(loadItem:ILoadItem):Boolean
		{
			return _map[loadItem.url] != null;
		}

		public function get(loadItem:ILoadItem):Vector.<ILoadItem>
		{
			return _map[loadItem.url];
		}

		public function remove(loadItem:ILoadItem):Vector.<ILoadItem>
		{
			var loadItems:Vector.<ILoadItem> = _map[loadItem.url];
			delete _map[loadItem.url];

			// only decrement loadsInProgress IF an item was found and removed
			if (loadItems)
			{
				_loadsInProgress -= loadItems.length;
			}

			return loadItems;
		}

		public function toVector():Vector.<ILoadItem>
		{
			var inProgress:Vector.<ILoadItem> = new Vector.<ILoadItem>();

			for each (var vector:Vector.<ILoadItem> in _map)
			{
				for each (var item:ILoadItem in vector)
				{
					inProgress.push(item);
				}
			}

			return inProgress;
		}
	}
}
