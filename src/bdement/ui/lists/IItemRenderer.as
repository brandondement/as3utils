package bdement.ui.lists
{

	import bdement.util.IDisposable;

	public interface IItemRenderer extends IDisposable
	{
		function get data():*;
		function set data(value:*):void;
	}
}

