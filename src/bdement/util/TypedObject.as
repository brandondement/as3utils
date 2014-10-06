package bdement.util
{

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import logging.ILogger;
	import logging.getLogger;

	public class TypedObject extends EventDispatcher
	{

		////////////////////////////////////////////////////////////
		//   CONSTANTS 
		////////////////////////////////////////////////////////////

		private static const _logger:ILogger = getLogger(TypedObject);

		////////////////////////////////////////////////////////////
		//   ATTRIBUTES 
		////////////////////////////////////////////////////////////

		private var _untyped:Object;

		////////////////////////////////////////////////////////////
		//   CONSTRUCTOR 
		////////////////////////////////////////////////////////////

		public function TypedObject(untyped:Object)
		{
			super();
			change(untyped);
		}

		////////////////////////////////////////////////////////////
		//   PUBLIC API 
		////////////////////////////////////////////////////////////

		public function change(untyped:Object):void
		{
			for (var field:String in untyped)
			{
				try
				{
					this[field] = untyped[field];
				}
				catch (e:TypeError)
				{
					//TODO: apply non-primitive fields
					_logger.warn(e.name + ": " + e.message);
				}
				catch (e:ReferenceError)
				{
					// can't apply a non-existent field
					_logger.warn(e.name + ": " + e.message);
				}

			}

			_untyped = untyped;

			dispatchEvent(new Event(Event.CHANGE));
		}

		////////////////////////////////////////////////////////////
		//   GETTERS / SETTERS 
		////////////////////////////////////////////////////////////

		public function get untyped():Object
		{
			return _untyped;
		}
	}
}
