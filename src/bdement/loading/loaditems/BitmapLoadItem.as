package bdement.loading.loaditems
{

	import flash.display.Bitmap;

	[Event(name = "cancel", type = "bdement.loading.events.LoadEvent")]
	[Event(name = "complete", type = "bdement.loading.events.LoadEvent")]
	[Event(name = "error", type = "bdement.loading.events.LoadErrorEvent")]
	public final class BitmapLoadItem extends LoaderLoadItem implements ILoadItem
	{

		////////////////////////////////////////////////////////////
		//   CONSTRUCTOR 
		////////////////////////////////////////////////////////////

		public function BitmapLoadItem(url:String = "", priority:int = 0)
		{
			super(url, priority);
		}

		////////////////////////////////////////////////////////////
		//   GETTERS / SETTERS 
		////////////////////////////////////////////////////////////

		public function get bitmap():Bitmap
		{
			if (_asset)
			{
				return Bitmap(_asset);
			}

			return null;
		}
	}
}


