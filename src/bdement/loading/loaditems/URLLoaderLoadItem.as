package bdement.loading.loaditems
{

	import bdement.loading.events.LoadEvent;
	import bdement.util.IDisposable;

	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	[Event(name="cancel", type="bdement.loading.events.LoadEvent")]
	[Event(name="complete", type="bdement.loading.events.LoadEvent")]
	[Event(name="error", type="bdement.loading.events.LoadErrorEvent")]
	internal class URLLoaderLoadItem extends LoadItem implements IDisposable
	{

		////////////////////////////////////////////////////////////
		//   ATTRIBUTES 
		////////////////////////////////////////////////////////////

		protected var _loader:URLLoader;

		////////////////////////////////////////////////////////////
		//   CONSTRUCTOR 
		////////////////////////////////////////////////////////////

		public function URLLoaderLoadItem(url:String, priority:int = 0)
		{
			super(url, priority);
		}

		////////////////////////////////////////////////////////////
		//   PUBLIC API 
		////////////////////////////////////////////////////////////

		public override function cancel():void
		{
			if (_loader)
			{
				removeLoaderListeners(_loader);

				try
				{
					_loader.close();
				}
				catch (e:IOError)
				{
					// The loader will throw an IOError (with error code 2029)
					// if it wasn't loading anything, which we ignore. If it was
					// some other kind of error, we throw the error
					if (e.errorID != 2029)
					{
						throw e;
					}
				}
			}

			dispatchEvent(new LoadEvent(LoadEvent.CANCEL));
		}

		public override function dispose():void
		{
			super.dispose();

			if (_loader)
			{
				removeLoaderListeners(_loader);
				_loader = null;
			}
		}

		public override function load():void
		{
			// ensure that only 1 loader is used for this BitmapLoadItem instance
			if (!_loader)
			{
				_loader = new URLLoader();
				addLoaderListeners(_loader);
			}

			//TODO: ??? supply LoaderContext to separate application domains
			_loader.load(new URLRequest(_url.toString()));
		}

		////////////////////////////////////////////////////////////
		//   PROTECTED METHODS 
		////////////////////////////////////////////////////////////

		protected function addLoaderListeners(loader:URLLoader):void
		{
			loader.addEventListener(Event.COMPLETE, onLoadComplete, false, 0, true);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onLoadIOError, false, 0, true);
		}

		protected function removeLoaderListeners(loader:URLLoader):void
		{
			_loader.removeEventListener(Event.COMPLETE, onLoadComplete);
			_loader.removeEventListener(IOErrorEvent.IO_ERROR, onLoadIOError);
		}

		////////////////////////////////////////////////////////////
		//   GETTERS / SETTERS 
		////////////////////////////////////////////////////////////

		public override function get progress():Number
		{
			if (!_loader)
			{
				return 0;
			}

			return _loader.bytesLoaded / _loader.bytesTotal;
		}
	}
}


