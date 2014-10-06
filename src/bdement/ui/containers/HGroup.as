package bdement.ui.containers
{

	import bdement.ui.Align;
	import bdement.util.IDisposable;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;

	public class HGroup extends Group
	{

		////////////////////////////////////////////////////////////
		//   ATTRIBUTES 
		////////////////////////////////////////////////////////////

		private var _align:String;

		private var _gap:Number;

		////////////////////////////////////////////////////////////
		//   CONSTRUCTOR 
		////////////////////////////////////////////////////////////

		public function HGroup(gap:Number = 10)
		{
			this.gap = gap;
		}

		////////////////////////////////////////////////////////////
		//   PROTECTED METHODS 
		////////////////////////////////////////////////////////////

		protected override function layoutChildren():void
		{
			var x:Number = 0;

			var child:DisplayObject;

			for (var i:int = 0; i < numChildren; i++)
			{
				child = this.getChildAt(i);
				child.x = x;
				x += child.width + gap;

				switch (align)
				{
					case Align.TOP:
						child.y = 0;
						break;
					case Align.BOTTOM:
						child.y = height - child.height;
						break;
					case Align.CENTER:
						child.y = (height - child.height) / 2;
						break;
				}
			}

			super.layoutChildren();
		}

		////////////////////////////////////////////////////////////
		//   GETTERS / SETTERS 
		////////////////////////////////////////////////////////////

		public function get align():String
		{
			return _align;
		}

		public function set align(value:String):void
		{
			switch (value)
			{
				case Align.TOP:
				case Align.BOTTOM:
				case Align.CENTER:
					_align = value;
					invalidate();
					break;

				default:
					trace("HGroup doesn't support align: " + value);
					break;
			}
		}

		public function get gap():Number
		{
			return _gap;
		}

		public function set gap(value:Number):void
		{
			_gap = value;
			invalidate();
		}
	}
}


