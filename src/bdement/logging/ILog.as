package bdement.logging
{

	public interface ILog
	{
		function addLogger(logger:ILogger):void;
		function addTarget(logger:ILogTarget):void;
		function getLogger(category:*):ILogger;
		function log(message:LogMessage):void;
		function removeTarget(logger:ILogTarget):void;

		[ArrayElementType("logging.ILogger")]
		function get loggers():Array;

		[ArrayElementType("logging.ILogTarget")]
		function get targets():Array;
	}
}
