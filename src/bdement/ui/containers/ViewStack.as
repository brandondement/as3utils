package bdement.ui.containers
{

	import flash.display.DisplayObject;

	public class ViewStack extends Group
	{

		////////////////////////////////////////////////////////////
		//   ATTRIBUTES 
		////////////////////////////////////////////////////////////

		private var _selectedIndex:int = 0;

		////////////////////////////////////////////////////////////
		//   PROTECTED METHODS 
		////////////////////////////////////////////////////////////

		protected override function layoutChildren():void
		{
			for (var index:int = 0; index < numChildren; index++)
			{
				getChildAt(index).visible = (index == _selectedIndex);
			}

			super.layoutChildren();
		}

		////////////////////////////////////////////////////////////
		//   GETTERS / SETTERS 
		////////////////////////////////////////////////////////////

		public override function get height():Number
		{
			return selectedChild.height;
		}

		public function get selectedChild():DisplayObject
		{
			return getChildAt(_selectedIndex);
		}

		public function set selectedChild(value:DisplayObject):void
		{
			this.selectedIndex = getChildIndex(value);
		}

		public function get selectedIndex():int
		{
			return _selectedIndex;
		}

		public function set selectedIndex(value:int):void
		{
			if (value < 0 || value >= numChildren)
			{
				return;
			}

			_selectedIndex = value;

			invalidate();
		}

		public override function get width():Number
		{
			return selectedChild.width;
		}
	}
}
