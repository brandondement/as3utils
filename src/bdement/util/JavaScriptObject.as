package bdement.util
{

	import flash.external.ExternalInterface;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import bdement.logging.ILogger;
	import bdement.logging.getLogger;

	public class JavaScriptObject extends ByteArray
	{

		////////////////////////////////////////////////////////////
		//   CONSTANTS 
		////////////////////////////////////////////////////////////

		private static const _cache:Dictionary = new Dictionary();

		private static const _logger:ILogger = getLogger(JavaScriptObject);

		////////////////////////////////////////////////////////////
		//   CLASS ATTRIBUTES 
		////////////////////////////////////////////////////////////

		private static var _hasCheckedJSAvailability:Boolean = false;

		private static var _isJsAvailable:Boolean = true;

		////////////////////////////////////////////////////////////
		//   CONSTRUCTOR 
		////////////////////////////////////////////////////////////

		public function JavaScriptObject()
		{
			super();

			var name:String = getQualifiedClassName(this);

			if (!isJsAvailable)
			{
				_logger.error("Can't create " + name + ", ExternalInterface is unavailable!");
				return;
			}

			//TODO: Should we use ExternalInterface.marshallExceptions?
			//TODO: Could we support Object-Oriented JavaScript?
			//TODO: Could we support unnamed functions?

			// prevent us from eval()ing more than once
			if (_cache[name] == null)
			{
				ExternalInterface.call("eval", this.toString());
				_cache[name] = true;
			}
		}

		////////////////////////////////////////////////////////////
		//   CLASS METHODS 
		////////////////////////////////////////////////////////////

		// just a convenience method/safety check for adding callbacks via ExternalInterface
		protected static function addCallback(functionName:String, closure:Function):void
		{
			if (!isJsAvailable)
			{
				return;
			}

			ExternalInterface.addCallback(functionName, closure)
		}

		// just a convenience method/safety check for passing these params through to ExternalInterface 
		protected static function call(functionName:String, ... arguments):*
		{
			if (!isJsAvailable)
			{
				return null;
			}

			return ExternalInterface.call(functionName, arguments);
		}

		private static function checkJSAvailability():Boolean
		{
			if (!ExternalInterface.available)
			{
				_logger.info("ExternalInterface.available is false!");
				return false;
			}

			var isAvailable:Boolean = false;

			try
			{
				isAvailable = ExternalInterface.call("function() { return true; }");
			}
			catch (e:Error)
			{
				_logger.info("ExternalInterface.call() failed!");
			}

			return isAvailable;
		}

		// cookies[key] returns undefined/null if key does not exist
		public static function getCookie(key:String):Object
		{
			return cookies[key];
		}

		public static function hasCookie(key:String, val:String):Boolean
		{
			if (!isJsAvailable)
			{
				return false;
			}

			var cookieString:String = ExternalInterface.call("eval", "document.cookie");

			if (!cookieString)
			{
				return false;
			}

			var regex:RegExp = new RegExp(key + "=" + val);
			return cookieString.search(regex) != -1;
		}

		public static function injectScript(source:String):void
		{
			var injectTag:String =  'function () {' +
				'var tag = document.createElement("script");' +
				'tag.src = "' + source + '";' +
				'tag.type="text/javascript";' +
				'document.getElementsByTagName("head")[0].appendChild(tag); }';

			call(injectTag);
		}

		////////////////////////////////////////////////////////////
		//   GETTERS / SETTERS 
		////////////////////////////////////////////////////////////

		public static function get cookies():Object
		{
			var cookies:Object = new Object();

			if (!isJsAvailable)
			{
				return cookies;
			}

			var cookieString:String = ExternalInterface.call("eval", "document.cookie");

			if (!cookieString)
			{
				return cookies;
			}

			var keyVals:Array = cookieString.split("; ");

			for each (var keyVal:String in keyVals)
			{
				var pair:Array = keyVal.split("=");
				var key:String = String(pair[0]).replace(/^ +/, "").replace(/ +$/, ""); // remove leading and trailing whitespace
				var val:String = String(pair[1]).replace(/^ +/, "").replace(/ +$/, ""); // remove leading and trailing whitespace

				cookies[key] = val;
			}

			return cookies;
		}

		public static function get isJsAvailable():Boolean
		{
			if (!_hasCheckedJSAvailability)
			{
				_isJsAvailable = checkJSAvailability();
				_hasCheckedJSAvailability = true;
			}

			return _isJsAvailable;
		}
	}
}
