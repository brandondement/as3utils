package bdement.ui.modals
{

	import bdement.ui.components.Button;
	import bdement.ui.containers.Group;
	import bdement.ui.containers.Panel;
	import bdement.util.IDisposable;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	[DefaultProperty("children")]
	public class Modal extends Group implements IDisposable
	{

		////////////////////////////////////////////////////////////
		//   CLASS ATTRIBUTES 
		////////////////////////////////////////////////////////////

		public static var DEFAULT_BACKGROUND_COLOR:uint = 0xFFFFFF;

		public static var DEFAULT_BORDER_COLOR:uint = 0x000000;

		public static var DEFAULT_CLOSE_BUTTON_COLOR:uint = 0xFF000000;

		public static var DEFAULT_CLOSE_BUTTON_HEIGHT:int = 20;

		public static var DEFAULT_CLOSE_BUTTON_WIDTH:int = 20;

		public static var MODAL_BACKGROUND_ALPHA:Number = 1 //0.4;

		public static var MODAL_BACKGROUND_COLOR:uint = 0x000000;

		////////////////////////////////////////////////////////////
		//   ATTRIBUTES 
		////////////////////////////////////////////////////////////

		protected var _background:DisplayObject;

		protected var _closeButton:Button;

		protected var _modal:Boolean;

		private var _customButton:Boolean = false;

		private var _modalManager:IModalManager;

		////////////////////////////////////////////////////////////
		//   CONSTRUCTOR 
		////////////////////////////////////////////////////////////

		public function Modal(height:Number = 300, width:Number = 500, modal:Boolean = true)
		{
			constructor();
			this.isActive = false;
			this.height = height;
			this.width = width;
			_modal = modal;
		}

		private function constructor():void
		{
			this.background = new Panel(height, width, [DEFAULT_BACKGROUND_COLOR], DEFAULT_BORDER_COLOR)

			var defaultCloseButton:Button = new Button();
			defaultCloseButton.width = DEFAULT_CLOSE_BUTTON_WIDTH;
			defaultCloseButton.height = DEFAULT_CLOSE_BUTTON_HEIGHT;
			defaultCloseButton.upSkinAsset = new Panel(DEFAULT_CLOSE_BUTTON_WIDTH, DEFAULT_CLOSE_BUTTON_HEIGHT, [DEFAULT_CLOSE_BUTTON_COLOR]);

			_closeButton = defaultCloseButton;
			_closeButton.addEventListener(MouseEvent.CLICK, onClickCloseButton);
			_closeButton.addEventListener(Event.RESIZE, onCloseButtonResize);

			addChild(_closeButton);
			positionCloseButton();
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		////////////////////////////////////////////////////////////
		//   PUBLIC API 
		////////////////////////////////////////////////////////////

		public override function dispose():void
		{
			_modalManager = null;

			if (_closeButton)
			{
				_closeButton.removeEventListener(MouseEvent.CLICK, onClickCloseButton);
				_closeButton.dispose();
				_closeButton = null;
			}

			if (_background)
			{
				removeChild(background);
				_background = null;
			}

			if (stage)
			{
				stage.removeEventListener(FullScreenEvent.FULL_SCREEN, onFullScreen);
			}

			super.dispose();
		}

		public function setModalManager(modalManager:IModalManager):void
		{
			_modalManager = modalManager;
		}

		////////////////////////////////////////////////////////////
		//   EVENT HANDLERS 
		////////////////////////////////////////////////////////////

		private function onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			centerOnStage();
			drawModalBackground();
			stage.addEventListener(FullScreenEvent.FULL_SCREEN, onFullScreen);
		}

		protected function onClickCloseButton(event:MouseEvent):void
		{
			if (_modalManager)
			{
				_modalManager.removeModal(this);
			}
		}

		protected function onCloseButtonResize(event:Event):void
		{
			positionCloseButton();
		}

		private function onFullScreen(event:FullScreenEvent):void
		{
			centerOnStage();
			drawModalBackground();
		}

		////////////////////////////////////////////////////////////
		//   PROTECTED METHODS 
		////////////////////////////////////////////////////////////

		protected function applyDimensions():void
		{
			if (_background)
			{
				_background.width = width;
				_background.height = height;
			}

			positionCloseButton();
		}

		protected function positionCloseButton():void
		{
			//TODO: position the close button only if it hasn't been done manually
			if (_closeButton && !_customButton)
			{
				_closeButton.x = width - (_closeButton.width / 2);
				_closeButton.y = _closeButton.height / -2;
			}
		}

		////////////////////////////////////////////////////////////
		//   PRIVATE METHODS 
		////////////////////////////////////////////////////////////

		private function centerOnStage():void
		{
			x = (stage.stageWidth - width) / 2;
			y = (stage.stageHeight - height) / 2;
		}

		private function drawModalBackground():void
		{
			if (!_modal)
			{
				return;
			}

			var origin:Point = globalToLocal(new Point(0, 0));

			graphics.clear();
			graphics.beginFill(MODAL_BACKGROUND_COLOR, MODAL_BACKGROUND_ALPHA);
			graphics.drawRect(origin.x, origin.y, stage.stageWidth, stage.stageHeight);
			graphics.endFill();
		}

		////////////////////////////////////////////////////////////
		//   GETTERS / SETTERS 
		////////////////////////////////////////////////////////////

		public function get background():DisplayObject
		{
			return _background;
		}

		public function set background(value:DisplayObject):void
		{
			if (_background)
			{
				removeChild(_background);
			}

			_background = value;
			addChildAt(_background, 0);
			applyDimensions();
		}

		public override function set children(value:Vector.<DisplayObject>):void
		{
			super.children = value;

			//TODO:	The order of events when declaring a modal in MXML causes 
			//		the background and close button to be removed when you add content
			//		so we're manually re-adding them for now, but a better workaround
			//		is needed
			addChildAt(_background, 0);
			addChild(_closeButton);
		}

		public function get closeButton():Button
		{
			return _closeButton;
		}

		public function set closeButton(value:Button):void
		{
			if (_closeButton)
			{
				_closeButton.removeEventListener(MouseEvent.CLICK, onClickCloseButton);
				_closeButton.removeEventListener(Event.RESIZE, onCloseButtonResize);
				removeChild(_closeButton);
			}


			_customButton = true;
			_closeButton = value;
			_closeButton.addEventListener(MouseEvent.CLICK, onClickCloseButton);
			addChild(_closeButton);
		}

		public override function set height(value:Number):void
		{
			super.height = value;
			applyDimensions();
		}

		public function get isModal():Boolean
		{
			return _modal;
		}

		public override function set width(value:Number):void
		{
			super.width = value;
			applyDimensions();
		}
	}
}
