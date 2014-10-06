package bdement.logging
{

	////////////////////////////////////////////////////////////
	//   PUBLIC API 
	////////////////////////////////////////////////////////////

	public function useLog(log:ILog):void
	{
		var oldLog:ILog = _log;

		// transfer any existing targets to the new log
		for each (var target:ILogTarget in oldLog.targets)
		{
			log.addTarget(target);
		}

		// transfer any existing loggers to the new log
		for each (var logger:ILogger in oldLog.loggers)
		{
			log.addLogger(logger);
		}

		_log = log;
	}
}
