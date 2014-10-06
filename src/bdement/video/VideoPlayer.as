package bdement.video
{

	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import bdement.logging.ILogger;
	import bdement.logging.getLogger;
	import bdement.util.IDisposable;

	[Event(name = "complete", type = "video.VideoPLayerEvent")]
	[Event(name = "muted", type = "video.VideoPLayerEvent")]
	[Event(name = "unmuted", type = "video.VideoPLayerEvent")]
	[Event(name = "start", type = "video.VideoPLayerEvent")]
	public class VideoPlayer extends Sprite implements IDisposable, IVideoClient
	{

		////////////////////////////////////////////////////////////
		//   CLASS ATTRIBUTES 
		////////////////////////////////////////////////////////////

		private static var _logger:ILogger = getLogger(VideoPlayer);

		////////////////////////////////////////////////////////////
		//   ATTRIBUTES 
		////////////////////////////////////////////////////////////

		protected var _metadata:VideoMetadata;

		protected var _metadataObject:Object;

		protected var _mute:Boolean = false;

		protected var _netConnection:NetConnection;

		protected var _netStream:NetStream;

		protected var _paused:Boolean = false;

		protected var _stream:String;

		protected var _url:String;

		protected var _video:Video;

		protected var _volume:Number = 1;

		protected var _xmpData:Object;

		private var _explicitHeight:Number = Number.NaN;

		private var _explicitWidth:Number = Number.NaN;

		private var _letterboxVideo:Boolean = true;

		////////////////////////////////////////////////////////////
		//   CONSTRUCTOR 
		////////////////////////////////////////////////////////////

		public function VideoPlayer()
		{
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
		}

		////////////////////////////////////////////////////////////
		//   PUBLIC API 
		////////////////////////////////////////////////////////////

		public function dispose():void
		{
			_logger.debug("dispose()");

			close();

			_metadata = null;
			_video = null
			_xmpData = null;
			_netStream = null;
			_netConnection = null;
		}

		public function onBWDone():void
		{
			_logger.debug("onBWDone()");
		}

		public function onCuePoint(infoObject:Object):void
		{
			_logger.debug("onCuePoint()");
		}

		public function onMetaData(metadata:Object):void
		{
			_logger.debug("onMetaData()");

			_metadataObject = metadata;
			_metadata = new VideoMetadata(metadata);

			for (var field:String in metadata)
			{
				_logger.debug("metadata." + field, metadata[field]);
			}

			_video = new Video(this.videoWidth, this.videoHeight);
			_video.smoothing = true;
			_video.attachNetStream(_netStream);

			validate();
			addChild(_video);
		}

		public function onPlayStatus(status:Object):void
		{
			_logger.debug("onPlayStatus()", status.code);

			switch (status.code)
			{
//				case "NetStream.Play.Complete":
//					dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.COMPLETE));
//					close();
//					break;

				case "NetStream.Play.NoSupportedTrackFound":
					dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.ERROR, status.code));
					break;
			}
		}

		public function onXMPData(xmpData:Object):void
		{
			_logger.debug("onXMPData");
		}

		public function pause():void
		{
			if (_paused)
			{
				return;
			}

			_logger.debug("pause()");

			_paused = true;
			_netStream.pause();

			dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.PAUSE));
		}

		public function play(url:String, stream:String = null):void
		{
			resetNetStream();

			var method:String = stream ? "streaming" : "progressive";
			_logger.debug("Play (" + method + ")", url);

			_url = url;
			_stream = stream;

			if (!_netConnection)
			{
				_netConnection = new NetConnection();
				_netConnection.addEventListener(NetStatusEvent.NET_STATUS, onConnectionNetStatus);
				_netConnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onConnectionSecurityError);
				_netConnection.client = new Object(); // this
			}

			_netConnection.connect(_stream);
		}

		public function resume():void
		{
			if (!_paused)
			{
				return;
			}

			_paused = false;
			_netStream.resume();

			dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.RESUME));
		}

		public function stop():void
		{
			_logger.debug("stop()");

			resetNetStream();
			dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.STOP));
		}

		public function togglePause():void
		{
			_logger.debug("togglePause()");

			_paused = !_paused;
			_netStream.togglePause();

			var type:String = _paused ? VideoPlayerEvent.PAUSE : VideoPlayerEvent.RESUME;
			dispatchEvent(new VideoPlayerEvent(type));
		}

		////////////////////////////////////////////////////////////
		//   EVENT HANDLERS 
		////////////////////////////////////////////////////////////

		protected function onConnectionNetStatus(event:NetStatusEvent):void
		{
			_logger.debug("onConnectionNetStatus()", event.info.code);

			switch (event.info.code)
			{
				case "NetConnection.Connect.Success":
					startPlayback();
					break;

				case "NetConnection.Connect.Closed":
					break;
			}
		}

		protected function onConnectionSecurityError(event:SecurityErrorEvent):void
		{
			_logger.debug("onConnectionSecurityError()");

			_logger.fatal("onIOError");

			dispatchEvent(event);
		}

		private function onNetStatus(event:NetStatusEvent):void
		{
			_logger.debug("onNetStatus()", event.info.code);

			switch (event.info.code)
			{
				case "NetStream.Play.Start":
					dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.START));
					break;
				case "NetStream.Play.Stop":
					if (!_stream)
					{
						dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.COMPLETE));
					}
					break;
				case "NetStream.Pause.Notify":
					break;
				case "NetStream.Step.Notify":
					break;
				case "NetStream.InvalidArg":
					break;
				case "NetStream.Play.StreamNotFound":
					dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.ERROR, event.info.code));
					break;
				case "NetStream.Play.FileStructureInvalid":
					dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.ERROR, event.info.code));
					break;
			}
		}

		protected function onRemoveFromStage(event:Event):void
		{
			_logger.debug("onRemoveFromStage()");

			removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			stop();
			dispose();
		}

		protected function onRender(event:Event):void
		{
			stage.removeEventListener(Event.RENDER, onRender);
			validate();
		}

		////////////////////////////////////////////////////////////
		//   PRIVATE METHODS 
		////////////////////////////////////////////////////////////

		private function applyVolume(dispatchEvent:Boolean = true):void
		{
			if (!_netStream)
			{
				return;
			}

			// apply the volume
			var st:SoundTransform = new SoundTransform();
			st.volume = _mute ? 0 : _volume;
			_netStream.soundTransform = st;

			if (!dispatchEvent)
			{
				return;
			}

			super.dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.VOLUME_CHANGE, st.volume));
		}

		private function asyncErrorHandler(event:AsyncErrorEvent):void
		{
			_logger.debug("asyncErrorHandler()", event.error.errorID);

			dispatchEvent(event);
		}

		private function close():void
		{
			if (_netStream)
			{
				_netStream.close();
			}

			if (_netConnection)
			{
				_netConnection.close();
			}

			if (_video)
			{
				_video.clear();
			}
		}

		private function invalidate():void
		{
			if (stage)
			{
				addEventListener(Event.RENDER, onRender);

				try
				{
					stage.invalidate();
				}
				catch (e:Error)
				{
					// ignore
				}
			}
			else
			{
				validate();
			}
		}

		private function resetNetStream():void
		{
			if (!_netStream)
			{
				return;
			}

			_netStream.pause();
			_netStream.seek(0);
		}

		private function startPlayback():void
		{
			_netStream = new NetStream(_netConnection);
//			_netStream.bufferTime = 5;
//			_netStream.backBufferTime = 5;
//			_netStream.inBufferSeek = true;
			_netStream.client = this;

			applyVolume(false);

			_netStream.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			_netStream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);

			if (_stream)
			{
				// stream 
				// http://livedocs.adobe.com/flashmediaserver/3.0/hpdocs/help.html?content=00000185.html
				// play(name:Object, start:Number, len:Number, reset:Object)
				_netStream.play(_url, 0, -1, true);
			}
			else
			{
				// progressive download
				_netStream.play(_url);
			}
		}

		private function validate():void
		{
			// can't do anything if the displayobject isn't set
			if (!_video)
			{
				return;
			}

			if (_letterboxVideo)
			{
				var xScale:Number = this.width / this.videoWidth;
				var yScale:Number = this.height / this.videoHeight;
				var scale:Number = (xScale < yScale) ? xScale : yScale;

				// only resize if we actually need to					
				if (scale != _video.scaleX || scale != _video.scaleY)
				{
					_video.scaleX = _video.scaleY = scale;
					_video.x = (this.width - _video.width) / 2;
					_video.y = (this.height - _video.height) / 2;

					dispatchEvent(new Event(Event.RESIZE));
				}
			}
			else
			{
				// only resize if we actually need to
				if (_video.width != this.width || _video.height != this.height)
				{
					_video.width = this.width;
					_video.height = this.height;

					dispatchEvent(new Event(Event.RESIZE));
				}
			}

			// draw black background
			var g:Graphics = this.graphics;
			g.clear();
			g.beginFill(0x000000, 1.0);
			g.drawRect(0, 0, this.width, this.height);
			g.endFill();
		}

		////////////////////////////////////////////////////////////
		//   GETTERS / SETTERS 
		////////////////////////////////////////////////////////////

		public function get client():IVideoClient
		{
			if (_netConnection && _netConnection.client)
			{
				return IVideoClient(_netConnection.client);
			}

			return null;
		}

		public function get duration():Number
		{
			if (!_metadata)
			{
				return Number.NaN;
			}

			// metadata.duration often has a slight amount of   
			// additional time so we floor() to remove it 
			return Math.floor(_metadata.duration);
		}

		public function get fullScreen():Boolean
		{
			if (!stage)
			{
				return false;
			}

			try
			{
				var isFullScreen:Boolean = (stage.displayState != StageDisplayState.NORMAL);
			}
			catch (e:SecurityError)
			{
				return false;
			}

			return isFullScreen;
		}

		public function set fullScreen(value:Boolean):void
		{
			if (value == this.fullScreen || !stage)
			{
				return;
			}

			var newState:String = value ? StageDisplayState.FULL_SCREEN : StageDisplayState.NORMAL;

			try
			{
				stage.displayState = newState;
			}
			catch (e:SecurityError)
			{
				_logger.error("Can't set stage.displayState", e.message);
			}
		}

		public override function get height():Number
		{
			if (!isNaN(_explicitHeight))
			{
				return _explicitHeight;
			}

			if (_video)
			{
				return _video.height;
			}

			return 0;
		}

		public override function set height(height:Number):void
		{
			_explicitHeight = height;

			if (_video && _video.height != _explicitHeight)
			{
				invalidate();
			}
		}

		public function get letterboxVideo():Boolean
		{
			return _letterboxVideo;
		}

		public function set letterboxVideo(value:Boolean):void
		{
			if (value != _letterboxVideo)
			{
				_letterboxVideo = value;
				invalidate();
			}
		}

		public function get metadata():VideoMetadata
		{
			return _metadata;
		}

		public function get metadataObject():Object
		{
			return _metadataObject;
		}

		public function get mute():Boolean
		{
			return _mute;
		}

		public function set mute(value:Boolean):void
		{
			if (_mute == value)
			{
				return;
			}

			_mute = value;

			var eventType:String = _mute ? VideoPlayerEvent.MUTE : VideoPlayerEvent.UNMUTE;
			dispatchEvent(new VideoPlayerEvent(eventType));

			applyVolume();
		}

		public function get netConnection():NetConnection
		{
			return _netConnection;
		}

		public function get netStream():NetStream
		{
			return _netStream;
		}

