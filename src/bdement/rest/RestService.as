package bdement.rest
{

	import bdement.logging.*;
	import bdement.util.getClassName;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.Dictionary;

	public class RestService implements IRestService
	{

		////////////////////////////////////////////////////////////
		//   ATTRIBUTES 
		////////////////////////////////////////////////////////////

		protected var _logger:ILogger = getLogger(this);

		protected var _requests:Dictionary;

		protected var _url:String;

		////////////////////////////////////////////////////////////
		//   CONSTRUCTOR 
		////////////////////////////////////////////////////////////

		public function RestService(url:String = null)
		{
			_requests = new Dictionary(true);
			this.url = url;
		}

		////////////////////////////////////////////////////////////
		//   PUBLIC API 
		////////////////////////////////////////////////////////////

		public function sendRequest(request:RestServiceRequest):void
		{
			if (!_url)
			{
				throw new Error("RestService.url must be set before any requests can be sent!");
			}

			// prepare a URL Request to handle the RestServiceRequest
			var urlRequest:URLRequest = prepareUrlRequest(request);

			// create a url loader to handle this request
			var urlLoader:URLLoader = new URLLoader();

			// save the loader and it's corresponding request for later 
			_requests[urlLoader] = request;

			// add event listeners
			addListeners(urlLoader);

			// load
			urlLoader.load(urlRequest);
		}

		////////////////////////////////////////////////////////////
		//   EVENT HANDLERS 
		////////////////////////////////////////////////////////////

		protected function onComplete(event:Event):void
		{
			var urlLoader:URLLoader = URLLoader(event.target);
			var request:RestServiceRequest = _requests[urlLoader];

			// pass the data we just received back to the request who asked for it
			request.response = urlLoader.data;

			dispose(urlLoader);
		}

		protected function onHTTPStatus(event:HTTPStatusEvent):void
		{
			var urlLoader:URLLoader = URLLoader(event.target);
			var request:RestServiceRequest = _requests[urlLoader];

			var className:String = getClassName(request);

			_logger.debug("onHTTPStatus", className + " " + request.endpoint + " " + request.method + " HTTP Status:" + event.status + " params:" + unescape(request.params.toString()));

			if (event.status == 500)
			{
				_logger.error("Internal Server Error in " + request.endpoint);
				throw event;

				//TODO: Retry?
				dispose(urlLoader);
			}
		}

		protected function onIOError(event:IOErrorEvent):void
		{
			var urlLoader:URLLoader = URLLoader(event.target);
			var request:RestServiceRequest = _requests[urlLoader];

			_logger.error("onIOError", request.endpoint + " IOError: " + event.text);

			request.error = event;
			throw event;

			//TODO: Retry?
			dispose(urlLoader);
		}

		protected function onSecurityError(event:SecurityErrorEvent):void
		{
			var urlLoader:URLLoader = URLLoader(event.target);
			var request:RestServiceRequest = _requests[urlLoader];

			_logger.error("onSecurityError", request.endpoint + " SecurityError: " + event.text);

			request.error = event;
			throw event;

			dispose(urlLoader);
		}

		////////////////////////////////////////////////////////////
		//   PROTECTED METHODS 
		////////////////////////////////////////////////////////////

		protected function addListeners(urlLoader:URLLoader):void
		{
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			urlLoader.addEventListener(Event.COMPLETE, onComplete);
			urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTPStatus);
		}

		protected function dispose(urlLoader:URLLoader):void
		{
			removeListeners(urlLoader);

			_requests[urlLoader] = null;
			delete _requests[urlLoader];
		}

		protected function prepareUrlRequest(request:RestServiceRequest):URLRequest
		{
			var urlRequest:URLRequest = new URLRequest(_url + request.endpoint);

			urlRequest.data = request.params;
			var method:String = request.method;

			// check to see if we're using a REST method that Flash doesn't properly support
			if (method == URLRequestMethod.PUT || method == URLRequestMethod.DELETE || method == URLRequestMethod.POST)
			{
				// send a special header for the REST server to know what method we intended
				urlRequest.requestHeaders = [new URLRequestHeader("X-HTTP-Method-Override", method)];

				// set our method to POST so Flash can handle it 
				urlRequest.method = URLRequestMethod.POST;

				if (urlRequest.data.toString() == "")
				{
					// data can't be blank when emulating a PUT or DELETE request
					// http://cambiatablog.wordpress.com/2010/08/10/287/
					urlRequest.data = new URLVariables("dummy=data");
				}
			}

			return urlRequest;
		}

		protected function removeListeners(urlLoader:URLLoader):void
		{
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			urlLoader.removeEventListener(Event.COMPLETE, onComplete);
			urlLoader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTPStatus);
		}

		////////////////////////////////////////////////////////////
		//   GETTERS / SETTERS 
		////////////////////////////////////////////////////////////

		public function get url():String
		{
			return _url;
		}

		public function set url(value:String):void
		{
			_url = value;
			_logger.info("url", "Setting url: " + _url);
		}
	}
}
