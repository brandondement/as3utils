package bdement.loading.loaditems
{

	import bdement.util.IDisposable;

	public final class TextLoadItem extends URLLoaderLoadItem implements IDisposable
	{

		////////////////////////////////////////////////////////////
		//   CONSTRUCTOR 
		////////////////////////////////////////////////////////////

		public function TextLoadItem(url:String, priority:int = 0)
		{
			super(url, priority);
		}

		////////////////////////////////////////////////////////////
		//   GETTERS / SETTERS 
		////////////////////////////////////////////////////////////

		public function get text():String
		{
			if (_asset)
			{
				return String(_asset);
			}

			return null;
		}
	}
}
