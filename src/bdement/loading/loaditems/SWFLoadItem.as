package bdement.loading.loaditems
{

	import flash.display.DisplayObject;
	import flash.display.LoaderInfo;
	import flash.system.ApplicationDomain;

	public final class SWFLoadItem extends LoaderLoadItem implements ILoadItem
	{

		////////////////////////////////////////////////////////////
		//   ATTRIBUTES 
		////////////////////////////////////////////////////////////

		protected var _symbolName:String;

		////////////////////////////////////////////////////////////
		//   CONSTRUCTOR 
		////////////////////////////////////////////////////////////

		public function SWFLoadItem(url:String = "", symbolName:String = "", priority:int = 0)
		{
			super(url, priority);

			_symbolName = symbolName;
		}

		////////////////////////////////////////////////////////////
		//   GETTERS / SETTERS 
		////////////////////////////////////////////////////////////

		public function get swf():DisplayObject
		{
			if (_asset)
			{
				return DisplayObject(_asset);
			}

			return null;
		}

		public function get symbol():DisplayObject
		{
			if (!swf)
			{
				return null;
			}

			var loaderInfo:LoaderInfo = swf.loaderInfo;
			var appDomain:ApplicationDomain = loaderInfo.applicationDomain;

			//TODO: try/catch
			var ClassDefinition:Class = Class(appDomain.getDefinition(_symbolName));

			if (!ClassDefinition)
			{
				return null;
			}

			return DisplayObject(new ClassDefinition());
		}

		public function get symbolName():String
		{
			return _symbolName;
		}
	}
}
