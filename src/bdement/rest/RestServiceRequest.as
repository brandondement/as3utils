package bdement.rest
{

	import bdement.logging.*;
	import flash.events.ErrorEvent;
	import flash.events.EventDispatcher;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	[Event(name = "complete", type = "bdement.rest.RestServiceEvent")]
	[Event(name = "error", type = "bdement.rest.RestServiceEvent")]
	public class RestServiceRequest extends EventDispatcher
	{

		////////////////////////////////////////////////////////////
		//   CONSTANTS 
		////////////////////////////////////////////////////////////

		public static const RESPONSE_TYPE_AMF:String = ".amf";

		public static const RESPONSE_TYPE_JSON:String = ".json";

		////////////////////////////////////////////////////////////
		//   ATTRIBUTES 
		////////////////////////////////////////////////////////////

		protected var _endpoint:String;

		protected var _error:ErrorEvent;

		protected var _method:String;

		protected var _params:URLVariables;

		protected var _response:Object;

		protected var _responseText:String;

		protected var _responseType:String;

		protected var _success:Boolean = false;

		////////////////////////////////////////////////////////////
		//   CONSTRUCTOR 
		////////////////////////////////////////////////////////////

		public function RestServiceRequest(url:String, method:String = "GET", params:URLVariables = null, responseType:String = ".json")
		{
			super(this);

			_endpoint = url;

			if (_endpoint.charAt(_endpoint.length - 1) == "/")
			{
				_endpoint = _endpoint.substr(0, _endpoint.length - 1);
			}

			_endpoint += responseType;
			_method = method ? method : URLRequestMethod.GET;
			_params = params ? params : new URLVariables();

			_responseType = responseType;
		}

		////////////////////////////////////////////////////////////
		//   EVENT HANDLERS 
		////////////////////////////////////////////////////////////

		protected function onError(error:ErrorEvent):void
		{
			throw new Error("RestServiceRequest.onError should be implemented by a subclass!");
		}

		protected function onResponse(response:Object):void
		{
			throw new Error("RestServiceRequest.onResponse should be implemented by a subclass!");
		}

		////////////////////////////////////////////////////////////
		//   GETTERS / SETTERS 
		////////////////////////////////////////////////////////////

		public function get endpoint():String
		{
			return _endpoint;
		}

		public function get error():ErrorEvent
		{
			return _error;
		}

		public function set error(value:ErrorEvent):void
		{
			_error = value;
			onError(_error);
			dispatchEvent(new RestServiceEvent(RestServiceEvent.ERROR));
		}

		public function get method():String
		{
			return _method;
		}

		public function get params():URLVariables
		{
			return _params;
		}

		public function get response():Object
		{
			return _response;
		}

		public function set response(response:Object):void
		{
			if (_responseType == RESPONSE_TYPE_JSON)
			{
				_responseText = String(response);
				_response = JSON.parse(response.toString());
			}
			else if (_responseType == RESPONSE_TYPE_AMF)
			{
				_response = response;
			}

			_success = _response.success;

			if (_success)
			{
				onResponse(_response);
			}

			dispatchEvent(new RestServiceEvent(RestServiceEvent.COMPLETE));
		}

		public function get responseType():String
		{
			return _responseType;
		}

		public function get success():Boolean
		{
			return _success;
		}
	}
}


