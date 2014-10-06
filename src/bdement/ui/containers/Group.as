package bdement.ui.containers
{

	import bdement.util.IDisposable;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;

	[DefaultProperty("children")]
	public class Group extends Sprite implements IDisposable
	{

		////////////////////////////////////////////////////////////
		//   ATTRIBUTES 
		////////////////////////////////////////////////////////////

		protected var _explicitHeight:Number = NaN;

		protected var _explicitWidth:Number = NaN;

		protected var _height:Number = NaN;

		protected var _width:Number = NaN;

		private var _drawArea:uint;

		private var _isActive:Boolean = true;

		////////////////////////////////////////////////////////////
		//   CONSTRUCTOR 
		////////////////////////////////////////////////////////////

		public function Group()
		{
			this.mouseEnabled = false;
		}

		////////////////////////////////////////////////////////////
		//   PUBLIC API 
		////////////////////////////////////////////////////////////

		public override function addChild(child:DisplayObject):DisplayObject
		{
			return addChildAt(child, numChildren);
		}

		public override function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			if (_isActive)
			{
				child.addEventListener(Event.RESIZE, onChildResized);
			}

			child = super.addChildAt(child, index);

			invalidate();

			return child;
		}

		public function dispose():void
		{
			while (numChildren > 0)
			{
				var child:DisplayObject = getChildAt(0)

				if (_isActive)
				{
					child.removeEventListener(Event.RESIZE, onChildResized);
				}

				if (child is IDisposable)
				{
					IDisposable(child).dispose();
				}

				super.removeChildAt(0);
			}

		}

		public override function removeChild(child:DisplayObject):DisplayObject
		{
			if (_isActive)
			{
				child.removeEventListener(Event.RESIZE, onChildResized);
			}

			if (child.parent === this)
			{
				super.removeChild(child);
			}

			invalidate();
			return child;
		}

		public override function removeChildAt(index:int):DisplayObject
		{
			var child:DisplayObject = super.removeChildAt(index);

			if (_isActive)
			{
				child.removeEventListener(Event.RESIZE, onChildResized);
			}

			invalidate();
			return child;
		}

		////////////////////////////////////////////////////////////
		//   EVENT HANDLERS 
		////////////////////////////////////////////////////////////

		protected function onChildResized(event:Event):void
		{
			invalidate();
		}

		protected function onRender(event:Event):void
		{
			removeEventListener(Event.RENDER, onRender);

			validate();
		}

		////////////////////////////////////////////////////////////
		//   PROTECTED METHODS 
		////////////////////////////////////////////////////////////

		protected function invalidate():void
		{
			if (stage)
			{
				stage.invalidate();
				addEventListener(Event.RENDER, onRender);
				return;
			}
		}

		protected function layoutChildren():void
		{
			// Group does no layout management, but subclasses do
			dispatchEvent(new Event(Event.RESIZE));
		}

		////////////////////////////////////////////////////////////
		//   PRIVATE METHODS 
		////////////////////////////////////////////////////////////

		private function validate():void
		{
			layoutChildren();
		}

		////////////////////////////////////////////////////////////
		//   GETTERS / SETTERS 
		////////////////////////////////////////////////////////////

		public function get children():Vector.<DisplayObject>
		{
			var childrenVector:Vector.<DisplayObject> = new Vector.<DisplayObject>();

			for (var i:int = 0; i < numChildren; i++)
			{
				childrenVector.push(this.getChildAt(i));
			}

			return childrenVector;
		}

		public function set children(value:Vector.<DisplayObject>):void
		{
			while (numChildren > 0)
			{
				this.removeChildAt(0);
			}

			for each (var child:DisplayObject in value)
			{
				this.addChild(child);
			}
		}

		public function set drawArea(value:uint):void
		{
			_drawArea = value;
			this.graphics.beginFill(value, 1);
			this.graphics.drawRect(0, 0, explicitWidth, explicitHeight);
			this.graphics.endFill();
		}

		public function get explicitHeight():Number
		{
			return _explicitHeight;
		}

		public function get explicitWidth():Number
		{
			return _explicitWidth;
		}

		public override function get height():Number
		{
			if (!isNaN(_explicitHeight))
			{
				return _explicitHeight;
			}
			return this.getBounds(this.parent).height;
		}

		public override function set height(value:Number):void
		{
			_explicitHeight = value;
			invalidate();
		}

		public function get isActive():Boolean
		{
			return _isActive;
		}

		public function set isActive(value:Boolean):void
		{
			_isActive = value;
		}

		public override function get width():Number
		{
			if (!isNaN(_explicitWidth))
			{
				return _explicitWidth;
			}

			return this.getBounds(this.parent).width;
		}

		public override function set width(value:Number):void
		{
			_explicitWidth = value;
			invalidate();
		}
	}
}

