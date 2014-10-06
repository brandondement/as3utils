package bdement.ui.components
{

	import bdement.util.*;
	import flash.display.*;
	import flash.events.*;

	public class ScrollPane extends Sprite implements IDisposable
	{

		////////////////////////////////////////////////////////////
		//   ATTRIBUTES 
		////////////////////////////////////////////////////////////

		private var _content:DisplayObject;

		private var _contentContainer:Sprite;

		private var _height:Number;

		private var _mask:Shape;

		private var _offset:Number;

		private var _width:Number;

		////////////////////////////////////////////////////////////
		//   CONSTRUCTOR 
		////////////////////////////////////////////////////////////

		public function ScrollPane(width:Number = 200, height:Number = 200)
		{
			super();
			init(width, height);
		}

		////////////////////////////////////////////////////////////
		//   PUBLIC API 
		////////////////////////////////////////////////////////////

		public function dispose():void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);

			stage.removeEventListener(Event.RENDER, onRender);
		}

		public function scrollTo(value:Number):void
		{
			_contentContainer.y = MathUtil.clamp(value, 0, 1) * _offset;
		}

		////////////////////////////////////////////////////////////
		//   EVENT HANDLERS 
		////////////////////////////////////////////////////////////

		private function onAddedToStage(event:Event):void
		{
			stage.addEventListener(Event.RENDER, onRender, false, 0, true);

			validateLayout();
		}

		private function onRemovedFromStage(event:Event):void
		{
			stage.removeEventListener(Event.RENDER, onRender);
		}

		private function onRender(event:Event):void
		{
			validateLayout();
		}

		////////////////////////////////////////////////////////////
		//   PRIVATE METHODS 
		////////////////////////////////////////////////////////////

		private function init(width:Number, height:Number):void
		{
			this.width = width;
			this.height = height;

			_mask = Shape(addChild(new Shape()));
			_mask.graphics.beginFill(0xCCCCCC, 1);
			_mask.graphics.drawRect(0, 0, width, height);
			_mask.graphics.endFill();

			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage, false, 0, true);
		}

		private function invalidateLayout():void
		{
			if (stage)
			{
				stage.invalidate();
			}
		}

		private function validateLayout():void
		{
			_mask.width = _width;
			_mask.height = _height;

			_offset = _height - (_contentContainer ? _contentContainer.height : 0);
		}

		////////////////////////////////////////////////////////////
		//   GETTERS / SETTERS 
		////////////////////////////////////////////////////////////

		public function get content():DisplayObject
		{
			return _content;
		}

		public function set content(value:DisplayObject):void
		{
			if (!_contentContainer)
			{
				_contentContainer = Sprite(addChild(new Sprite()));
				_contentContainer.mask = _mask;
			}
			else
			{
				while (_contentContainer.numChildren)
				{
					_contentContainer.removeChildAt(0);
				}
			}

			_content = _contentContainer.addChild(value);

			validateLayout();
		}

		public override function get height():Number
		{
			return _height;
		}

		public override function set height(value:Number):void
		{
			_height = value;

			invalidateLayout();
		}

		public override function get width():Number
		{
			return _width;
		}

		public override function set width(value:Number):void
		{
			_width = value;

			invalidateLayout();
		}
	}
}
