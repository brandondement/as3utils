package bdement.logging
{

	public class DefaultLogMessageFormatter implements ILogMessageFormatter
	{

		////////////////////////////////////////////////////////////
		//   PUBLIC API 
		////////////////////////////////////////////////////////////

		public static const SPACES_PER_TAB:int = 8;

		private static const TAB:String = "\t";
		
		public function format(message:LogMessage):String
		{
			var time:String = padTimestamp(message.timestamp);
			var category:String = message.category.substr(0, 17);
			var output:String = new String().concat("[", message.level, "]", TAB, time, " ", category);

			// line up the next column
			output = spacePad(output, SPACES_PER_TAB * 4)

			var fields:Array = message.fields;

			for (var i:int = 0; i < fields.length; i++)
			{
				var field:String = fields[i];

				if (i == 0)
				{
					field = spacePad(field, SPACES_PER_TAB * 2);
				}

				output = output.concat(TAB, field);
			}

			return output;
		}

		////////////////////////////////////////////////////////////
		//   PRIVATE METHODS 
		////////////////////////////////////////////////////////////

		private function padTimestamp(timestamp:Date):String
		{
			var hours:String = zeroPad(timestamp.getHours(), 2);
			var minutes:String = zeroPad(timestamp.getMinutes(), 2);
			var seconds:String = zeroPad(timestamp.getSeconds(), 2);
			var millis:String = zeroPad(timestamp.getMilliseconds(), 3);

			return hours + ":" + minutes + ":" + seconds + ":" + millis;
		}

		private function spacePad(value:Object, length:int):String
		{
			var string:String = String(value);

			while (string.length < length)
			{
				string += " ";
			}

			return string;
		}

		private function zeroPad(value:Object, length:int):String
		{
			var string:String = String(value);

			while (string.length < length)
			{
				string = "0" + string;
			}

			return string;
		}
	}
}
