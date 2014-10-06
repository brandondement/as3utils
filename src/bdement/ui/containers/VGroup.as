package bdement.ui.containers
{

	import bdement.ui.Align;
	import bdement.ui.components.Label;
	import flash.display.DisplayObject;

	public class VGroup extends Group
	{

		////////////////////////////////////////////////////////////
		//   ATTRIBUTES 
		////////////////////////////////////////////////////////////

		private var _align:String;

		private var _gap:Number;

		////////////////////////////////////////////////////////////
		//   CONSTRUCTOR 
		////////////////////////////////////////////////////////////

		public function VGroup(gap:Number = 10)
		{
			super();
			this.gap = gap;
		}

		////////////////////////////////////////////////////////////
		//   PUBLIC API 
		////////////////////////////////////////////////////////////

		public override function dispose():void
		{
			super.dispose();
		}

		////////////////////////////////////////////////////////////
		//   PROTECTED METHODS 
		////////////////////////////////////////////////////////////

		protected override function layoutChildren():void
		{
			var y:Number = 0;
			var child:DisplayObject;

			for (var index:int = 0; index < numChildren; index++)
			{
				child = getChildAt(index);
				child.y = y;
				y += child.height + gap;

				switch (align)
				{
					case Align.LEFT:
						child.x = 0;
						break;
					case Align.RIGHT:
						child.x = width - child.width;
						break;
					case Align.CENTER:

						// center-aligned labels are centered around their 0
						if ((child is Label) && Label(child).align == Align.CENTER)
						{
							child.x = width / 2;
							continue;
						}

						child.x = (width - child.width) / 2;
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
			if (value == _align)
			{
				return;
			}

			switch (value)
			{
				case Align.LEFT:
				case Align.RIGHT:
				case Align.CENTER:
					_align = value;
					invalidate();
					break;

				default:
					trace("Unsupported align: " + value);
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

