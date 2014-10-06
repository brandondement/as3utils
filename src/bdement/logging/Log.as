package bdement.logging
{

	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;

	public class Log implements ILog
	{

		////////////////////////////////////////////////////////////
		//   ATTRIBUTES 
		////////////////////////////////////////////////////////////

		private var _loggers:Dictionary;

		[ArrayElementType("logging.ILogTarget")]
		private var _targets:Array;

		////////////////////////////////////////////////////////////
		//   CONSTRUCTOR 
		////////////////////////////////////////////////////////////

		public function Log()
		{
			_loggers = new Dictionary();
			_targets = new Array();
		}

		////////////////////////////////////////////////////////////
		//   PUBLIC API 
		////////////////////////////////////////////////////////////

		public function addLogger(logger:ILogger):void
		{
			logger.log = this;
			_loggers[logger.category] = logger;
		}

		public function addTarget(logTarget:ILogTarget):void
		{
			for each (var oldTarget:ILogTarget in _targets)
			{
				// replace target of same type
				if (getQualifiedClassName(oldTarget) == getQualifiedClassName(logTarget))
				{
					_targets[_targets.indexOf(oldTarget)] = logTarget;
					return;
				}
			}

			_targets.push(logTarget);
		}

		public function getLogger(category:*):ILogger
		{
			var name:String = getQualifiedClassName(category);

			// strip out package names
			if (name.indexOf("::") != -1)
			{
				name = name.split("::")[1];
			}

//			if (!_loggers[name])
//			{
			var logger:ILogger = new Logger(this, name);
			addLogger(logger);
//			}

			return logger;
		}

		public function log(message:LogMessage):void
		{
			for each (var target:ILogTarget in _targets)
			{
				target.log(message);
			}
		}

		public function removeTarget(target:ILogTarget):void
		{
			_targets.splice(_targets.indexOf(target), 1);
		}

		////////////////////////////////////////////////////////////
		//   GETTERS / SETTERS 
		////////////////////////////////////////////////////////////

		public function get loggers():Array
		{
			var loggers:Array = new Array();

			for (var category:Object in _loggers)
			{
				loggers.push(_loggers[category]);
			}

			return loggers.concat();
		}

		public function get targets():Array
		{
			return _targets.concat();
		}
	}
}
