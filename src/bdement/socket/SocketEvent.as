package bdement.socket
{

	import flash.events.Event;

	public class SocketEvent extends Event
	{

		////////////////////////////////////////////////////////////
		//   CONSTANTS 
		////////////////////////////////////////////////////////////

		public static const CONNECTION_ERROR:String = "CONNECTION_ERROR";

		public static const CONNECTION_LOST:String = "CONNECTION_NOT_FOUND";

		public static const CONNECTION_SUCCESS:String = "CONNECTION_SUCCESS";

		////////////////////////////////////////////////////////////
		//   CONSTRUCTOR 
		////////////////////////////////////////////////////////////

		public function SocketEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