//		public function get netStreamInfo():NetStreamInfo
//		{
//			if (_netStream)
//			{
//				return _netStream.info;
//			}
//
//			return null;
//		}

		public function get paused():Boolean
		{
			return _paused;
		}

		public function set paused(value:Boolean):void
		{
			_paused = value;
			_paused ? pause() : resume();
		}

		public function get progress():Number
		{
			if (time == 0 || isNaN(duration))
			{
				return 0;
			}

			return time / duration;
		}

		public function get time():Number
		{
			if (_netStream)
			{
				return _netStream.time;
			}

			return 0;
		}

		public function get videoHeight():Number
		{
			if (_video && !isNaN(_video.videoHeight) && _video.videoHeight != 0)
			{
				return _video.videoHeight;
			}

			if (_metadata && !isNaN(_metadata.height) && _metadata.height != 0)
			{
				return _metadata.height;
			}

			return _explicitHeight;
		}

		public function get videoWidth():Number
		{
			if (_video && !isNaN(_video.videoWidth) && _video.videoWidth != 0)
			{
				return _video.videoWidth;
			}

			if (_metadata && !isNaN(_metadata.width) && _metadata.width != 0)
			{
				return _metadata.width;
			}

			return _explicitWidth;
		}

		public function get volume():Number
		{
			return _volume;
		}

		public function set volume(value:Number):void
		{
			if (value == 0)
			{
				this.mute = true;
				return;
			}

			_volume = value;
			this.mute = false;

			applyVolume();
		}

		public override function get width():Number
		{
			if (!isNaN(_explicitWidth))
			{
				return _explicitWidth;
			}

			if (_video)
			{
				return _video.width;
			}

			return 0;
		}

		public override function set width(width:Number):void
		{
			_explicitWidth = width;

			if (_video && _video.width != _explicitWidth)
			{
				invalidate();
			}
		}
	}
}


