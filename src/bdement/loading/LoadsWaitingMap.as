package bdement.loading
{

	import bdement.collections.priorityqueue.ArrayPriorityQueue;
	import bdement.collections.priorityqueue.IPrioritizable;
	import bdement.collections.priorityqueue.IPriorityQueue;
	import bdement.loading.loaditems.ILoadItem;
	import bdement.loading.loaditems.LoadItem;
	import flash.utils.Dictionary;

	internal final class LoadsWaitingMap
	{

		////////////////////////////////////////////////////////////
		//   ATTRIBUTES 
		////////////////////////////////////////////////////////////

		private var _loadsWaiting:int = 0;

		private var _map:Dictionary;

		private var _queue:IPriorityQueue;

		////////////////////////////////////////////////////////////
		//   CONSTRUCTOR 
		////////////////////////////////////////////////////////////

		public function LoadsWaitingMap()
		{
			constructor();
		}

		private function constructor():void
		{
			_map = new Dictionary(false);
			_queue = new ArrayPriorityQueue();
		}

		////////////////////////////////////////////////////////////
		//   PUBLIC API 
		////////////////////////////////////////////////////////////

		public function add(loadItem:ILoadItem):ILoadItem
		{
			var url:String = loadItem.url;

			if (_map[url] == null)
			{
				_map[url] = new <ILoadItem>[];

				// only add the first load item of a particular URL to the queue
				_queue.add(loadItem);
			}

			var loadItems:Vector.<ILoadItem> = _map[url];
			loadItems.push(loadItem);

			_loadsWaiting++;

			return loadItem;
		}

		public function contains(loadItem:ILoadItem):Boolean
		{
			return _map[loadItem.url] != null;
		}

		public function getNext():ILoadItem
		{
			var next:ILoadItem = ILoadItem(_queue.getNext());
//			remove(next);
			return next;
		}

		public function remove(loadItem:ILoadItem):Vector.<ILoadItem>
		{
			var loadItems:Vector.<ILoadItem> = _map[loadItem.url];
			delete _map[loadItem.url];

			// only decrement loadsInProgress IF an item was found and removed
			if (loadItems)
			{
				_loadsWaiting -= loadItems.length;
			}

			_queue.remove(loadItem);

			return loadItems;
		}

		public function toVector():Vector.<ILoadItem>
		{
			var waiting:Vector.<ILoadItem> = new Vector.<ILoadItem>();

			// get ALL (including duplicates) from the map
			// (the queue only contains the 1st of each URL)
			for each (var list:Vector.<ILoadItem> in _map)
			{
				for each (var item:ILoadItem in list)
				{
					waiting.push(item);
				}
			}

			// sort the list into the expected order
			waiting.sort(sortWaitingList);

			return waiting;
		}

		////////////////////////////////////////////////////////////
		//   PRIVATE METHODS 
		////////////////////////////////////////////////////////////

		private function sortWaitingList(a:ILoadItem, b:ILoadItem):int
		{
			if (a.priority > b.priority)
			{
				return -1;
			}
			else if (a.priority < b.priority)
			{
				return 1;
			}

			return 0;
		}

		////////////////////////////////////////////////////////////
		//   GETTERS / SETTERS 
		////////////////////////////////////////////////////////////

		public function get isEmpty():Boolean
		{
			return _queue.isEmpty;
		}

		public function get queue():IPriorityQueue
		{
			return _queue;
		}
	}
}
