package bdement.util
{

	import flash.net.URLVariables;

	public final class URL
	{

		////////////////////////////////////////////////////////////
		//   CONSTANTS 
		////////////////////////////////////////////////////////////

		public static const FILE_PROTOCOL:String = "file";

		public static const HTTP_PROTOCOL:String = "http";

		////////////////////////////////////////////////////////////
		//   ATTRIBUTES 
		////////////////////////////////////////////////////////////

		private var _url:String;

		////////////////////////////////////////////////////////////
		//   CONSTRUCTOR 
		////////////////////////////////////////////////////////////

		public function URL(url:String)
		{
			// if null is passed in, default to the empty string 
			_url = url ? url : "";
		}

		////////////////////////////////////////////////////////////
		//   PUBLIC API 
		////////////////////////////////////////////////////////////

		public function similarityTo(url:URL):Number
		{
			var pathSimilarity:Number = 1;
			var queryStringSimilarity:Number = 1;

			var divideBy:int = 0;

			if (_url == url.toString())
			{
				return 1;
			}

			// if the domains aren't even the same, there's no way these are similar requests
			if (this.domain != url.domain)
			{
				return 0;
			}

			// if the paths aren't exactly the same, we need to look deeper 
			if (this.path != url.path)
			{
				// split the path into parts and sort them for easy comparison
				var foundPathArray:Array = this.pathAsArray.sort();
				var expectedPathArray:Array = url.pathAsArray.sort();

				// they can't be similar if their paths aren't the same length
				if (foundPathArray.length != expectedPathArray.length)
				{
					return 0;
				}

				var partsWrong:int = 0;

				// look through all the parts and count how many are different
				for (var index:int = 0; index < foundPathArray.length; index++)
				{
					if (foundPathArray[index] != expectedPathArray[index])
					{
						partsWrong++;
					}
				}

				pathSimilarity = (partsWrong == 0) ? 1 : (1 - partsWrong / foundPathArray.length);
			}

			// if the query strings aren't exactly the same, we need to look deeper
			if (this.queryString != url.queryString)
			{
				// get the query strings as objects with key/val pairs
				var foundParams:URLVariables = this.queryParams;
				var expectedParams:URLVariables = url.queryParams;

				var keysWrong:int = 0;
				var valsWrong:int = 0;

				var totalFields:int = 0;

				for (var key:String in foundParams)
				{
					totalFields++;

					if (expectedParams.hasOwnProperty(key))
					{
						if (foundParams[key] != expectedParams[key])
						{
							valsWrong++;
						}
					}
					else
					{
						keysWrong++;
					}
				}

				if (totalFields == 0 || (keysWrong == 0 && valsWrong == 0))
				{
					queryStringSimilarity = 1;
				}
				else
				{
					queryStringSimilarity = (totalFields - keysWrong - valsWrong) / totalFields;
				}
			}

			return (pathSimilarity + queryStringSimilarity) / 2;
		}

		public function toString():String
		{
			return _url;
		}

		////////////////////////////////////////////////////////////
		//   PRIVATE METHODS 
		////////////////////////////////////////////////////////////

		private function getQueryParamsManually():URLVariables
		{
			var urlvars:URLVariables = new URLVariables();
			var keyVals:Array = this.queryString.split("&");

			for each (var keyVal:String in keyVals)
			{
				var pair:Array = keyVal.split("=");
				var key:String = pair[0];

				var val:String = "";

				if (pair.length > 1)
				{
					val = pair[1];
				}

				urlvars[key] = val;
			}

			return urlvars;
		}

		////////////////////////////////////////////////////////////
		//   GETTERS / SETTERS 
		////////////////////////////////////////////////////////////

		// rename: fullPath?
		public function get baseUrl():String
		{
			var end:int = _url.indexOf("?");

			if (end == -1)
			{
				end = _url.length;
			}

			return _url.substring(0, end);
		}

		public function get domain():String
		{
			return _url.substring(endOfProtocol, startOfPath);
		}

		private function get endOfPath():int
		{
			if (hasQueryString)
			{
				return _url.indexOf("?");
			}

			return _url.length;
		}

		public function get endOfPort():int
		{
			return _url.indexOf("/", startOfPort);
		}

		private function get endOfProtocol():int
		{
			var end:int;

			if (_url.indexOf("//") == -1)
			{
				return 0;
			}

			return _url.lastIndexOf("//") + 2;
		}

		private function get endOfServer():int
		{
			return Math.min(startOfPath, startOfPort);
		}

		public function get extension():String
		{
			var start:int = _url.lastIndexOf(".");
			return _url.substr(start + 1);
		}

		public function get filename():String
		{
			var start:int = _url.lastIndexOf("/") + 1;
			var end:int = _url.indexOf("?");

			if (end == -1)
			{
				end = _url.length;
			}

			return _url.substring(start, end);
		}

		public function get hasQueryString():Boolean
		{
			return _url.indexOf("?") != -1;
		}

		public function get parameters():Object
		{
			var params:Object = new Object();
			var qs:String = queryString;

			if (qs == "")
			{
				return params;
			}

			var pairs:Array = qs.split("&");

			for each (var pair:String in pairs)
			{
				var keyVal:Array = pair.split("=");
				var key:String = keyVal[0];
				var val:String = keyVal[1];
				params[key] = val;
			}

			return params;
		}

		public function get path():String
		{
			return _url.substring(startOfPath, endOfPath);
		}

		public function get pathAsArray():Array
		{
			return this.path.split("/");
		}

		public function get port():int
		{
			if (startOfPort == 0)
			{
				return 80;
			}

			return int(_url.substring(startOfPort, endOfPort));
		}

		public function get protocol():String
		{
			if (endOfProtocol == 0)
			{
				return HTTP_PROTOCOL;
			}

			return _url.substring(0, endOfProtocol);
		}

		public function get queryParams():URLVariables
		{
			var urlvars:URLVariables;

			try
			{
				urlvars = new URLVariables(this.queryString);
			}
			catch (e:Error)
			{
				// Error #2101: The String passed to URLVariables.decode() 
				// must be a URL-encoded query string containing name/value pairs.
				return getQueryParamsManually();
			}

			return urlvars;
		}

		public function get queryString():String
		{
			return _url.substring(startOfQueryString);
		}

		public function get server():String
		{
			return _url.substring(endOfProtocol, endOfServer);
		}

		private function get startOfPath():int
		{
			var startOfPath:int = _url.indexOf("/", endOfProtocol);

			if (startOfPath == -1)
			{
				startOfPath = _url.length;
			}

			return startOfPath;
		}

		private function get startOfPort():int
		{
			var startOfPort:int = _url.indexOf(":", endOfProtocol) + 1;

			if (startOfPort == -1)
			{
				startOfPort = _url.length;
			}

			return startOfPort;
		}

		private function get startOfQueryString():int
		{
			var start:int = _url.indexOf("?") + 1;

			if (start == 0)
			{
				return _url.length;
			}

			return start;
		}

		public function get urlVariables():URLVariables
		{
			return queryParams;
		}
	}
}
