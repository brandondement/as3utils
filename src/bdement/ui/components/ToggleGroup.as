package bdement.ui.components
{

	import flash.events.Event;
	import flash.events.EventDispatcher;

	[DefaultProperty("buttons")]
	public class ToggleGroup extends EventDispatcher
	{

		////////////////////////////////////////////////////////////
		//   ATTRIBUTES 
		////////////////////////////////////////////////////////////

		protected var _buttons:Vector.<ToggleButton> = new Vector.<ToggleButton>();

		protected var _selected:ToggleButton;

		////////////////////////////////////////////////////////////
		//   CONSTRUCTOR 
		////////////////////////////////////////////////////////////

		public function ToggleGroup(buttons:Vector.<ToggleButton> = null)
		{
			this.buttons = buttons;
		}

		////////////////////////////////////////////////////////////
		//   PUBLIC API 
		////////////////////////////////////////////////////////////

		public function addButton(button:ToggleButton):ToggleButton
		{
			button.addEventListener(Event.CHANGE, onButtonChange);
			_buttons.push(button);

			return button;
		}

		public function removeButton(button:ToggleButton):ToggleButton
		{
			if (!_buttons)
			{
				return null;
			}

			var index:int = _buttons.indexOf(button);

			if (index >= 0)
			{
				var removed:ToggleButton = _buttons.splice(index, 1)[0];
				removed.removeEventListener(Event.CHANGE, onButtonChange);
				return removed;
			}

			return null;
		}

		////////////////////////////////////////////////////////////
		//   EVENT HANDLERS 
		////////////////////////////////////////////////////////////

		protected function onButtonChange(event:Event):void
		{
			var changedButton:ToggleButton = ToggleButton(event.target);
			selected = changedButton;
			dispatchEvent(event);
		}

		////////////////////////////////////////////////////////////
		//   GETTERS / SETTERS 
		////////////////////////////////////////////////////////////

		public function get buttons():Vector.<ToggleButton>
		{
			return _buttons.concat();
		}

		public function set buttons(value:Vector.<ToggleButton>):void
		{
			for each (var button:ToggleButton in value)
			{
				addButton(button);
			}
		}

		public function get selected():ToggleButton
		{
			return _selected;
		}

		public function set selected(value:ToggleButton):void
		{
			// make sure it's a valid selection
			if (_buttons.indexOf(value) == -1)
			{
				return;
			}

			_selected = value;

			for each (var button:ToggleButton in _buttons)
			{
				button.removeEventListener(Event.CHANGE, onButtonChange);
				button.selected = _selected === button;
				button.addEventListener(Event.CHANGE, onButtonChange);
			}
		}

		public function get selectedIndex():int
		{
			return _buttons.indexOf(selected);
		}

		public function set selectedIndex(index:int):void
		{
			// don't allow invalid values
			if (index >= _buttons.length || index < 0)
			{
				return;
			}

			this.selected = _buttons[index];
		}
	}
}


