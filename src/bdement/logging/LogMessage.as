package bdement.logging
{

	public class LogMessage
	{

		////////////////////////////////////////////////////////////
		//   ATTRIBUTES 
		////////////////////////////////////////////////////////////

		public var category:String;

		public var fields:Array;

		public var level:String;

		public var timestamp:Date;

		////////////////////////////////////////////////////////////
		//   CONSTRUCTOR 
		////////////////////////////////////////////////////////////

		public function LogMessage(category:String, level:String, fields:Array)
		{
			this.category = category;
			this.level = level;
			this.fields = fields;

			timestamp = new Date();
		}
	}
}
