package bdement.video
{

	/**
	 * Defines the callback functions provided to NetConnection
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/net/NetConnection.html#client
	 */
	public interface IVideoClient
	{
		function onBWDone():void;
		function onCuePoint(infoObject:Object):void;
		function onMetaData(metadata:Object):void;
		function onPlayStatus(status:Object):void;
		function onXMPData(xmpData:Object):void;
	}
}
