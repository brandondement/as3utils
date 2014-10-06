package bdement.util
{

	public class TimePeriod
	{

		////////////////////////////////////////////////////////////
		//   CONSTANTS 
		////////////////////////////////////////////////////////////

		public static const HOURS_IN_DAY:Number = 24;

		public static const MINS_IN_HOUR:Number = 60;

		public static const MS_IN_DAY:Number = 1000 * 60 * 60 * 24;

		public static const MS_IN_HOUR:Number = 1000 * 60 * 60;

		public static const MS_IN_MIN:Number = 1000 * 60;

		public static const MS_IN_SEC:Number = 1000;

		public static const SECS_IN_MIN:Number = 60;

		////////////////////////////////////////////////////////////
		//   ATTRIBUTES 
		////////////////////////////////////////////////////////////

		private var _end:Number;

		private var _start:Number;

		////////////////////////////////////////////////////////////
		//   CONSTRUCTOR 
		////////////////////////////////////////////////////////////

		public function TimePeriod(start:Number, end:Number)
		{
			if (start > end)
			{
				end = start;
			}

			this.start = start;
			this.end = end;
		}

		////////////////////////////////////////////////////////////
		//   PUBLIC API 
		////////////////////////////////////////////////////////////

		public function clone():TimePeriod
		{
			return new TimePeriod(start, end);
		}

		////////////////////////////////////////////////////////////
		//   GETTERS / SETTERS 
		////////////////////////////////////////////////////////////

		public function get days():int
		{
			return Math.floor(length / MS_IN_DAY);
		}

		public function get daysLeft():int
		{
			return Math.floor(timeLeft / MS_IN_DAY);
		}

		public function get end():Number
		{
			return _end;
		}

		public function set end(value:Number):void
		{
			_end = value;
		}

		public function get hours():int
		{
			return Math.floor(length / MS_IN_HOUR);
		}

		public function get hoursLeft():int
		{
			return Math.floor(timeLeft / MS_IN_HOUR);
		}

		public function get length():Number
		{
			return end - start;
		}

		public function get minutes():int
		{
			return Math.floor(length / MS_IN_MIN);
		}

		public function get minutesLeft():int
		{
			return Math.floor(timeLeft / MS_IN_MIN);
		}

		public function get progress():Number
		{
			return 1 - (timeLeft / length);
		}

		public function get seconds():int
		{
			return Math.floor(length / MS_IN_SEC);
		}

		public function get secondsLeft():int
		{
			return Math.floor(timeLeft / MS_IN_SEC);
		}

		public function get start():Number
		{
			return _start;
		}

		public function set start(value:Number):void
		{
			_start = value;
		}

		public function get timeLeft():Number
		{
			return Math.max(0, end - new Date().time);
		}

		public function get timePeriodLeft():TimePeriod
		{
			// if the time period left is less than 0, create a 0 length TimePeriod
			var nextStart:Number = new Date().time;
			nextStart = (nextStart < this.end) ? nextStart : end;

			return new TimePeriod(nextStart, end);
		}
	}
}
