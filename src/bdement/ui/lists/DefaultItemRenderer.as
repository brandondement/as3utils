package bdement.ui.lists
{

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;

	public class DefaultItemRenderer extends Sprite implements IItemRenderer
	{

		////////////////////////////////////////////////////////////
		//   ATTRIBUTES 
		////////////////////////////////////////////////////////////

		protected var _data:*;

		////////////////////////////////////////////////////////////
		//   CONSTRUCTOR 
		////////////////////////////////////////////////////////////

		public function DefaultItemRenderer(data:* = null)
		{
			this.data = data;
		}

		////////////////////////////////////////////////////////////
		//   PUBLIC API 
		////////////////////////////////////////////////////////////

		public function dispose():void
		{
			this.data = null;
		}

		////////////////////////////////////////////////////////////
		//   EVENT HANDLERS 
		////////////////////////////////////////////////////////////

		private function onEnterFrame(event:Event):void
		{
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			validate();
		}

		////////////////////////////////////////////////////////////
		//   PROTECTED METHODS 
		////////////////////////////////////////////////////////////

		protected function invalidate():void
		{
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		protected function validate():void
		{
			while (this.numChildren > 0)
			{
				this.removeChildAt(0);
			}

			var textField:TextField = new TextField();
			textField.text = data ? data.toString() : "null";
			addChild(textField);
		}

		////////////////////////////////////////////////////////////
		//   GETTERS / SETTERS 
		////////////////////////////////////////////////////////////

		public function get data():*
		{
			return _data;
		}

		public function set data(value:*):void
		{
			_data = value;
			invalidate();
		}
	}
}

