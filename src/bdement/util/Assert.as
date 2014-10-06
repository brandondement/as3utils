package bdement.util
{

	public class Assert
	{

		////////////////////////////////////////////////////////////
		//   CONSTANTS 
		////////////////////////////////////////////////////////////

		public static const DEBUG:String = "DEBUG";

		public static const ERROR:String = "ERROR";

		public static const FATAL:String = "FATAL";

		public static const INFO:String = "INFO";

		public static const WARN:String = "WARN";

		////////////////////////////////////////////////////////////
		//   CLASS METHODS 
		////////////////////////////////////////////////////////////

		public static function assert(condition:Boolean, logMessage:String, logLevel:String = "WARN"):void
		{
			if (condition)
			{
				return;
			}

			switch (logLevel)
			{
				case DEBUG:
					//_logger.debug(logMessage);
					break;

				case INFO:
					//_logger.info(logMessage);
					break;

				default:
				case WARN:
					//_logger.warn(logMessage);
					break;

				case ERROR:
					//_logger.error(logMessage);
					break;

				case FATAL:
					//_logger.fatal(logMessage);
					break;
			}
		}
	}
}
