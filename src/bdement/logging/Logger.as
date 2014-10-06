package bdement.logging
{

	public class Logger implements ILogger
	{

		////////////////////////////////////////////////////////////
		//   ATTRIBUTES 
		////////////////////////////////////////////////////////////

		private var _category:String;

		private var _log:ILog;

		////////////////////////////////////////////////////////////
		//   CONSTRUCTOR 
		////////////////////////////////////////////////////////////

		public function Logger(log:ILog, category:String)
		{
			_log = log;
			_category = category;
		}

		////////////////////////////////////////////////////////////
		//   PUBLIC API 
		////////////////////////////////////////////////////////////

		public function get category():String
		{
			return _category;
		}

		public function debug(... messageBody):void
		{
			_log.log(new LogMessage(_category, LogLevel.DEBUG, messageBody));
		}

		public function error(... messageBody):void
		{
			_log.log(new LogMessage(_category, LogLevel.ERROR, messageBody));
		}

		public function fatal(... messageBody):void
		{
			_log.log(new LogMessage(_category, LogLevel.FATAL, messageBody));
		}

		public function info(... messageBody):void
		{
			_log.log(new LogMessage(_category, LogLevel.INFO, messageBody));
		}

		public function warn(... messageBody):void
		{
			_log.log(new LogMessage(_category, LogLevel.WARN, messageBody));
		}

		////////////////////////////////////////////////////////////
		//   GETTERS / SETTERS 
		////////////////////////////////////////////////////////////

		public function get log():ILog
		{
			return _log;
		}

		public function set log(value:ILog):void
		{
			_log = value;
		}
	}
}
