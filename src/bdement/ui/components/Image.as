package bdement.ui.components
{

	import bdement.loading.ILoadService;
	import bdement.loading.LoadPriority;
	import bdement.loading.events.LoadEvent;
	import bdement.loading.loaditems.BitmapLoadItem;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;

	/**
	 * A simple image component for displaying embedded and external images.
	 * Dispatches a COMPLETE and RESIZE event any time the displayObject changes.
	 *
	 * Image.source is a URL used for loading images on-demand.
	 * Image.assetId is a String key used for retreiving assets from the AssetManager
	 *
	 * MXML usage:
	 *
	 * <Image source="http://server/image.png" />
	 * <Image>http://server/image.png</Image>
	 * <Image source="@Embed(source='image.png')" />
	 * <Image source="@Embed(source='asset.swf', symbol='image')" />
	 *
	 * ACTIONSCRIPT USAGE:
	 *
	 * [Embed(source='asset.swf', symbol='image')]
	 * var EmbeddedAsset:Class;
	 * var image:Image = new Image(EmbeddedAsset);
	 *
	 * var assetId:String = "myAssetId";
	 * var image:Image = new Image(assetId);
	 *
	 */
	[DefaultProperty("source")]
	[Event(name = "complete", type = "flash.events.Event")]
	[Event(name = "resize", type = "flash.events.Event")]
	public class Image extends Component
	{

		////////////////////////////////////////////////////////////
		//   CLASS ATTRIBUTES 
		////////////////////////////////////////////////////////////

		public static var loadService:ILoadService;

		////////////////////////////////////////////////////////////
		//   ATTRIBUTES 
		////////////////////////////////////////////////////////////

		protected var _assetId:String;

		protected var _displayObject:DisplayObject;

		protected var _explicitHeight:Number = 0;

		protected var _explicitWidth:Number = 0;

		protected var _maintainAspectRatio:Boolean = true;

		protected var _maxHeight:Number = Number.MAX_VALUE;

		protected var _maxWidth:Number = Number.MAX_VALUE;

		////////////////////////////////////////////////////////////
		//   CONSTRUCTOR 
		////////////////////////////////////////////////////////////

		public function Image(assetId:String = null)
		{
			super();
			constructor(assetId);
		}

		protected function constructor(assetId:String):void
		{
			this.assetId = assetId;
		}

		////////////////////////////////////////////////////////////
		//   PUBLIC API 
		////////////////////////////////////////////////////////////

		public override function dispose():void
		{
			super.dispose();

			if (_displayObject && contains(_displayObject))
			{
				removeChild(_displayObject);
			}

			_displayObject = null;
		}

		////////////////////////////////////////////////////////////
		//   EVENT HANDLERS 
		////////////////////////////////////////////////////////////

		protected function onAssetLoaded(bitmap:DisplayObject):void
		{
			this.displayObject = bitmap;
		}

		protected function onLoad(event:LoadEvent):void
		{
			var loadItem:BitmapLoadItem = BitmapLoadItem(event.target);
			loadItem.removeEventListener(LoadEvent.COMPLETE, onLoad);
			this.displayObject = loadItem.bitmap;
		}

		////////////////////////////////////////////////////////////
		//   PROTECTED METHODS 
		////////////////////////////////////////////////////////////

		protected function invalidateDimensions():void
		{
			if (stage)
			{
				addEventListener(Event.RENDER, validateDimensions);
				stage.invalidate();
			}
			else
			{
				validateDimensions(null);
			}
		}

		protected function validateDimensions(event:Event):void
		{
			removeEventListener(Event.RENDER, validateDimensions);

			// can't do anything if the displayobject isn't set
			if (!_displayObject)
			{
				return;
			}

			if (_explicitWidth > 0)
			{
				_displayObject.width = _explicitWidth;
			}

			if (_explicitHeight > 0)
			{
				_displayObject.height = _explicitHeight;
			}

			if (_displayObject.width > _maxWidth)
			{
				_displayObject.width = _maxWidth;

				if (_maintainAspectRatio)
				{
					_displayObject.scaleY = _displayObject.scaleX;
				}
			}

			if (_displayObject.height > _maxHeight)
			{
				_displayObject.height = _maxHeight;

				if (_maintainAspectRatio)
				{
					_displayObject.scaleX = _displayObject.scaleY;
				}
			}

			dispatchEvent(new Event(Event.RESIZE));
		}

		////////////////////////////////////////////////////////////
		//   GETTERS / SETTERS 
		////////////////////////////////////////////////////////////

		public function get assetId():String
		{
			return _assetId;
		}

		public function set assetId(value:String):void
		{
			if (value)
			{
				_assetId = value;
				assetManager.getBitmap(assetId, onAssetLoaded);
			}
		}

		protected function get displayObject():DisplayObject
		{
			return _displayObject;
		}

		protected function set displayObject(value:DisplayObject):void
		{
			if (_displayObject)
			{
				removeChild(_displayObject)
				_displayObject = null;
			}

			_displayObject = value;
			addChild(_displayObject);

			if (_displayObject is MovieClip)
			{
				MovieClip(_displayObject).play();
			}
			else if (_displayObject is Bitmap)
			{
				Bitmap(_displayObject).smoothing = true;
			}

			dispatchEvent(new Event(Event.COMPLETE));

			invalidateDimensions();
		}

		public override function get height():Number
		{
			return _displayObject ? _displayObject.height : _explicitHeight;
		}

		public override function set height(value:Number):void
		{
			_explicitHeight = value;
			invalidateDimensions();
		}

		public function get maintainAspectRatio():Boolean
		{
			return _maintainAspectRatio;
		}

		public function set maintainAspectRatio(value:Boolean):void
		{
			_maintainAspectRatio = value;
			invalidateDimensions();
		}

		public function get maxHeight():Number
		{
			return _maxHeight;
		}

		public function set maxHeight(value:Number):void
		{
			_maxHeight = value;
			invalidateDimensions();
		}

		public function get maxWidth():Number
		{
			return _maxWidth;
		}

		public function set maxWidth(value:Number):void
		{
			_maxWidth = value;
			invalidateDimensions();
		}

		public function set source(source:Object):void
		{
			// value should be either a Class or DisplayObject
			if (source is Class)
			{
				displayObject = DisplayObject(new source());
			}
			else if (source is DisplayObject)
			{
				displayObject = DisplayObject(source);
			}
			else if (source is String)
			{
				if (!loadService)
				{
					throw new Error("Image.loadService must be set before Images can be loaded on-demand!");
				}

				var loadItem:BitmapLoadItem = new BitmapLoadItem(String(source), LoadPriority.IMMEDIATE);
				loadItem.addEventListener(LoadEvent.COMPLETE, onLoad);
				loadService.load(loadItem);
			}
			else if (source)
			{
				throw new Error("Image.source must be a Class, DisplayObject, or String!");
			}
		}

		public override function get width():Number
		{
			return _displayObject ? _displayObject.width : _explicitWidth;
		}

		public override function set width(value:Number):void
		{
			_explicitWidth = value;
			invalidateDimensions();
		}
	}
}


