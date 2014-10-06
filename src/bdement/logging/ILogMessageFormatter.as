package bdement.logging
{

	public interface ILogMessageFormatter
	{
		function format(message:LogMessage):String;
	}
}
