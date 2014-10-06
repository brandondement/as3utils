package bdement.ui.containers
{

	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;

	/**
	 *
	 * A Panel is a simple container with a colored background and border.
	 * You can specify multiple colors to create a gradient.
	 *
	 * var panel:Panel = new Panel();
	 * panel.backgroundColors = [0x0000FF];
	 * panel.backgroundAlpha = 1.0
	 * panel.height = 50;
	 * panel.width = 50;
	 * panel.draggable = true;
	 * panel.borderColor = 0xFF0000;
	 * panel.borderAlpha = 1.0;
	 * panel.borderThickness = 2.0;
	 * panel.cornerRadius = 20;
	 * addChild(panel);
	 *
	 */
	public class Panel extends Group
	{

		////////////////////////////////////////////////////////////
		//   CONSTANTS 
		////////////////////////////////////////////////////////////

		private static const DEGREES_TO_RADIANS:Number = Math.PI / 180;

		public static const HORIZONTAL_GRADIENT:int = 0;

		public static const VERTICAL_GRADIENT:int = 90;

		////////////////////////////////////////////////////////////
		//   ATTRIBUTES 
		////////////////////////////////////////////////////////////

		private var _backgroundAlpha:Number = 1.0;

		[ArrayElementType("uint")]
		private var _backgroundColors:Array = [0xFFFFFF];

		private var _borderAlpha:Number = 1.0;

		private var _borderColor:uint = 0x000000;

		private var _borderThickness:Number = 0;

		private var _cornerRadius:Number = 0;

		private var _draggable:Boolean = false;

		private var _gradientDirection:int = 90;

		////////////////////////////////////////////////////////////
		//   CONSTRUCTOR 
		////////////////////////////////////////////////////////////

		public function Panel(height:Number = 200, width:Number = 300, backgroundColors:Array = null, borderColor:uint = 0x000000, cornerRadius:Number = 0)
		{
			super();

			this.height = height;
			this.mouseEnabled = true;
			this.width = width;
			this.cornerRadius = cornerRadius

			if (backgroundColors)
			{
				_backgroundColors = backgroundColors;
			}

			_borderColor = borderColor;
		}

		////////////////////////////////////////////////////////////
		//   PUBLIC API 
		////////////////////////////////////////////////////////////

		public override function dispose():void
		{
			super.dispose();

			_backgroundColors.length = 0;

			removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}

		////////////////////////////////////////////////////////////
		//   EVENT HANDLERS 
		////////////////////////////////////////////////////////////

		private function onMouseDown(event:MouseEvent):void
		{
			// only start dragging if the user has clicked the panel
			// (and not one of the children) 
			if (event.target == this)
			{
				startDrag();
			}

			//NOTE: It may make it easier to expose a "dragChildren"
			// property which would allow the panel to drag even though 
			// a child got the mouse event 
		}

		private function onMouseUp(event:MouseEvent):void
		{
			stopDrag();
		}

		////////////////////////////////////////////////////////////
		//   PROTECTED METHODS 
		////////////////////////////////////////////////////////////

		protected override function layoutChildren():void
		{
			// create helper objects used used to configure the gradient
			var g:Graphics = graphics;
			g.clear();

			var numColors:int = _backgroundColors.length
			var colors:Array = new Array();
			var alphas:Array = new Array();
			var ratios:Array = new Array();
			var matrix:Matrix = new Matrix();

			// turn the gradient vertically
			matrix.createGradientBox(width, height, _gradientDirection * DEGREES_TO_RADIANS);

			for (var index:int = 0; index < numColors; index++)
			{
				switch (index)
				{
					// first color is always 0
					case 0:
						ratios[index] = 0;
						break;

					// last color is always 255
					case numColors - 1:
						ratios[index] = 255;
						break;

					// colors in between are evenly distributed between 0 and 255
					default:
						if ((numColors % 2) == 0)
						{
							ratios[index] = (index / numColors) * 255;
						}
						else
						{
							ratios[index] = (index / (numColors - 1)) * 255;
						}
						break;
				}

				// all solid alpha
				alphas[index] = _backgroundAlpha;

				// color array
				colors[index] = _backgroundColors[index];
			}

			// draw the background
			g.lineStyle(_borderThickness, _borderColor, _borderAlpha, true);
			g.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matrix);
			g.drawRoundRect(0, 0, width, height, _cornerRadius, _cornerRadius);
			g.endFill();

			super.layoutChildren();
		}

		////////////////////////////////////////////////////////////
		//   GETTERS / SETTERS 
		////////////////////////////////////////////////////////////

		public function get backgroundAlpha():Number
		{
			return _backgroundAlpha;
		}

		public function set backgroundAlpha(value:Number):void
		{
			_backgroundAlpha = value;
			invalidate();
		}

		public function get backgroundColors():Array
		{
			return _backgroundColors;
		}

		public function set backgroundColors(value:Array):void
		{
			_backgroundColors = value;
			invalidate();
		}

		public function get borderAlpha():Number
		{
			return _borderAlpha;
		}

		public function set borderAlpha(value:Number):void
		{
			_borderAlpha = value;
			invalidate();
		}

		public function get borderColor():uint
		{
			return _borderColor;
		}

		public function set borderColor(value:uint):void
		{
			_borderColor = value;
			invalidate();
		}

		public function get borderThickness():Number
		{
			return _borderThickness;
		}

		public function set borderThickness(value:Number):void
		{
			_borderThickness = value;
			invalidate();
		}

		public function get cornerRadius():Number
		{
			return _cornerRadius;
		}

		public function set cornerRadius(value:Number):void
		{
			_cornerRadius = value;
			invalidate();
		}

		public function get draggable():Boolean
		{
			return _draggable;
		}

		public function set draggable(value:Boolean):void
		{
			_draggable = value;

			if (_draggable)
			{
				addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			}
			else
			{
				removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			}
		}

		public function get gradientDirection():int
		{
			return _gradientDirection;
		}

		public function set gradientDirection(value:int):void
		{
			_gradientDirection = value;
			invalidate();
		}

		public override function set height(value:Number):void
		{
			super.height = value;
			invalidate();
		}

		public override function set width(value:Number):void
		{
			super.width = value;
			invalidate();
		}
	}
}
