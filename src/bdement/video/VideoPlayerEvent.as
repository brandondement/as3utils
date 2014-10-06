package bdement.video
{

	import flash.events.Event;

	public final class VideoPlayerEvent extends Event
	{

		////////////////////////////////////////////////////////////
		//   CONSTANTS 
		////////////////////////////////////////////////////////////

		public static const COMPLETE:String = "complete";

		public static const ERROR:String = "error";

		public static const MUTE:String = "mute";

		public static const PAUSE:String = "pause";

		public static const RESUME:String = "resume";

		public static const START:String = "start";

		public static const STOP:String = "stop";

		public static const UNMUTE:String = "unmute";

		public static const VOLUME_CHANGE:String = "volumeChange";

		////////////////////////////////////////////////////////////
		//   ATTRIBUTES 
		////////////////////////////////////////////////////////////

		private var _data:*;

		////////////////////////////////////////////////////////////
		//   CONSTRUCTOR 
		////////////////////////////////////////////////////////////

		public function VideoPlayerEvent(type:String, data:* = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);

		}

		////////////////////////////////////////////////////////////
		//   PUBLIC API 
		////////////////////////////////////////////////////////////

		public override function clone():Event
		{
			return new VideoPlayerEvent(this.type, this.data, this.bubbles, this.cancelable);
		}

		////////////////////////////////////////////////////////////
		//   GETTERS / SETTERS 
		////////////////////////////////////////////////////////////

		public function get data():*
		{
			return _data;
		}
	}
}
