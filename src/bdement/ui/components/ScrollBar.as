package bdement.ui.components
{

	import bdement.assets.*;
	import bdement.util.*;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;

	public class ScrollBar extends Component implements IDisposable
	{

		////////////////////////////////////////////////////////////
		//   CLASS ATTRIBUTES 
		////////////////////////////////////////////////////////////

		public static var assetManager:IAssetManager;

		////////////////////////////////////////////////////////////
		//   ATTRIBUTES 
		////////////////////////////////////////////////////////////

		private var _buttonHoldScrollAmount:Number;

		private var _buttonHoldScrollDelay:Number;

		private var _buttonPressScrollAmount:Number;

		private var _downButton:Sprite;

		private var _downButtonTimer:Timer;

		private var _rail:Sprite;

		private var _slider:Sprite;

		private var _sliderBounds:Rectangle;

		private var _sliderMaxY:Number;

		private var _sliderMinY:Number;

		private var _upButton:Sprite;

		private var _upButtonTimer:Timer;

		////////////////////////////////////////////////////////////
		//   CONSTRUCTOR 
		////////////////////////////////////////////////////////////

		public function ScrollBar(buttonPressScrollAmount:Number = 10, buttonHoldScrollAmount:Number = 5, buttonHoldScrollDelay:Number = 500)
		{
			super();
			init(buttonPressScrollAmount, buttonHoldScrollAmount, buttonHoldScrollDelay);
		}

		////////////////////////////////////////////////////////////
		//   PUBLIC API 
		////////////////////////////////////////////////////////////

		public override function dispose():void
		{
			_downButtonTimer.stop();
			_downButtonTimer.removeEventListener(TimerEvent.TIMER, onDownButtonTimer);
			_downButtonTimer = null;

			_upButtonTimer.stop();
			_upButtonTimer.removeEventListener(TimerEvent.TIMER, onUpButtonTimer);
			_upButtonTimer = null;

			removeEventListener(Event.ENTER_FRAME, onScrollUp);
			removeEventListener(Event.ENTER_FRAME, onScrollDown);
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);

			_slider.removeEventListener(MouseEvent.MOUSE_DOWN, onSliderMouseDown);
			_slider.removeEventListener(MouseEvent.MOUSE_UP, onSliderMouseUp);

			_upButton.removeEventListener(MouseEvent.MOUSE_DOWN, onUpButtonMouseDown);
			_upButton.removeEventListener(MouseEvent.MOUSE_UP, onUpButtonMouseUp);

			_downButton.removeEventListener(MouseEvent.MOUSE_DOWN, onDownButtonMouseDown);
			_downButton.removeEventListener(MouseEvent.MOUSE_UP, onDownButtonMouseUp);

			stage.removeEventListener(Event.RENDER, onRender);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);

			_rail = null;
			_slider = null;
			_upButton = null;
			_downButton = null;

			super.dispose();
		}

		public final function scroll(amount:Number):void
		{
			_slider.y = MathUtil.clamp(_slider.y + amount, _sliderMinY, _sliderMaxY);
		}

		public final function scrollTo(value:Number):void
		{
			_slider.y = MathUtil.clamp(value, 0, 1) * (_rail.height - _slider.height) + _rail.y;
		}

		////////////////////////////////////////////////////////////
		//   EVENT HANDLERS 
		////////////////////////////////////////////////////////////

		protected override function onAddedToStage(event:Event):void
		{
			stage.addEventListener(Event.RENDER, onRender, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp, false, 0, true);

			validateLayout();
		}

		private function onDownButtonMouseDown(event:MouseEvent):void
		{
			scroll(buttonPressScrollAmount);

			_downButtonTimer.start();
		}

		private function onDownButtonMouseUp(event:MouseEvent):void
		{
			_downButtonTimer.reset();

			removeEventListener(Event.ENTER_FRAME, onScrollDown);
		}

		private function onDownButtonTimer(event:TimerEvent):void
		{
			addEventListener(Event.ENTER_FRAME, onScrollDown, false, 0, true);
		}

		private function onRemovedFromStage(event:Event):void
		{
			stage.removeEventListener(Event.RENDER, onRender);
		}

		private function onRender(event:Event):void
		{
			validateLayout();
		}

		private function onScrollDown(event:Event):void
		{
			scroll(buttonHoldScrollAmount);
		}

		private function onScrollUp(event:Event):void
		{
			scroll(-buttonHoldScrollAmount);
		}

		private function onSliderMouseDown(event:MouseEvent):void
		{
			_slider.startDrag(false, _sliderBounds);
		}

		private function onSliderMouseUp(event:MouseEvent):void
		{
			_slider.stopDrag();
		}

		private function onStageMouseUp(event:MouseEvent):void
		{
			onSliderMouseUp(event);
			onUpButtonMouseUp(event);
			onDownButtonMouseUp(event);
		}

		private function onUpButtonMouseDown(event:MouseEvent):void
		{
			scroll(-buttonPressScrollAmount);

			_upButtonTimer.start();
		}

		private function onUpButtonMouseUp(event:MouseEvent):void
		{
			_upButtonTimer.reset();

			removeEventListener(Event.ENTER_FRAME, onScrollUp);
		}

		private function onUpButtonTimer(event:TimerEvent):void
		{
			addEventListener(Event.ENTER_FRAME, onScrollUp, false, 0, true);
		}

		////////////////////////////////////////////////////////////
		//   PROTECTED METHODS 
		////////////////////////////////////////////////////////////

		protected function applySkin():void
		{
			var upArrow:Shape = new Shape();
			upArrow.graphics.beginFill(0x333333, 1);
			upArrow.graphics.drawRect(0, 0, 20, 20);
			upArrow.graphics.beginFill(0x999999, 1);
			upArrow.graphics.moveTo(10, 6);
			upArrow.graphics.lineTo(4, 14);
			upArrow.graphics.lineTo(16, 14);
			upArrow.graphics.lineTo(10, 6);
			upArrow.graphics.endFill();

			var downArrow:Shape = new Shape();
			downArrow.graphics.beginFill(0x333333, 1);
			downArrow.graphics.drawRect(0, 0, 20, 20);
			downArrow.graphics.beginFill(0x999999, 1);
			downArrow.graphics.moveTo(10, 14);
			downArrow.graphics.lineTo(4, 6);
			downArrow.graphics.lineTo(16, 6);
			downArrow.graphics.lineTo(10, 14);
			downArrow.graphics.endFill();

			var rail:Shape = new Shape();
			rail.graphics.beginFill(0x555555, 1);
			rail.graphics.drawRect(0, 0, 20, 400);
			rail.graphics.endFill();

			var slider:Shape = new Shape();
			slider.graphics.beginFill(0x888888, 1);
			slider.graphics.drawRect(0, 0, 20, 120);
			slider.graphics.endFill();

			this.upButton = upArrow;
			this.downButton = downArrow;
			this.rail = rail;
			this.slider = slider;
		}

		////////////////////////////////////////////////////////////
		//   PRIVATE METHODS 
		////////////////////////////////////////////////////////////

		private function init(buttonPressScrollAmount:Number, buttonHoldScrollAmount:Number, buttonHoldScrollDelay:Number):void
		{
			this.buttonPressScrollAmount = buttonPressScrollAmount;
			this.buttonHoldScrollAmount = buttonHoldScrollAmount;
			this.buttonHoldScrollDelay = buttonHoldScrollDelay;

			_rail = Sprite(addChild(new Sprite()));
			_slider = Sprite(addChild(new Sprite()));
			_upButton = Sprite(addChild(new Sprite()));
			_downButton = Sprite(addChild(new Sprite()));

			_rail.buttonMode = false;
			_rail.useHandCursor = false;

			_upButtonTimer = new Timer(buttonHoldScrollDelay);
			_upButtonTimer.addEventListener(TimerEvent.TIMER, onUpButtonTimer, false, 0, true);

			_downButtonTimer = new Timer(buttonHoldScrollDelay);
			_downButtonTimer.addEventListener(TimerEvent.TIMER, onDownButtonTimer, false, 0, true);

			_upButton.addEventListener(MouseEvent.MOUSE_DOWN, onUpButtonMouseDown, false, 0, true);
			_upButton.addEventListener(MouseEvent.MOUSE_UP, onUpButtonMouseUp, false, 0, true);

			_downButton.addEventListener(MouseEvent.MOUSE_DOWN, onDownButtonMouseDown, false, 0, true);
			_downButton.addEventListener(MouseEvent.MOUSE_UP, onDownButtonMouseUp, false, 0, true);

			_slider.addEventListener(MouseEvent.MOUSE_DOWN, onSliderMouseDown, false, 0, true);
			_slider.addEventListener(MouseEvent.MOUSE_UP, onSliderMouseUp, false, 0, true);

			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage, false, 0, true);

			applySkin();
		}

		private function invalidateLayout():void
		{
			if (stage)
			{
				stage.invalidate();
			}
		}

		private function setElementSkin(element:Sprite, skin:DisplayObject):void
		{
			while (element.numChildren)
			{
				element.removeChildAt(0);
			}

			element.addChild(skin);

			invalidateLayout();
		}

		private function validateLayout():void
		{
			var oldValue:Number = value;

			_rail.y = _upButton.y + _upButton.height;
			_downButton.y = _rail.y + _rail.height;

			_sliderBounds ||= new Rectangle();
			_sliderBounds.x = _rail.x;
			_sliderBounds.y = _rail.y;
			_sliderBounds.width = 0;
			_sliderBounds.height = _rail.height - _slider.height;

			_sliderMinY = _sliderBounds.y;
			_sliderMaxY = _sliderBounds.y + _sliderBounds.height;

			scrollTo(oldValue);
		}

		////////////////////////////////////////////////////////////
		//   GETTERS / SETTERS 
		////////////////////////////////////////////////////////////

		public final function get buttonHoldScrollAmount():Number
		{
			return _buttonHoldScrollAmount;
		}

		public final function set buttonHoldScrollAmount(value:Number):void
		{
			_buttonHoldScrollAmount = value;
		}

		public final function get buttonHoldScrollDelay():Number
		{
			return _buttonHoldScrollDelay;
		}

		public final function set buttonHoldScrollDelay(value:Number):void
		{
			_buttonHoldScrollDelay = value;
		}

		public final function get buttonPressScrollAmount():Number
		{
			return _buttonPressScrollAmount;
		}

		public final function set buttonPressScrollAmount(value:Number):void
		{
			_buttonPressScrollAmount = value;
		}

		public final function set downButton(value:DisplayObject):void
		{
			setElementSkin(_downButton, value);
		}

		public final function set rail(value:DisplayObject):void
		{
			setElementSkin(_rail, value);
		}

		public final function set slider(value:DisplayObject):void
		{
			setElementSkin(_slider, value);
		}

		public final function set sliderSize(value:Number):void
		{
			_slider.height = MathUtil.clamp(value, 0, 1) * _rail.height;

			invalidateLayout();
		}

		public final function set upButton(value:DisplayObject):void
		{
			setElementSkin(_upButton, value);
		}

		public final function get value():Number
		{
			return (_slider.y - _rail.y) / (_rail.height - _slider.height);
		}
	}
}
