package bdement.config
{

	import bdement.loading.LoadPriority;
	import bdement.loading.events.LoadErrorEvent;
	import bdement.loading.events.LoadEvent;
	import bdement.loading.loaditems.LoadItem;
	import bdement.loading.loaditems.TextLoadItem;
	import bdement.config.events.ConfigErrorEvent;
	import bdement.config.events.ConfigEvent;
	import flash.utils.Dictionary;

	/**
	 * Example Structure:
	 *
	 * name=value
	 * key=123456
	 * array=1,2,3,4
	 * # commented lines are ignored
	 *
	 */
	[Event(name = 'loadError', type = 'bdement.config.events.ConfigErrorEvent')]
	[Event(name = 'parseError', type = 'bdement.config.events.ConfigErrorEvent')]
	[Event(name = 'loaded', type = 'bdement.config.events.ConfigEvent')]
	public final class PropertiesConfig extends Config
	{

		////////////////////////////////////////////////////////////
		//   CONSTANTS 
		////////////////////////////////////////////////////////////

		/**
		 * Arrays should be delimited with this character
		 */
		public static const ARRAY_DELIMITER:String = ",";

		/**
		 * Comment lines should start with this chracter
		 */
		public static const COMMENT_CHARACTER:String = "#";

		/**
		 * Keys should be separated from their vals by this character
		 */
		public static const KEY_VAL_DELIMITER:String = "=";

		////////////////////////////////////////////////////////////
		//   CLASS ATTRIBUTES 
		////////////////////////////////////////////////////////////

		public static var NEWLINE_CHARACTER:RegExp = /[\r\n]/;

		////////////////////////////////////////////////////////////
		//   ATTRIBUTES 
		////////////////////////////////////////////////////////////

		private var _properties:Dictionary = new Dictionary(false);

		////////////////////////////////////////////////////////////
		//   PUBLIC API 
		////////////////////////////////////////////////////////////

		public override function getBoolean(key:String):Boolean
		{
			return Boolean(getString(key));
		}

		public override function getNumber(key:String):Number
		{
			return Number(getString(key));
		}

		public override function getNumbers(key:String):Vector.<Number>
		{
			var value:String = getString(key);
			var array:Array = value.split(ARRAY_DELIMITER);
			var vector:Vector.<Number> = new <Number>[];

			for each (var string:String in array)
			{
				vector.push(Number(string));
			}

			return vector;
		}

		public override function getString(key:String):String
		{
			var value:String = String(_properties[key]);

			if (!value || value == "undefined" || value == "null")
			{
				trace("Config could not find a value for key: " + key);
			}

			return value;
		}

		public override function getStrings(key:String):Vector.<String>
		{
			var value:String = getString(key);
			var array:Array = value.split(ARRAY_DELIMITER);
			return Vector.<String>(array);
		}

		public override function load(url:String):void
		{
			if (!loadService)
			{
				throw new Error("Config.loadService must be set before a config can be loaded");
			}

			_url = url;

			var loadItem:TextLoadItem = new TextLoadItem(url, LoadPriority.IMMEDIATE);
			addListeners(loadItem);
			loadService.load(loadItem);
		}

		////////////////////////////////////////////////////////////
		//   EVENT HANDLERS 
		////////////////////////////////////////////////////////////

		protected override function onLoadComplete(event:LoadEvent):void
		{
			var loadItem:TextLoadItem = TextLoadItem(event.target);

			removeListeners(loadItem);

			try
			{
				var text:String = loadItem.text;

				var lines:Array = text.split(NEWLINE_CHARACTER);

				for each (var line:String in lines)
				{
					// Remove white space at the beginning of the line.
					line = line.replace(/^[ \t]+/, "");

					var keyVal:Array = line.split(KEY_VAL_DELIMITER);

					if (keyVal.length != 2)
					{
						// warn unless it's a comment or blank line
						if (line.charAt(0) != COMMENT_CHARACTER && line.length > 1)
						{

						}

						continue;
					}

					// strip out whitespace
					var key:String = String(keyVal[0]).replace(" ", "");
					var val:String = String(keyVal[1]).replace(" ", "");

					// save
					_properties[key] = val;
				}
			}
			catch (e:TypeError)
			{
				dispatchEvent(new ConfigErrorEvent(ConfigErrorEvent.PARSE_ERROR, e.message));
				return;
			}

			dispatchEvent(new ConfigEvent(ConfigEvent.LOADED));
		}

		protected override function onLoadError(event:LoadErrorEvent):void
		{
			var loadItem:TextLoadItem = TextLoadItem(event.target);
			removeListeners(loadItem);

			dispatchEvent(new ConfigErrorEvent(ConfigErrorEvent.LOAD_ERROR, event.text));
		}

		////////////////////////////////////////////////////////////
		//   PROTECTED METHODS 
		////////////////////////////////////////////////////////////

		protected function addListeners(loadItem:LoadItem):void
		{
			loadItem.addEventListener(LoadEvent.COMPLETE, onLoadComplete);
			loadItem.addEventListener(LoadErrorEvent.ERROR, onLoadError);
		}

		protected function removeListeners(loadItem:LoadItem):void
		{
			loadItem.removeEventListener(LoadEvent.COMPLETE, onLoadComplete);
			loadItem.removeEventListener(LoadErrorEvent.ERROR, onLoadError);
		}

		////////////////////////////////////////////////////////////
		//   GETTERS / SETTERS 
		////////////////////////////////////////////////////////////

		public function get properties():Dictionary
		{
			return _properties;
		}
	}
}
