package bdement.collections.priorityqueue
{

	import flash.utils.Dictionary;

	public class ArrayPriorityQueue implements IPriorityQueue
	{

		////////////////////////////////////////////////////////////
		//   ATTRIBUTES 
		////////////////////////////////////////////////////////////

		/**
		 * A dictionary used for doing quick contains() lookups
		 */
		private var _map:Dictionary;

		/**
		 * An array of IPrioritizables sorted in descending order by priority
		 */
		private var _queue:Vector.<IPrioritizable>;

		////////////////////////////////////////////////////////////
		//   CONSTRUCTOR 
		////////////////////////////////////////////////////////////

		public function ArrayPriorityQueue()
		{
			constructor();
		}

		private function constructor():void
		{
			_queue = new Vector.<IPrioritizable>();
			_map = new Dictionary(false);
		}

		////////////////////////////////////////////////////////////
		//   PUBLIC API 
		////////////////////////////////////////////////////////////

		public function add(object:IPrioritizable):IPrioritizable
		{
			_map[object] = object;

			if (_queue.length == 0)
			{
				_queue.push(object);
				return object;
			}

			// search linearly through the list and add just before any items
			// that have LOWER priority 
			var priority:int = object.priority;
			var length:int = _queue.length;

			for (var index:int = 0; index < length; index++)
			{
				if (_queue[index].priority < priority)
				{
					_queue.splice(index, 0, object);
					return object;
				}
			}

			// didn't find a position to place it, so add it to the END of the queue 
			_queue.push(object);

			return object;
		}

		public function contains(object:IPrioritizable):Boolean
		{
			return _map[object] != null;
		}

		public function getNext():IPrioritizable
		{
			if (isEmpty)
			{
				return null;
			}

			var next:IPrioritizable = _queue.shift();

			_map[next] = null;
			delete _map[next];

			return next;
		}

		public function peekNext():IPrioritizable
		{
			if (isEmpty)
			{
				return null;
			}

			return _queue[0];
		}

		public function remove(object:IPrioritizable):IPrioritizable
		{
			// remove from the list
			var index:int = _queue.indexOf(object);

			if (index >= 0)
			{
				_queue.splice(index, 1);
			}

			// remove from the map			
			_map[object] = null;
			delete _map[object];

			return object;
		}

		public function toString():String
		{
			var string:String = "[";

			for each (var item:IPrioritizable in _queue)
			{
				string += item.priority + ",";
			}
			string += "]";

			return string;
		}

		public function toVector():Vector.<IPrioritizable>
		{
			return _queue.concat();
		}

		////////////////////////////////////////////////////////////
		//   GETTERS / SETTERS 
		////////////////////////////////////////////////////////////

		public function get isEmpty():Boolean
		{
			return _queue.length == 0;
		}
	}
}
