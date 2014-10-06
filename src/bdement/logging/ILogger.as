package bdement.logging
{

	public interface ILogger
	{
		function debug(... messageBody):void;

		function error(... messageBody):void;

		function fatal(... messageBody):void;

		function info(... messageBody):void;

		function warn(... messageBody):void;

		function get category():String;

		function get log():ILog;

		function set log(log:ILog):void;
	}
}
