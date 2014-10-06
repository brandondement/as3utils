package bdement.config
{

	import bdement.loading.LoadPriority;
	import bdement.loading.events.LoadErrorEvent;
	import bdement.loading.events.LoadEvent;
	import bdement.loading.loaditems.LoadItem;
	import bdement.loading.loaditems.XMLLoadItem;
	import bdement.config.events.ConfigErrorEvent;
	import bdement.config.events.ConfigEvent;

	/**
	 * Example Structure:
	 *
	 * <root>
	 * 		<key>value</key>
	 *
	 * 		<String>MyString<String>
	 * 		<NumberArray>1,2,3,4,5</NumberArray>
	 * 		<Boolean>true</Boolean>
	 * 		<Number>123.456</Number>
	 * </root>
	 *
	 */
	[Event(name = 'loadError', type = 'bdement.config.events.ConfigErrorEvent')]
	[Event(name = 'parseError', type = 'bdement.config.events.ConfigErrorEvent')]
	[Event(name = 'loaded', type = 'bdement.config.events.ConfigEvent')]
	public final class XMLConfig extends Config
	{

		////////////////////////////////////////////////////////////
		//   CONSTANTS 
		////////////////////////////////////////////////////////////

		/**
		 * Array content in config files should be delimited by this character
		 */
		public static const ARRAY_DELIMITER:String = ",";

		////////////////////////////////////////////////////////////
		//   ATTRIBUTES 
		////////////////////////////////////////////////////////////

		private var _xml:XML;

		////////////////////////////////////////////////////////////
		//   CONSTRUCTOR 
		////////////////////////////////////////////////////////////

		public function XMLConfig()
		{
		}

		////////////////////////////////////////////////////////////
		//   PUBLIC API 
		////////////////////////////////////////////////////////////

		public override function getBoolean(key:String):Boolean
		{
			var value:String = getString(key);

			if (/yes|y|1|true/i.test(value))
			{
				return true;
			}
			else if (/no|n|0|false/i.test(value))
			{
				return false;
			}
			else
			{
				return Boolean(value);
			}
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
			var value:String = String(_xml.child(key));

			if (!value)
			{
				var errorMessage:String = "Config could not find a value for key: " + key;
				throw new Error(errorMessage);
			}

			return value;
		}

		public override function getStrings(key:String):Vector.<String>
		{
			var value:String = getString(key);
			var array:Array = value.split(ARRAY_DELIMITER);
			return Vector.<String>(array);
		}

		public override function hasKey(key:String):Boolean
		{
			var count:int = _xml.child(key).length();
			var hasKey:Boolean = count != 0;
			return hasKey;
		}

		public override function load(url:String):void
		{
			if (!loadService)
			{
				throw new Error("Config.loadService must be set before a config can be loaded");
			}

			_url = url;

			var loadItem:XMLLoadItem = new XMLLoadItem(url, LoadPriority.IMMEDIATE);
			addListeners(loadItem);
			loadService.load(loadItem);
		}

		////////////////////////////////////////////////////////////
		//   EVENT HANDLERS 
		////////////////////////////////////////////////////////////

		protected override function onLoadComplete(event:LoadEvent):void
		{
			var loadItem:XMLLoadItem = XMLLoadItem(event.target);
			removeListeners(loadItem);

			try
			{
				_xml = loadItem.xml;
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
			var loadItem:XMLLoadItem = XMLLoadItem(event.target);
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

		public function get xml():XML
		{
			return _xml;
		}
	}
}
