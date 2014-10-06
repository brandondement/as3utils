package bdement.loading.loaditems
{

	import bdement.loading.events.LoadEvent;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.net.URLRequest;

	public final class SoundLoadItem extends LoadItem implements ILoadItem
	{

		////////////////////////////////////////////////////////////
		//   ATTRIBUTES 
		////////////////////////////////////////////////////////////

		protected var _loader:Sound;

		////////////////////////////////////////////////////////////
		//   CONSTRUCTOR 
		////////////////////////////////////////////////////////////

		public function SoundLoadItem(url:String = "", priority:int = 0)
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
				_loader = new Sound();
				addLoaderListeners(_loader);
			}

			//TODO: ??? supply LoaderContext to separate application domains
			_loader.load(new URLRequest(_url.toString()));
		}

		////////////////////////////////////////////////////////////
		//   PRIVATE METHODS 
		////////////////////////////////////////////////////////////

		private function addLoaderListeners(loader:Sound):void
		{
			loader.addEventListener(Event.COMPLETE, onLoadComplete, false, 0, true);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onLoadIOError, false, 0, true);
		}

		private function removeLoaderListeners(loader:Sound):void
		{
			_loader.removeEventListener(Event.COMPLETE, onLoadComplete);
			_loader.removeEventListener(IOErrorEvent.IO_ERROR, onLoadIOError);
		}

		////////////////////////////////////////////////////////////
		//   GETTERS / SETTERS 
		////////////////////////////////////////////////////////////

		public function get sound():Sound
		{
			if (_asset)
			{
				return Sound(_asset);
			}

			return null;
		}
	}
}

