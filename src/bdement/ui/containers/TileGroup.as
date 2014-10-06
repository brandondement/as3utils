package bdement.ui.containers
{

	import flash.debugger.enterDebugger;
	import flash.display.DisplayObject;
	import flash.events.Event;

	public class TileGroup extends Group
	{

		////////////////////////////////////////////////////////////
		//   ATTRIBUTES 
		////////////////////////////////////////////////////////////

		private var _cols:int = 1;

		private var _horizontalGap:Number = 10;

		private var _maxChildHeight:Number = 0;

		private var _maxChildWidth:Number = 0;

		private var _rows:int = 1;

		private var _verticalGap:Number = 10;

		////////////////////////////////////////////////////////////
		//   CONSTRUCTOR 
		////////////////////////////////////////////////////////////

		public function TileGroup(rows:int = 1, cols:int = 1, horizontalGap:Number = 10, verticalGap:Number = 10)
		{
			_rows = rows;
			_cols = cols;

			_horizontalGap = horizontalGap;
			_verticalGap = verticalGap;
		}

		////////////////////////////////////////////////////////////
		//   PUBLIC API 
		////////////////////////////////////////////////////////////

		public override function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			invalidate();
			updateMaxValues(child);
			return super.addChildAt(child, index);
		}

		////////////////////////////////////////////////////////////
		//   EVENT HANDLERS 
		////////////////////////////////////////////////////////////

		protected override function onChildResized(event:Event):void
		{
			var child:DisplayObject = DisplayObject(event.target);
			updateMaxValues(child);
			super.onChildResized(event);
		}

		////////////////////////////////////////////////////////////
		//   PROTECTED METHODS 
		////////////////////////////////////////////////////////////

		protected override function layoutChildren():void
		{
			var xIndex:int = 0;

			var x:Number = 0;
			var y:Number = 0;
			var child:DisplayObject;

			for (var i:int = 0; i < numChildren; i++)
			{
				child = getChildAt(i);
				child.x = x;
				child.y = y;

				xIndex++;
				x += _maxChildWidth + _horizontalGap;

				if (xIndex == _cols)
				{
					xIndex = 0;
					x = 0;
					y += _maxChildHeight + _verticalGap;
				}
			}

			super.layoutChildren();
		}

		////////////////////////////////////////////////////////////
		//   PRIVATE METHODS 
		////////////////////////////////////////////////////////////

		private function updateMaxValues(child:DisplayObject):void
		{
			if (child.width > _maxChildWidth)
			{
				_maxChildWidth = child.width;
			}

			if (child.height > _maxChildHeight)
			{
				_maxChildHeight = child.height;
			}
		}

		////////////////////////////////////////////////////////////
		//   GETTERS / SETTERS 
		////////////////////////////////////////////////////////////

		public override function set children(value:Vector.<DisplayObject>):void
		{
			super.children = value;

			for each (var child:DisplayObject in value)
			{
				updateMaxValues(child);
			}

			invalidate();
		}

		public function get cols():int
		{
			return _cols;
		}

		public function set cols(value:int):void
		{
			_cols = value;
			invalidate();
		}

		public function get horizontalGap():Number
		{
			return _horizontalGap;
		}

		public function set horizontalGap(value:Number):void
		{
			_horizontalGap = value;
			invalidate();
		}

		public function get rows():int
		{
			return _rows;
		}

		public function set rows(value:int):void
		{
			_rows = value;
			invalidate();
		}

		public function get verticalGap():Number
		{
			return _verticalGap;
		}

		public function set verticalGap(value:Number):void
		{
			_verticalGap = value;
			invalidate();
		}
	}
}
