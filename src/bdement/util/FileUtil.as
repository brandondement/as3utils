package bdement.util
{

	import flash.filesystem.*;
	import flash.utils.*;

	public final class FileUtil
	{
		public static function readBytes(filePath:String):ByteArray
		{
			var file:File = new File(filePath);
			var fileStream:FileStream = new FileStream();
			var data:ByteArray = new ByteArray();

			fileStream.open(file, FileMode.READ);
			fileStream.readBytes(data, 0, data.length);
			fileStream.close();

			return data;
		}

		public static function writeBytes(filePath:String, data:ByteArray):void
		{
			var file:File = new File(filePath);
			var fileStream:FileStream = new FileStream();

			fileStream.open(file, FileMode.WRITE);
			fileStream.writeBytes(data, 0, data.length);
			fileStream.close();
		}
	}
}
