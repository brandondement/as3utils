package bdement.ui.components
{

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;

	[Event(name = "change", type = "flash.events.Event")]
	public class ToggleButton extends Button
	{

		////////////////////////////////////////////////////////////
		//   ATTRIBUTES 
		////////////////////////////////////////////////////////////

		protected var _selected:Boolean = false;

		protected var _selectedSkin:DisplayObject;

		protected var _selectedSkinAsset:Object;

		////////////////////////////////////////////////////////////
		//   CONSTRUCTOR 
		////////////////////////////////////////////////////////////

		public function ToggleButton(selectedSkinAsset:Object = null, defaultSkinAsset:Object = null, overSkinAsset:Object = null, downSkinAsset:Object = null, disabledSkinAsset:Object = null)
		{
			this.selectedSkinAsset = selectedSkinAsset;
			super(defaultSkinAsset, overSkinAsset, downSkinAsset, disabledSkinAsset);
		}

		////////////////////////////////////////////////////////////
		//   EVENT HANDLERS 
		////////////////////////////////////////////////////////////

		protected override function onClick(event:MouseEvent):void
		{
			super.onClick(event);
			selected = !selected;
		}

		////////////////////////////////////////////////////////////
		//   PROTECTED METHODS 
		////////////////////////////////////////////////////////////

		protected function setSelectedAssetSkin(displayObject:DisplayObject):void
		{
			// remove the old skin
			if (_selectedSkin)
			{
				removeChild(_selectedSkin);
			}

			_selectedSkin = displayObject;

			// add the new skin (if it's not being cleared with null)
			if (_selectedSkin)
			{
				addChild(_selectedSkin);
			}

			updateCurrentSkin(_currentSkin);
		}

		protected override function updateCurrentSkin(value:DisplayObject):void
		{
			if (!value)
			{
				return;
			}

			if (_selectedSkin)
			{
				_selectedSkin.visible = _selected;
			}

			super.updateCurrentSkin(value);
		}

		////////////////////////////////////////////////////////////
		//   GETTERS / SETTERS 
		////////////////////////////////////////////////////////////

		public function get selected():Boolean
		{
			return _selected;
		}

		public function set selected(value:Boolean):void
		{
			if (value == _selected)
			{
				return;
			}

			_selected = value;

			var nextSkin:DisplayObject = _selected ? selectedSkin : upSkin;
			updateCurrentSkin(nextSkin);

			dispatchEvent(new Event(Event.CHANGE));
		}

		public function get selectedSkin():DisplayObject
		{
			return _selectedSkin;
		}

		public function get selectedSkinAsset():Object
		{
			return _selectedSkinAsset;
		}

		public function set selectedSkinAsset(value:Object):void
		{
			_selectedSkinAsset = value;

			if (value is Class)
			{
				setSelectedAssetSkin(DisplayObject(new value()));
			}
			else if (value is DisplayObject)
			{
				setSelectedAssetSkin(DisplayObject(value));
			}
			else if (value is String)
			{
				assetManager.getBitmap(String(value), setSelectedAssetSkin);
			}
			else if (value)
			{
				throw new Error("Button.selectedSkinAsset must be a Class or DisplayObject");
			}
		}
	}
}
