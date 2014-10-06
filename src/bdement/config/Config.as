package bdement.config
{

	import bdement.loading.ILoadService;
	import bdement.loading.events.LoadErrorEvent;
	import bdement.loading.events.LoadEvent;
	import flash.events.EventDispatcher;

	[Event(name = 'loadError', type = 'bdement.config.events.ConfigErrorEvent')]
	[Event(name = 'parseError', type = 'bdement.config.events.ConfigErrorEvent')]
	[Event(name = 'loaded', type = 'bdement.config.events.ConfigEvent')]
	public class Config extends EventDispatcher
	{

		////////////////////////////////////////////////////////////
		//   CLASS ATTRIBUTES 
		////////////////////////////////////////////////////////////

		public static var loadService:ILoadService;

		////////////////////////////////////////////////////////////
		//   ATTRIBUTES 
		////////////////////////////////////////////////////////////

		protected var _url:String;

		////////////////////////////////////////////////////////////
		//   CONSTRUCTOR 
		////////////////////////////////////////////////////////////

		public function Config()
		{
			super(this);
		}

		////////////////////////////////////////////////////////////
		//   PUBLIC API 
		////////////////////////////////////////////////////////////

		public function getBoolean(key:String):Boolean
		{
			throw new Error("Config.getBoolean() should be implemented by a subclass");
		}

		public function getNumber(key:String):Number
		{
			throw new Error("Config.getNumber() should be implemented by a subclass");
		}

		public function getNumbers(key:String):Vector.<Number>
		{
			throw new Error("Config.getNumberArray() should be implemented by a subclass");
		}

		public function getString(key:String):String
		{
			throw new Error("Config.getValue() should be implemented by a subclass");
		}

		public function getStrings(key:String):Vector.<String>
		{
			throw new Error("Config.getNumberArray() should be implemented by a subclass");
		}

		public function hasKey(key:String):Boolean
		{
			throw new Error("Config.hasKey() should be implemented by a subclass");
		}

		public function load(url:String):void
		{
			throw new Error("Config.load() should be implemented by a subclass");
		}

		////////////////////////////////////////////////////////////
		//   EVENT HANDLERS 
		////////////////////////////////////////////////////////////

		protected function onLoadComplete(event:LoadEvent):void
		{
			throw new Error("Config.onLoadComplete() should be implemented by a subclass");
		}

		protected function onLoadError(event:LoadErrorEvent):void
		{
			throw new Error("Config.onIOError() should be implemented by a subclass");
		}

		////////////////////////////////////////////////////////////
		//   GETTERS / SETTERS 
		////////////////////////////////////////////////////////////

		public function get url():String
		{
			return _url;
		}
	}
}
