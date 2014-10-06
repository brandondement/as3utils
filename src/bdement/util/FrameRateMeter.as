package bdement.util
{

	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.getTimer;

	public class FrameRateMeter
	{

		////////////////////////////////////////////////////////////
		//   ATTRIBUTES 
		////////////////////////////////////////////////////////////

		public var maxDeltas:int = 30;

		private var _deltas:Array;

		private var _displayObject:Stage;

		private var _lastFrameTime:int;

		////////////////////////////////////////////////////////////
		//   CONSTRUCTOR 
		////////////////////////////////////////////////////////////

		public function FrameRateMeter(displayObject:DisplayObject)
		{
			_displayObject = displayObject;

			try
			{
				maxDeltas = displayObject.stage.frameRate;
			}
			catch (e:Error)
			{
				// either because stage was null or we don't have security access
				maxDeltas = 30;
			}

			_displayObject.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		////////////////////////////////////////////////////////////
		//   EVENT HANDLERS 
		////////////////////////////////////////////////////////////

		protected function onEnterFrame(event:Event):void
		{
			// first frame setup 
			if (!_deltas)
			{
				_lastFrameTime = getTimer();
				_deltas = new Array();
				return;
			}

			// figure out our current frame delta
			var currentFrameTime:int = getTimer();
			var delta:int = currentFrameTime - _lastFrameTime;

			// add it to the beginning of the list
			_deltas.unshift(delta);

			// trim the oldest value(s) from the end of the list
			while (_deltas.length > maxDeltas)
			{
				_deltas.pop();
			}

			_lastFrameTime = currentFrameTime;
		}

		////////////////////////////////////////////////////////////
		//   GETTERS / SETTERS 
		////////////////////////////////////////////////////////////

		public function get frameRate():int
		{
			if (!_deltas || _deltas.length == 0)
			{
				return -1;
			}

			var total:int = 0;

			for each (var delta:int in _deltas)
			{
				total += delta;
			}

			var average:int = total / _deltas.length;

			return 1000 / average;
		}
	}
}
