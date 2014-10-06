package bdement.ui.components
{

	import bdement.ui.containers.Panel;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class Slider extends Component
	{

		////////////////////////////////////////////////////////////
		//   CONSTANTS 
		////////////////////////////////////////////////////////////

		public static const DEFAULT_LENGTH:Number = 200;

		public static const DEFAULT_THUMB_SIZE:Number = 10;

		public static const HORIZONTAL:String = "horizontal";

		public static const VERTICAL:String = "vertical";

		////////////////////////////////////////////////////////////
		//   ATTRIBUTES 
		////////////////////////////////////////////////////////////

		public var stepSize:Number = 1;

		protected var _thumbSkinAsset:Object;

		protected var _trackSkinAsset:Object;

		private var _explicitLength:Number;

		private var _lastValue:Number = 0;

		private var _maxValue:Number = 100;

		private var _minValue:Number = 0;

		private var _orientation:String = HORIZONTAL;

		private var _thumbSkin:Sprite;

		private var _trackSkin:DisplayObject;

		private var _trackSkinOriginalDimenions:Point;

		private var _value:Number = 0;

		////////////////////////////////////////////////////////////
		//   CONSTRUCTOR 
		////////////////////////////////////////////////////////////

		public function Slider(minValue:Number = 0, maxValue:Number = 100, value:Number = 0, orientation:String = "horizontal", stepSize:Number = 1, length:Number = Number.NaN)
		{
			super();

			_minValue = minValue;
			_maxValue = maxValue;
			_value = value;
			stepSize = stepSize;

			_orientation = orientation;
			_explicitLength = length;

			var direction:Number = (_orientation == HORIZONTAL) ? Line.RIGHT : Line.DOWN;
			var trackLength:Number = isNaN(length) ? DEFAULT_LENGTH : length;
			trackSkinAsset = new Line(trackLength, 0x000000, 2, direction);
			thumbSkinAsset = new Panel(DEFAULT_THUMB_SIZE, DEFAULT_THUMB_SIZE, null, 0x000000, DEFAULT_THUMB_SIZE);

			validate();
		}

		////////////////////////////////////////////////////////////
		//   EVENT HANDLERS 
		////////////////////////////////////////////////////////////

		protected function onEnterFrame(event:Event):void
		{
			var slideLocation:Number = (_orientation == HORIZONTAL) ? _thumbSkin.x : _thumbSkin.y;
			var slidePercentage:Number = slideLocation / this.length;
			var nextValue:Number = minValue + (slidePercentage * range);
			var stepSizeDelta:Number = nextValue % stepSize;

			// ensure that the next value takes into account our step size 
			if (stepSizeDelta != 0)
			{
				if (stepSizeDelta < (stepSize / 2))
				{
					// round down to the nearest step
					nextValue -= stepSizeDelta;
				}
				else
				{
					// round up to the nearest step
					nextValue += stepSize - stepSizeDelta;
				}
			}

			// only set the new value if it's changed (prevents multiple 
			// CHANGE events from being dispatched while you're holding 
			// the thumb in a single location)
			if (nextValue != _lastValue)
			{
				this.value = nextValue;
				_lastValue = nextValue;
			}
		}

		protected function onMouseDownThumb(event:Event):void
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUpThumb);
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);

			var x:Number = (_orientation == HORIZONTAL) ? this.length : 0;
			var y:Number = (_orientation == VERTICAL) ? this.length : 0;
			var rect:Rectangle = new Rectangle(0, 0, x, y);

			_lastValue = value;

			_thumbSkin.startDrag(false, rect);
		}

		protected function onMouseUpThumb(event:Event):void
		{
			stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpThumb);
			_thumbSkin.stopDrag();
			positionThumb();
		}

		protected function onRender(event:Event):void
		{
			stage.removeEventListener(Event.RENDER, onRender);
			validate();
		}

		protected function onThumbResize(event:Event):void
		{
			invalidate();
		}

		protected function onTrackResize():void
		{
			invalidate();
		}

		protected function onTrackSkinResize(event:Event):void
		{
			invalidate();
		}

		////////////////////////////////////////////////////////////
		//   PROTECTED METHODS 
		////////////////////////////////////////////////////////////

		protected function setThumbSkinAsset(displayObject:DisplayObject):void
		{
			// remove the old skin
			if (_thumbSkin)
			{
				removeThumbListeners();
				removeChild(_thumbSkin);
			}

			if (_thumbSkin is Image)
			{
				_thumbSkin.removeEventListener(Event.RESIZE, onThumbResize);
			}

			// wrap the thumb with a container so it can be centered on the track
			var container:Sprite = new Sprite();
			displayObject.x = -displayObject.width / 2;
			displayObject.y = -displayObject.height / 2;
			container.addChild(displayObject);

			_thumbSkin = Sprite(container);
			addThumbListeners();

			// add the new skin (if it's not being cleared with null)
			if (_thumbSkin)
			{
				addChild(_thumbSkin);
			}

			if (_thumbSkin is Image)
			{
				_thumbSkin.addEventListener(Event.RESIZE, onThumbResize);
			}

			invalidate();
		}

		protected function setTrackSkinAsset(displayObject:DisplayObject):void
		{
			// remove the old skin
			if (_trackSkin)
			{
				removeChild(_trackSkin);
			}

			_trackSkin = displayObject;
			_trackSkinOriginalDimenions = new Point(_trackSkin.width, _trackSkin.height);

			// add the new skin (if it's not being cleared with null)
			if (_trackSkin)
			{
				addChild(_trackSkin);
			}

			if (_trackSkin is Image)
			{
				_trackSkin.removeEventListener(Event.RESIZE, onTrackSkinResize);
			}

			invalidate();
		}

		////////////////////////////////////////////////////////////
		//   PRIVATE METHODS 
		////////////////////////////////////////////////////////////

		private function addThumbListeners():void
		{
			_thumbSkin.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownThumb);
		}

		private function invalidate():void
		{
			if (stage)
			{
				stage.addEventListener(Event.RENDER, onRender);
				return;
			}

			validate();
		}

		private function positionThumb():void
		{
			if (!_thumbSkin)
			{
				return;
			}

			var pct:Number = value / range;
			var position:Number = (pct * this.length);

			if (_orientation == HORIZONTAL)
			{
				_thumbSkin.x = position;
				_thumbSkin.y = 0;
			}
			else
			{
				_thumbSkin.y = position;
				_thumbSkin.x = 0;
			}
		}

		private function removeThumbListeners():void
		{
			_thumbSkin.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDownThumb);
			_thumbSkin.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpThumb);
		}

		private function validate():void
		{
			positionThumb();

			if (_trackSkin)
			{
				// keep the track centered on the thumb
				if (_orientation == HORIZONTAL)
				{
					_trackSkin.y = -_trackSkin.height / 2;
				}
				else
				{
					_trackSkin.x = -_trackSkin.width / 2;
				}

				if (_trackSkin is Line)
				{
					var line:Line = Line(_trackSkin);
					line.angle = (_orientation == HORIZONTAL) ? Line.RIGHT : Line.DOWN;
					line.length = this.length;
					return;
				}

				_trackSkin.width = (_orientation == HORIZONTAL && !isNaN(_explicitLength)) ? _explicitLength : _trackSkinOriginalDimenions.x;
				_trackSkin.height = (_orientation == VERTICAL && !isNaN(_explicitLength)) ? _explicitLength : _trackSkinOriginalDimenions.y;
			}

			dispatchEvent(new Event(Event.RESIZE));
		}

		////////////////////////////////////////////////////////////
		//   GETTERS / SETTERS 
		////////////////////////////////////////////////////////////

		public override function get height():Number
		{
			if (_orientation == VERTICAL)
			{
				if (!isNaN(_explicitLength))
				{
					return _explicitLength;
				}

				if (_trackSkin)
				{
					return _trackSkin.height;
				}
			}

			var thumbHeight:Number = 0;
			var trackHeight:Number = 0;

			if (_thumbSkin)
			{
				thumbHeight = _thumbSkin.height;
			}

			if (_trackSkin)
			{
				trackHeight = _trackSkin.height;
			}

			return Math.max(thumbHeight, trackHeight);
		}

		public function get length():int
		{
			if (!isNaN(_explicitLength))
			{
				return _explicitLength;
			}

			if (_trackSkin)
			{
				return orientation == HORIZONTAL ? _trackSkin.width : _trackSkin.height;
			}

			return 0;
		}

		public function set length(value:int):void
		{
			_explicitLength = value;
			invalidate();
		}

		public function get maxValue():Number
		{
			return _maxValue;
		}

		public function set maxValue(value:Number):void
		{
			_maxValue = value;

			if (_value > _maxValue)
			{
				this.value = _maxValue;
			}
		}

		public function get minValue():Number
		{
			return _minValue;
		}

		public function set minValue(value:Number):void
		{
			_minValue = value;
		}

		public function get orientation():String
		{
			return _orientation;
		}

		public function set orientation(value:String):void
		{
			_orientation = value;
			invalidate();
		}

		public function get range():Number
		{
			return maxValue - minValue;
		}

		public function get thumb():Sprite
		{
			return _thumbSkin;
		}

		public function set thumbSkinAsset(value:Object):void
		{
			_thumbSkinAsset = value;

			// value should be either a Class or DisplayObject or String
			if (value is Class)
			{
				setThumbSkinAsset(DisplayObject(new value()));
			}
			else if (value is DisplayObject)
			{
				setThumbSkinAsset(DisplayObject(value));
			}
			else if (value is String)
			{
				assetManager.getBitmap(String(_thumbSkinAsset), setThumbSkinAsset);
			}
			else if (value)
			{
				throw new Error("Slider.thumbSkinAsset must be a Class, DisplayObject, or asset ID String!");
			}
		}

		public function get trackSkin():DisplayObject
		{
			return _trackSkin;
		}

		public function set trackSkinAsset(value:Object):void
		{
			_trackSkinAsset = value;

			// value should be either a Class or DisplayObject or String
			if (value is Class)
			{
				setTrackSkinAsset(DisplayObject(new value()));
			}
			else if (value is DisplayObject)
			{
				setTrackSkinAsset(DisplayObject(value));
			}
			else if (value is String)
			{
				assetManager.getBitmap(String(_trackSkinAsset), setTrackSkinAsset);
			}
			else if (value)
			{
				throw new Error("Button.upSkinAsset must be a Class or DisplayObject");
			}
		}

		public function get value():Number
		{
			return _value;
		}

		public function set value(value:Number):void
		{
			_value = value;
			positionThumb();
			dispatchEvent(new Event(Event.CHANGE));
		}

		public override function get width():Number
		{
			if (_orientation == HORIZONTAL)
			{
				if (!isNaN(_explicitLength))
				{
					return _explicitLength;
				}

				if (_trackSkin)
				{
					return _trackSkin.width;
				}
			}

			var thumbWidth:Number = 0;
			var trackWidth:Number = 0;

			if (_thumbSkin)
			{
				thumbWidth = _thumbSkin.width;
			}

			if (_trackSkin)
			{
				trackWidth = _trackSkin.width;
			}

			return Math.max(thumbWidth, trackWidth);
		}
	}
}
