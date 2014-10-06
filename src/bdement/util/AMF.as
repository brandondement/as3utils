package bdement.util
{

	import flash.net.*;
	import flash.utils.*;

	public final class AMF
	{

		////////////////////////////////////////////////////////////
		//   CONSTANTS 
		////////////////////////////////////////////////////////////

		private static const _registry:Dictionary = new Dictionary(false);

		public static function deserialize(amfData:ByteArray, classTypes:Array):*
		{
			for each (var classType:Class in classTypes)
			{
				register(classType);
			}

			return amfData.readObject();
		}

		public static function serialize(object:*, classTypes:Array):ByteArray
		{
			for each (var classType:Class in classTypes)
			{
				register(classType);
			}

			var amfData:ByteArray = new ByteArray();
			amfData.writeObject(object);
			amfData.position = 0;

			return amfData;
		}

		private static function register(type:*):void
		{
			var className:String = getQualifiedClassName(type).replace("::", ".");

			if (!_registry[className])
			{
				var classType:Class = Class(getDefinitionByName(className));

				registerClassAlias(className, classType);

				_registry[className] = true;
			}
		}
	}
}
