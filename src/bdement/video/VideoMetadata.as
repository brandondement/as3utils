package bdement.video
{

	import bdement.util.TypedObject;

	public class VideoMetadata extends TypedObject
	{

		////////////////////////////////////////////////////////////
		//   ATTRIBUTES 
		////////////////////////////////////////////////////////////

		public var audiocodecid:Number;

		public var audiodatarate:Number;

		public var audiodelay:Number;

		public var audiosamplerate:String;

		public var audiosamplesize:String;

		public var audiosize:Number;

		public var canSeekToEnd:Boolean;

		public var datasize:Number;

		public var duration:Number;

		public var encoder:String;

		public var filesize:String

		public var framerate:Number;

		public var hasAudio:Boolean;

		public var hasKeyframes:Boolean;

		public var hasMetadata:Boolean;

		public var hasVideo:Boolean;

		public var height:Number;

		public var lasttimestamp:String;

		public var length:Number;

		public var stereo:String;

		public var videocodecid:Number;

		public var videodatarate:Number;

		public var videosize:Number;

		public var width:Number;

		////////////////////////////////////////////////////////////
		//   CONSTRUCTOR 
		////////////////////////////////////////////////////////////

		public function VideoMetadata(untyped:Object)
		{
			super(untyped);
		}
	}
}
