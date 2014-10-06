package bdement.logging
{

	import flash.external.ExternalInterface;
	import core.JavaScriptObject;

	public class JavaScriptConsoleTarget implements ILogTarget
	{

		////////////////////////////////////////////////////////////
		//   CONSTANTS 
		////////////////////////////////////////////////////////////

		public static const DEBUG:String = "debug";

		public static const ERROR:String = "error";

		public static const LOG:String = "log";

		public static const WARN:String = "warn";

		////////////////////////////////////////////////////////////
		//   ATTRIBUTES 
		////////////////////////////////////////////////////////////

		public var level:String = DEBUG;

		private var _formatter:ILogMessageFormatter;

		////////////////////////////////////////////////////////////
		//   CONSTRUCTOR 
		////////////////////////////////////////////////////////////

		public function JavaScriptConsoleTarget(formatter:ILogMessageFormatter):void
		{
			_formatter = formatter;
		}

		////////////////////////////////////////////////////////////
		//   PUBLIC API 
		////////////////////////////////////////////////////////////

		public function log(message:LogMessage):void
		{
			var output:String = _formatter.format(message);
			ExternalInterface.call('console.' + level, output);
		}
	}
}
