package bdement.ui.components
{

	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.geom.Matrix;

	public class ProgressBar extends Component
	{

		////////////////////////////////////////////////////////////
		//   CONSTANTS 
		////////////////////////////////////////////////////////////

		private static const DEGREES_TO_RADIANS:Number = Math.PI / 180;

		////////////////////////////////////////////////////////////
		//   ATTRIBUTES 
		////////////////////////////////////////////////////////////

		private var _backgroundAlpha:Number         = 1.0;

		[ArrayElementType("uint")]
		private var _backgroundColors:Array         = [0xFFFFFF];

		private var _borderColor:uint               = 0x000000;

		private var _borderThickness:Number         = 1.0;

		[ArrayElementType("uint")]
		private var _colors:Array                   = [0x000000];

		private var _cornerRadius:Number            = 0.0;

		private var _foregroundAlpha:Number         = 1.0;

		private var _height:Number                  = 20;

		private var _progress:Number                = 0.0;

		private var _width:Number                   = 300;

		////////////////////////////////////////////////////////////
		//   PUBLIC API 
		////////////////////////////////////////////////////////////

		public override function dispose():void
		{
			_backgroundColors.length = 0;
			_colors.length = 0;
		}

		////////////////////////////////////////////////////////////
		//   PRIVATE METHODS 
		////////////////////////////////////////////////////////////

		private function draw():void
		{
			var g:Graphics = graphics;

			g.clear();

			// draw the bar background
			drawGradient(_backgroundColors, _backgroundAlpha, _width);

			// draw the bar foreground
			drawGradient(_colors, _foregroundAlpha, foregroundWidth);

			// draw the border
			if (_borderThickness > 0)
			{
				g.lineStyle(_borderThickness, _borderColor);
				g.drawRoundRect(0, 0, _width, _height, _cornerRadius, _cornerRadius);
			}
		}

		/**
		 * @param colors - May be a single color or multiple colors
		 * @param width - This function draws both the bar and the background,
		 * so width is used to differentiate those two scenarios.
		 */
		private function drawGradient(colors:Array, alpha:Number, width:Number):void
		{
			// create helper objects used used to configure the gradient
			var g:Graphics = graphics;
			var numColors:int = colors.length - 1;
			var ratios:Array = new Array();
			var alphas:Array = new Array();
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(width, _height);

			// turn the gradient vertically
//			matrix.createGradientBox(_width, _height, 90 * DEGREES_TO_RADIANS);

			for (var index:int = 0; index <= numColors; index++)
			{
				// add to the alphas list
				alphas[index] = alpha * 100;

				switch (index)
				{
					// first color is always 0
					case 0:
						ratios[index] = 0;
						break;

					// last color is always 255
					case numColors:
						ratios[index] = 255;
						break;

					// colors in between are evenly distributed between 0 and 255
					default:
						ratios[index] = (index / numColors) * 255;
						break;
				}
			}

			// draw a gradient
			g.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matrix);
			g.drawRoundRect(0, 0, width, _height, _cornerRadius, _cornerRadius);
			g.endFill();
		}

		private function invalidate():void
		{
			if (stage)
			{
				stage.invalidate();
				addEventListener(Event.RENDER, validate);
			}
			else
			{
				draw();
			}
		}

		private function validate(event:Event):void
		{
			removeEventListener(Event.RENDER, validate);

			draw();
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
			return _backgroundColors.concat();
		}

		public function set backgroundColors(value:Array):void
		{
			_backgroundColors = value;
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

		public function get colors():Array
		{
			return _colors.concat();
		}

		public function set colors(value:Array):void
		{
			_colors = value;
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

		public function get foregroundAlpha():Number
		{
			return _foregroundAlpha;
		}

		public function set foregroundAlpha(value:Number):void
		{
			_foregroundAlpha = value;
			invalidate();
		}

		public function get foregroundWidth():Number
		{
			return _width * _progress;
		}

		public override function get height():Number
		{
			return _height;
		}

		public override function set height(value:Number):void
		{
			_height = value;
			invalidate();
		}

		public function get progress():Number
		{
			return _progress;
		}

		public function set progress(value:Number):void
		{
			if (isNaN(value))
			{
				value = 0;
			}

			// ensure that _progress is between 0 and 1
			_progress = Math.min(Math.max(value, 0), 1);
			invalidate();
		}

		public override function get width():Number
		{
			return _width;
		}

		public override function set width(value:Number):void
		{
			_width = value;
			invalidate();
		}
	}
}
