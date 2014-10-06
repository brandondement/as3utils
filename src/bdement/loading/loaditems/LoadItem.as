package bdement.loading.loaditems
{

	import bdement.collections.priorityqueue.IPrioritizable;
	import bdement.loading.events.LoadErrorEvent;
	import bdement.loading.events.LoadEvent;
	import bdement.util.IDisposable;
	import bdement.util.URL;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.net.URLLoader;

	[Event(name = "cancel", type = "bdement.loading.events.LoadEvent")]
	[Event(name = "complete", type = "bdement.loading.events.LoadEvent")]
	[Event(name = "error", type = "bdement.loading.events.LoadErrorEvent")]
	public class LoadItem extends EventDispatcher implements ILoadItem, IDisposable, IPrioritizable
	{

		////////////////////////////////////////////////////////////
		//   ATTRIBUTES 
		////////////////////////////////////////////////////////////

		protected var _asset:Object;

		protected var _priority:int;

		protected var _url:URL;

		////////////////////////////////////////////////////////////
		//   CONSTRUCTOR 
		////////////////////////////////////////////////////////////

		public function LoadItem(url:String, priority:int = 0)
		{
			_url = new URL(url);
			_priority = priority;
		}

		////////////////////////////////////////////////////////////
		//   PUBLIC API 
		////////////////////////////////////////////////////////////

		public function cancel():void
		{
			throw new Error("LoadItem.cancel() should be implemented by a subclass");
		}

		public function dispose():void
		{
			_url = null;
			_asset = null;
		}

		public function load():void
		{
			throw new Error("LoadItem.load() should be implemented by a subclass");
		}

		////////////////////////////////////////////////////////////
		//   EVENT HANDLERS 
		////////////////////////////////////////////////////////////

		protected function onLoadComplete(event:Event):void
		{
			var loader:Object = event.target;

			if (loader is LoaderInfo)
			{
				this.asset = LoaderInfo(loader).content;
			}
			else if (loader is Sound)
			{
				this.asset = loader;
			}
			else if (loader is URLLoader)
			{
				this.asset = URLLoader(loader).data;
			}

			dispatchEvent(new LoadEvent(LoadEvent.COMPLETE));
		}

		protected function onLoadIOError(event:IOErrorEvent):void
		{
			dispatchEvent(new LoadErrorEvent("IOError: " + event.text));
		}

		////////////////////////////////////////////////////////////
		//   GETTERS / SETTERS 
		////////////////////////////////////////////////////////////

		public function get asset():Object
		{
			return _asset;
		}

		public function set asset(value:Object):void
		{
			_asset = value;
		}

		public function get priority():int
		{
			return _priority;
		}

		public function get progress():Number
		{
			throw new Error("LoadItem.get progress() should be implemented by a subclass");
		}

		public function get url():String
		{
			return _url.baseUrl;
		}

		public function set url(url:String):void
		{
			_url = new URL(url);
		}
	}
}


