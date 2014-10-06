package bdement.config.events
{

	import flash.events.ErrorEvent;

	public final class ConfigErrorEvent extends ErrorEvent
	{

		////////////////////////////////////////////////////////////
		//   CONSTANTS 
		////////////////////////////////////////////////////////////

		public static const LOAD_ERROR:String = "loadError";

		public static const PARSE_ERROR:String = "parseError";

		////////////////////////////////////////////////////////////
		//   CONSTRUCTOR 
		////////////////////////////////////////////////////////////

		public function ConfigErrorEvent(type:String, text:String = "")
		{
			super(type, false, false, text);
		}
	}
}