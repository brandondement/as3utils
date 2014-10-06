package bdement.rest
{

	import flash.events.Event;

	public final class RestServiceEvent extends Event
	{

		////////////////////////////////////////////////////////////
		//   CONSTANTS 
		////////////////////////////////////////////////////////////

		public static const COMPLETE:String = "RestServiceRequestEvent.COMPLETE";

		public static const ERROR:String = "RestServiceRequestEvent.ERROR";

		////////////////////////////////////////////////////////////
		//   CONSTRUCTOR 
		////////////////////////////////////////////////////////////

		public function RestServiceEvent(type:String)
		{
			super(type, bubbles, cancelable);
		}
	}
}
