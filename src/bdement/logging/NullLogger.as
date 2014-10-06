package bdement.logging
{

	public final class NullLogger implements ILogger
	{

		////////////////////////////////////////////////////////////
		//   CONSTRUCTOR 
		////////////////////////////////////////////////////////////

		public function NullLogger()
		{
		}

		////////////////////////////////////////////////////////////
		//   PUBLIC API 
		////////////////////////////////////////////////////////////

		public function debug(... messageBody):void
		{
		}

		public function error(... messageBody):void
		{
		}

		public function fatal(... messageBody):void
		{
		}

		public function info(... messageBody):void
		{
		}

		public function warn(... messageBody):void
		{
		}
	}
}
