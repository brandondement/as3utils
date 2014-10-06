package bdement.loading
{

	import bdement.loading.loaditems.ILoadItem;

	/**
	 *
	 * USAGE:
	 *
	 * var loadService:ILoadService = new LoadService();
	 *
	 * var loadItem:ILoadItem;
	 *
	 * loadItem	= new BitmapLoadItem("http://server/image.png",	LoadPriority.HIGH);
	 * loadItem = new SWFLoadItem("http://server/image.png",	LoadPriority.MEDIUM);
	 * loadItem = new SoundLoadItem("http://server/image.png",	LoadPriority.LOW);
	 * loadItem = new XMLLoadItem("http://server/image.png",	LoadPriority.PRELOAD);
	 * loadItem = new TextLoadItem("http://server/image.png",	LoadPriority.IMMEDIATE);
	 *
	 * loadItem.priority										= LoadPriority.IMMEDIATE;
	 * loadItem.url												= "http://server/asset.jpg";
	 * trace(loadItem.progress);								// 0.0 - 1.0
	 *
	 * loadItem.addEventListener(IOErrorEvent.IO_ERROR,			onIOError);
	 * loadItem.addEventListener(LoadEvent.COMPLETE,			onLoadComplete);
	 * loadItem.addEventListener(LoadEvent.START,				onLoadStart);
	 * loadItem.addEventListener(LoadProgressEvent.PROGRESS,	onLoadProgress);
	 *
	 * loadService.load(loadItem);
	 * loadService.cancel(loadItem);
	 *
	 * var bitmap:Bitmap				= Bitmap(bitmapLoadItem.asset);		// will be null until LoadEvent.COMPLETE is fired
	 * bitmap							= bitmapLoadItem.bitmap;			// will be null until LoadEvent.COMPLETE is fired
	 *
	 * var displayObject:DisplayObject	= DisplayObject(swfLoadItem.asset);	// will be null until LoadEvent.COMPLETE is fired
	 * displayObject					= swfLoadItem.displayObject;		// will be null until LoadEvent.COMPLETE is fired
	 *
	 * var sound:Sound					= Sound(soundLoadItem.asset);		// will be null until LoadEvent.COMPLETE is fired
	 * sound							= soundLoadItem.sound;				// will be null until LoadEvent.COMPLETE is fired
	 *
	 * var xml:XML						= XML(xmlLoadItem.asset);			// will be null until LoadEvent.COMPLETE is fired
	 * xml								= xmlLoadItem.xml;					// will be null until LoadEvent.COMPLETE is fired
	 *
	 * var text:String					= String(textLoadItem.asset);		// will be null until LoadEvent.COMPLETE is fired
	 * text								= textLoadItem.text;				// will be null until LoadEvent.COMPLETE is fired
	 *
	 */
	public interface ILoadService
	{
		function cancel(loadItem:ILoadItem):void;
		function load(loadItem:ILoadItem):void;
	}
}
