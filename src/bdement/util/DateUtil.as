package bdement.util
{

	public class DateUtil
	{
		public static function getCurrentGMT():String
		{
			var timestamp:Date = new Date();
			var timezoneOffset:Number = timestamp.timezoneOffset / 60;
			var timezoneSign:String = (timezoneOffset > 0) ? "-" : "+";

			return "GMT" + timezoneSign + (timezoneOffset < 10 ? "0" + timezoneOffset : timezoneOffset) + "00";
		}
	}
}
