package bdement.ui.lists
{

	import flash.events.Event;

	public final class ListEvent extends Event
	{

		////////////////////////////////////////////////////////////
		//   CONSTANTS 
		////////////////////////////////////////////////////////////

		public static const POPULATED:String = "populated";

		public static const SELECTED:String = "selected";

		////////////////////////////////////////////////////////////
		//   CONSTRUCTOR 
		////////////////////////////////////////////////////////////

		public function ListEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
