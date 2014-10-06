package bdement.assets
{

	public interface IAssetManager
	{
		function getBitmap(assetId:String, completeCallback:Function):void;
		function getSound(assetId:String, completeCallback:Function):void;
		function getSWFObject(id:String, completeCallback:Function):void;

		function isBundleLoaded(bundleId:String):Boolean;
		function loadBundle(bundleId:String, completeCallback:Function):Array;

		function get xml():XML;
		function set xml(xml:XML):void;
	}
}

