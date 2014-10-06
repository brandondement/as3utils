package bdement.profiling
{

	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	public class Profiler
	{

		////////////////////////////////////////////////////////////
		//   CONSTANTS 
		////////////////////////////////////////////////////////////

		private static const PROCESSES:Dictionary = new Dictionary(false);

		////////////////////////////////////////////////////////////
		//   CLASS METHODS 
		////////////////////////////////////////////////////////////

		public static function start(processID:String):void
		{
			var process:Process = PROCESSES[processID] ||= new Process();
			process.id = processID;
			process.startTime = getTimer();
		}

		public static function stop(processID:String):int
		{
			var process:Process = PROCESSES[processID];

			if (!process)
			{
				trace("Unable to stop the process '" + processID + "' because it hasn't been started yet.");
				return -1;
			}

			var totalTime:int = process.totalTime = getTimer() - process.startTime;
			trace(totalTime.toString() + "ms", processID);
			return totalTime;
		}
	}
}

internal class Process
{

	////////////////////////////////////////////////////////////
	//   ATTRIBUTES 
	////////////////////////////////////////////////////////////

	public var id:String = "";

	public var startTime:int = 0;

	public var totalTime:int = 0;
}
