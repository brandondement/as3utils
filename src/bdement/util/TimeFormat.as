package bdement.util
{

	public final class TimeFormat
	{

		////////////////////////////////////////////////////////////
		//   CONSTANTS 
		////////////////////////////////////////////////////////////

		public static const DAYS:String = "d";

		public static const DELIMITER:String = " ";

		public static const HOURS:String = "h";

		public static const MINUTES:String = "m";

		public static const SECONDS:String = "s";

		////////////////////////////////////////////////////////////
		//   CLASS ATTRIBUTES 
		////////////////////////////////////////////////////////////

		public static var DAYS_CHARACTER:String = "d";

		public static var DELIMITER_CHARACTER:String = " ";

		public static var HOURS_CHARACTER:String = "h";

		public static var MINUTES_CHARACTER:String = "m";

		public static var SECONDS_CHARACTER:String = "s";

		////////////////////////////////////////////////////////////
		//   CLASS METHODS 
		////////////////////////////////////////////////////////////

		/**
		 *
		 * @param timePeriod
		 * @param format
		 * @return A String that looks like "1d 23h 53m 47s"
		 *
		 */
		public static function format(timePeriod:TimePeriod, format:String = "d h m s"):String
		{
			timePeriod = timePeriod.clone();
			var chars:Array = format.split("");
			var returnString:String = "";

			for (var i:int = 0; i < chars.length; i++)
			{
				switch (chars[i])
				{
					case DAYS:
						if (timePeriod.days > 0)
						{
							returnString += String(timePeriod.days) + DAYS_CHARACTER;
							timePeriod.start += timePeriod.days * TimePeriod.MS_IN_DAY;
						}
						break;

					case HOURS:
						if (timePeriod.hours > 0 || returnString != "")
						{
							returnString += String(timePeriod.hours) + HOURS_CHARACTER;
							timePeriod.start += timePeriod.hours * TimePeriod.MS_IN_HOUR;
						}
						break;

					case MINUTES:
						if (timePeriod.minutes > 0 || returnString != "")
						{
							if (timePeriod.minutes < 10)
							{
								returnString += "0";
							}
							returnString += timePeriod.minutes + MINUTES_CHARACTER;
							timePeriod.start += timePeriod.minutes * TimePeriod.MS_IN_MIN;
						}
						break;

					case SECONDS:
						if (timePeriod.seconds < 10)
						{
							returnString += "0";
						}
						returnString += timePeriod.seconds + SECONDS_CHARACTER;
						timePeriod.start += timePeriod.seconds * TimePeriod.MS_IN_SEC;
						break;

					case DELIMITER_CHARACTER:
						// don't add spaces to the beginning of the string
						if (returnString != "")
						{
							returnString += DELIMITER_CHARACTER;
						}
						break;

					default:
						throw new Error("Unknown format type: " + chars[i]);
						break;
				}
			}

			return returnString;
		}

		/**
		 * returns format 1d 1h
		 */
		public static function formatTime(time:Number):String
		{
			var intTime:int = Math.floor(time);
			var hours:uint = Math.floor(intTime / 3600);
			var days:uint = Math.floor(hours / 24);
			var minutes:uint = (intTime - (hours * 3600)) / 60;
			var seconds:uint = intTime - (hours * 3600) - (minutes * 60);
			var dayString:String =  days > 0 ? days + DAYS + DELIMITER : "";
			var hourString:String =  hours > 0 ? hours + HOURS + DELIMITER : "";
			var minuteString:String = (minutes < 10 ? "0" : "") + minutes + MINUTES + DELIMITER;
			var secondString:String = (seconds < 10 ? "0" : "") + seconds + SECONDS;
			return dayString + hourString + minuteString + secondString;
		}
	}
}
