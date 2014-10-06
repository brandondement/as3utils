package bdement.ui.components
{

	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Point;

	public class Line extends Shape
	{

		////////////////////////////////////////////////////////////
		//   CONSTANTS 
		////////////////////////////////////////////////////////////

		private static const DEGREES_TO_RADIANS:Number = Math.PI / 180;

		public static const DOWN:Number = 270;

		public static const LEFT:Number = 180;

		public static const RIGHT:Number = 0;

		public static const UP:Number = 90;

		////////////////////////////////////////////////////////////
		//   ATTRIBUTES 
		////////////////////////////////////////////////////////////

		private var _angle:Number       = 0;

		private var _color:uint         = 0x000000;

		private var _endPoint:Point     = new Point(0, 0);

		private var _length:Number      = 0;

		private var _thickness:Number   = 0;

		////////////////////////////////////////////////////////////
		//   CONSTRUCTOR 
		////////////////////////////////////////////////////////////

		public function Line(length:Number = 0, color:uint = 0x000000, thickness:Number = 0, angle:Number = 0)
		{
			super();

			_length = length;
			_color = color;
			_thickness = thickness;
			_angle = angle;

			invalidate();
		}

		////////////////////////////////////////////////////////////
		//   PRIVATE METHODS 
		////////////////////////////////////////////////////////////

		private function draw():void
		{
			_endPoint.x = _length * Math.cos(_angle * DEGREES_TO_RADIANS);
			// using -y to invert Flash's up-side-down Y-axis
			_endPoint.y = -(_length * Math.sin(_angle * DEGREES_TO_RADIANS));

			graphics.clear();
			graphics.lineStyle(_thickness, _color);
			graphics.lineTo(_endPoint.x, _endPoint.y);
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
			dispatchEvent(new Event(Event.RESIZE));
		}

		////////////////////////////////////////////////////////////
		//   GETTERS / SETTERS 
		////////////////////////////////////////////////////////////

		//TODO: set endPoint()
//		public function set endPoint(value:Point):void
//		{
//			_endPoint = value;
//		}

		public function get angle():Number
		{
			return _angle;
		}

		public function set angle(value:Number):void
		{
			_angle = value;
			invalidate();
		}

		public function get color():uint
		{
			return _color;
		}

		public function set color(value:uint):void
		{
			_color = value;
			invalidate();
		}

		public function get endPoint():Point
		{
			return _endPoint;
		}

		public override function get height():Number
		{
			return Math.abs(_endPoint.y);
		}

		public function get length():Number
		{
			return _length;
		}

		public function set length(value:Number):void
		{
			_length = value;
			invalidate();
		}

		public function get thickness():Number
		{
			return _thickness;
		}

		public function set thickness(value:Number):void
		{
			_thickness = value;
			invalidate();
		}

		public override function get width():Number
		{
			return Math.abs(_endPoint.x);
		}
	}
}


