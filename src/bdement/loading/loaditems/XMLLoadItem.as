package bdement.loading.loaditems
{

	import bdement.util.IDisposable;

	public final class XMLLoadItem extends URLLoaderLoadItem implements IDisposable
	{

		////////////////////////////////////////////////////////////
		//   CONSTRUCTOR 
		////////////////////////////////////////////////////////////

		public function XMLLoadItem(url:String, priority:int = 0)
		{
			super(url, priority);
		}

		////////////////////////////////////////////////////////////
		//   GETTERS / SETTERS 
		////////////////////////////////////////////////////////////

		public function get xml():XML
		{
			if (_asset)
			{
				return XML(_asset);
			}

			return null;
		}
	}
}
