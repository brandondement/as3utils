package bdement.ui.components
{

	import bdement.ui.Align;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 *
	 * // A skin can be a DisplayObject!
	 * var upSkin:DisplayObject = new Sprite();
	 *
	 * // A skin can also be an embedded asset!
	 * [Embed(source='image.png')]
	 * var overSkin:Class;
	 *
	 * var downSkin:Panel = new Panel();
	 *
	 * // a skin that's null won't be seen!
	 * var disabledSkin:Object = null;
	 *
	 * // creating a button is easy!
	 * var button:Button = new Button(upSkin, overSkin, downSkin, disabledSkin);
	 *
	 * // telling your button to do things is easy to with IEffects!
	 * button.rollOverEffects = [new ScaleEffect(1.2, 1.2)];
	 * button.rollOutEffects = [new SoundEffect('sound.mp3')];
	 *
	 */
	[DefaultProperty("defaultSkinAsset")]
	public class Button extends Component
	{

		////////////////////////////////////////////////////////////
		//   ATTRIBUTES 
		////////////////////////////////////////////////////////////

		protected var _active:Boolean = true;

		protected var _currentSkin:DisplayObject;

		protected var _disabledSkin:DisplayObject;

		protected var _disabledSkinAsset:Object;

		protected var _downSkin:DisplayObject;

		protected var _downSkinAsset:Object;

		protected var _enabled:Boolean = true;

		protected var _explicitHeight:Number = Number.NaN;

		protected var _explicitWidth:Number = Number.NaN;

		protected var _label:Label;

		protected var _overSkin:DisplayObject;

		protected var _overSkinAsset:Object;

		protected var _upSkin:DisplayObject;

		protected var _upSkinAsset:Object;

		////////////////////////////////////////////////////////////
		//   CONSTRUCTOR 
		////////////////////////////////////////////////////////////

		public function Button(defaultSkinAsset:Object = null, overSkinAsset:Object = null, downSkinAsset:Object = null, disabledSkinAsset:Object = null)
		{
			super();

			mouseChildren = false;
			mouseEnabled = true;

			this.upSkinAsset = defaultSkinAsset;
			this.overSkinAsset = overSkinAsset;
			this.downSkinAsset = downSkinAsset;

			// don't want the children dispatch MouseEvents that 
			// should be coming from this component
			mouseChildren = false;
			useHandCursor = true;
			buttonMode = true;

			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}

		////////////////////////////////////////////////////////////
		//   PUBLIC API 
		////////////////////////////////////////////////////////////

		public override function dispose():void
		{
			super.dispose();

			removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);

			if (_upSkin)
			{
				removeChild(_upSkin);
				_upSkin = null;
			}

			if (_overSkin)
			{
				removeChild(_overSkin);
				_overSkin = null;
			}

			if (_downSkin)
			{
				removeChild(_downSkin);
				_downSkin = null;
			}

			if (_disabledSkin)
			{
				removeChild(_disabledSkin);
				_disabledSkin = null;
			}
		}

		////////////////////////////////////////////////////////////
		//   EVENT HANDLERS 
		////////////////////////////////////////////////////////////

		protected override function onAddedToStage(event:Event):void
		{
			super.onAddedToStage(event);

			var defaultSkin:DisplayObject = _upSkin;

			// if we're in the disabled state and it's ready, show it
			if (_disabledSkin && !_enabled)
			{
				defaultSkin = _disabledSkin;
			}

			// otherwise, show the default
			updateCurrentSkin(defaultSkin);
		}

		protected override function onClick(event:MouseEvent):void
		{
			if (!_active)
				return;

			super.onClick(event);
		}

		private function onLabelResize(event:Event):void
		{
			updateLayout();
		}

		protected function onMouseDown(event:MouseEvent):void
		{
			updateCurrentSkin(_downSkin);
		}

		protected function onMouseUp(event:MouseEvent):void
		{
			updateCurrentSkin(_upSkin);
		}

		protected function onSkinResize(event:Event):void
		{
			applyDimensions(_currentSkin);
		}

		////////////////////////////////////////////////////////////
		//   PROTECTED METHODS 
		////////////////////////////////////////////////////////////

		protected function applyDimensions(displayObject:DisplayObject):void
		{
			if (!displayObject)
			{
				return;
			}

			if (!isNaN(_explicitWidth) && displayObject.width != _explicitHeight)
			{
				displayObject.width = _explicitWidth;
			}

			if (!isNaN(_explicitHeight) && displayObject.height != _explicitHeight)
			{
				displayObject.height = _explicitHeight;
			}

			updateLayout();

			dispatchEvent(new Event(Event.RESIZE));
		}

		protected function getCurrentSkin():DisplayObject
		{
			return _currentSkin;
		}

		protected function setDisabledAssetSkin(displayObject:DisplayObject):void
		{
			// remove the old skin
			if (_disabledSkin && contains(_disabledSkin))
			{
				removeChild(_disabledSkin);
			}

			_disabledSkin = displayObject;

			// add the new skin (if it's not being cleared with null)
			if (_disabledSkin)
			{
				addChild(_disabledSkin);
			}

			if (!_enabled)
			{
				updateCurrentSkin(_disabledSkin);
			}
		}

		protected function setDownAssetSkin(displayObject:DisplayObject):void
		{
			// remove the old skin
			if (_downSkin && contains(_downSkin))
			{
				removeChild(_downSkin);
			}

			_downSkin = displayObject;

			// add the new skin (if it's not being cleared with null)
			if (_downSkin)
			{
				addChild(_downSkin);
			}

			updateCurrentSkin(_currentSkin);
		}

		protected function setOverAssetSkin(displayObject:DisplayObject):void
		{
			// remove the old skin
			if (_overSkin && contains(_overSkin))
			{
				removeChild(_overSkin);
			}

			_overSkin = displayObject;

			// add the new skin (if it's not being cleared with null)
			if (_overSkin)
			{
				addChild(_overSkin);
			}

			updateCurrentSkin(_currentSkin);
		}

		protected function setUpAssetSkin(displayObject:DisplayObject):void
		{
			// remove the old skin
			if (_upSkin && contains(_upSkin))
			{
				removeChild(_upSkin);
			}

			_upSkin = displayObject;

			// add the new skin (if it's not being cleared with null)
			if (_upSkin)
			{
				addChild(_upSkin);
			}

			updateCurrentSkin(_upSkin);
		}

		protected function updateCurrentSkin(value:DisplayObject):void
		{
			if (!value)
			{
				// abort if we don't have a skin to go to
				return;
			}

			if (_upSkin)
			{
				_upSkin.visible = false;
			}

			if (_overSkin)
			{
				_overSkin.visible = false;
			}

			if (_downSkin)
			{
				_downSkin.visible = false;
			}

			if (_disabledSkin)
			{
				_disabledSkin.visible = false;
			}

			if (_currentSkin is Image)
			{
				_currentSkin.removeEventListener(Event.RESIZE, onSkinResize);
			}

			_currentSkin = value;
			_currentSkin.visible = true;
			_currentSkin.alpha = alpha;

			applyDimensions(_currentSkin);

			if (_currentSkin is Image)
			{
				_currentSkin.addEventListener(Event.RESIZE, onSkinResize);
			}
		}

		protected function updateLayout():void
		{
			if (!_label)
			{
				return;
			}

			//TODO: support different text alignments
			// default to center alignment
			if (_label.align == Align.CENTER)
			{
				_label.x = width * .5;
			}
			else
			{
				_label.x = (width - _label.width) * .5;
			}

			_label.y = (height - _label.height) * .5;

			setChildIndex(_label, numChildren - 1);
		}

		////////////////////////////////////////////////////////////
		//   GETTERS / SETTERS 
		////////////////////////////////////////////////////////////

		public override function set alpha(value:Number):void
		{
			super.alpha = value;
			updateCurrentSkin(_currentSkin);
		}

		/**
		 * Alias for upSkinAsset
		 * @return
		 *
		 */
		public function get defaultSkinAsset():Object
		{
			return _upSkinAsset;
		}

		/**
		 * Alias for upSkinAsset
		 * @param value
		 *
		 */
		public function set defaultSkinAsset(value:Object):void
		{
			this.upSkinAsset = value;
		}

		public function get disabledSkin():DisplayObject
		{
			return _disabledSkin;
		}

		public function get disabledSkinAsset():Object
		{
			return _disabledSkinAsset;
		}

		public function set disabledSkinAsset(value:Object):void
		{
			// remove the old skin
			if (_disabledSkin)
			{
				removeChild(_disabledSkin);
			}

			_disabledSkinAsset = value;

			// value should be either a Class or DisplayObject or String
			if (value is Class)
			{
				setDisabledAssetSkin(DisplayObject(new value()));
			}
			else if (value is DisplayObject)
			{
				setDisabledAssetSkin(DisplayObject(value));
			}
			else if (value is String)
			{
				assetManager.getBitmap(String(_disabledSkinAsset), setDisabledAssetSkin);
			}
			else if (value)
			{
				throw new Error("Button.disabledSkinAsset must be a Class or DisplayObject");
			}
		}

		public function get downSkin():DisplayObject
		{
			return _downSkin;
		}

		public function get downSkinAsset():Object
		{
			return _downSkinAsset;
		}

		public function set downSkinAsset(value:Object):void
		{
			// remove the old skin
			if (_downSkin)
			{
				removeChild(_downSkin);
			}

			_downSkinAsset = value;

			// value should be either a Class or DisplayObject or String
			if (value is Class)
			{
				setDownAssetSkin(DisplayObject(new value()));
			}
			else if (value is DisplayObject)
			{
				setDownAssetSkin(DisplayObject(value));
			}
			else if (value is String)
			{
				assetManager.getBitmap(String(_downSkinAsset), setDownAssetSkin);
			}
			else if (value)
			{
				throw new Error("Button.downSkinAsset must be a Class or DisplayObject");
			}
		}

		public function get enabled():Boolean
		{
			return _enabled;
		}

		public function set enabled(value:Boolean):void
		{
			_enabled = value;

			buttonMode = _enabled;
			mouseEnabled = _enabled;
			mouseChildren = _enabled;

			var nextSkin:DisplayObject = _enabled ? _upSkin : _disabledSkin;
			updateCurrentSkin(nextSkin);
		}

		public override function get height():Number
		{
			if (!isNaN(_explicitHeight))
			{
				return _explicitHeight;
			}

			if (_currentSkin)
			{
				return _currentSkin.height;
			}

			return 0;
		}

		public override function set height(value:Number):void
		{
			_explicitHeight = value;
			applyDimensions(_currentSkin);
		}

		public function get label():Label
		{
			return _label;
		}

		public function set label(value:Label):void
		{
			if (_label)
			{
				removeChild(_label);
				_label.removeEventListener(Event.RESIZE, onLabelResize);
			}

			_label = value;
			_label.addEventListener(Event.RESIZE, onLabelResize);

			if (!_label)
			{
				return;
			}

			addChild(_label);

			updateLayout();
		}

		public function get overSkin():DisplayObject
		{
			return _overSkin;
		}

		public function get overSkinAsset():Object
		{
			return _overSkinAsset;
		}

		public function set overSkinAsset(value:Object):void
		{
			// remove the old skin
			if (_overSkin)
			{
				removeChild(_overSkin);
			}

			_overSkinAsset = value;

			// value should be either a Class or DisplayObject or String
			if (value is Class)
			{
				setOverAssetSkin(DisplayObject(new value()));
			}
			else if (value is DisplayObject)
			{
				setOverAssetSkin(DisplayObject(value));
			}
			else if (value is String)
			{
				assetManager.getBitmap(String(_overSkinAsset), setOverAssetSkin);
			}
			else if (value)
			{
				throw new Error("Button.overSkinAsset must be a Class or DisplayObject");
			}
		}

		public function get upSkin():DisplayObject
		{
			return _upSkin;
		}

		public function get upSkinAsset():Object
		{
			return _upSkinAsset;
		}

		/**
		 *
		 * @param value Either a Class or a DisplayObject
		 *
		 */
		public function set upSkinAsset(value:Object):void
		{
			_upSkinAsset = value;

			// value should be either a Class or DisplayObject or String
			if (value is Class)
			{
				setUpAssetSkin(DisplayObject(new value()));
			}
			else if (value is DisplayObject)
			{
				setUpAssetSkin(DisplayObject(value));
			}
			else if (value is String)
			{
				assetManager.getBitmap(String(_upSkinAsset), setUpAssetSkin);
			}
			else if (value)
			{
				throw new Error("Button.upSkinAsset must be a Class or DisplayObject");
			}
		}

		public override function get width():Number
		{
			if (!isNaN(_explicitWidth))
			{
				return _explicitWidth;
			}

			if (_currentSkin)
			{
				return _currentSkin.width;
			}

			return 0;
		}

		public override function set width(value:Number):void
		{
			_explicitWidth = value;
			applyDimensions(_currentSkin);
		}
	}
}


