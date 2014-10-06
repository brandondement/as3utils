package bdement.loading.loaditems
{

	import bdement.loading.events.LoadEvent;
	import bdement.util.IDisposable;
	import flash.display.Loader;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;

	/**
	 * This is the internal base class for LoadItems that use a Loader
	 * to download their asset
	 */
	[Event(name = "cancel", type = "bdement.loading.events.LoadEvent")]
	[Event(name = "complete", type = "bdement.loading.events.LoadEvent")]
	[Event(name = "error", type = "bdement.loading.events.LoadErrorEvent")]
	internal class LoaderLoadItem extends LoadItem implements IDisposable
	{

		////////////////////////////////////////////////////////////
		//   ATTRIBUTES 
		////////////////////////////////////////////////////////////

		protected var _loader:Loader;

		////////////////////////////////////////////////////////////
		//   CONSTRUCTOR 
		////////////////////////////////////////////////////////////

		public function LoaderLoadItem(url:String, priority:int = 0)
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
				_loader = new Loader();
				addLoaderListeners(_loader);
			}

			//TODO: ??? supply LoaderContext to separate application domains
			_loader.load(new URLRequest(_url.toString()));
		}

		////////////////////////////////////////////////////////////
		//   PRIVATE METHODS 
		////////////////////////////////////////////////////////////

		private function addLoaderListeners(loader:Loader):void
		{
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete, false, 0, true);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadIOError, false, 0, true);
		}

		private function removeLoaderListeners(loader:Loader):void
		{
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoadComplete);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onLoadIOError);
		}
	}
}


