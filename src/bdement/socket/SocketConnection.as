package bdement.socket
{

	import bdement.logging.ILogger;
	import bdement.logging.getLogger;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.utils.Endian;

	[Event(name = "CONNECTION_ERROR", type = "bdement.socket.SocketEvent")]
	[Event(name = "CONNECTION_NOT_FOUND", type = "bdement.socket.SocketEvent")]
	[Event(name = "CONNECTION_SUCCESS", type = "bdement.socket.SocketEvent")]
	public class SocketConnection extends EventDispatcher
	{

		////////////////////////////////////////////////////////////
		//   ATTRIBUTES 
		////////////////////////////////////////////////////////////

		private var _endian:String;

		private var _host:String;

		private var _isConnecting:Boolean = false;

		private var _logger:ILogger = getLogger(this);

		private var _parser:ICommandParser;

		private var _port:int;

		private var _socket:Socket;

		////////////////////////////////////////////////////////////
		//   CONSTRUCTOR 
		////////////////////////////////////////////////////////////

		public function SocketConnection(parser:ICommandParser, endian:String = Endian.BIG_ENDIAN)
		{
			_parser = parser;
			_endian = endian;
		}

		////////////////////////////////////////////////////////////
		//   PUBLIC API 
		////////////////////////////////////////////////////////////

		public function connect(host:String, port:int):void
		{
			_logger.debug("connect", "Attempting to connect with " + host + ":" + port);

			if (_isConnecting)
			{
				return;
			}

			_isConnecting = true;

			this._host = host;
			this._port = port;

			if (_socket != null && _socket.connected)
			{
				removeListeners(_socket);
				disconnect();
			}

			_socket = null;

			// the creation of the socket will suddently trigger the request for a policy file
			// actually the socket won't be created untill the policy file request is successfully responded
			try
			{
				_socket = new Socket(host, port);
				_socket.endian = _endian;
			}
			catch (error:Error)
			{
				_socket.close();
				_logger.error("connect", error.message);
			}

			_parser.setSocket(_socket);
			addListeners(_socket);

			_socket.connect(host, port);
		}

		public function disconnect():void
		{
			try
			{
				_socket.close();
			}
			catch (error:Error)
			{
				_logger.error("disconnect", error.message);
			}

			removeListeners(_socket);
		}

		public function reconnect():void
		{
			if (this.isConnected)
			{
				disconnect();
			}

			connect(_host, _port);
		}

		public function sendRequest(command:ICommand):void
		{
			if (this.isConnected)
			{
				try
				{
					_parser.sendRequest(command);
				}
				catch (error:Error)
				{
					onConnectionLost();

					_logger.error("sendRequest", error.message);
				}
			}
		}

		////////////////////////////////////////////////////////////
		//   EVENT HANDLERS 
		////////////////////////////////////////////////////////////

		private function onConnect(event:Event):void
		{
			_logger.debug("onConnect", "Method called.");

			_isConnecting = false;

			dispatchEvent(new SocketEvent(SocketEvent.CONNECTION_SUCCESS));
		}

		private function onConnectionLost(event:Event = null):void
		{
			_logger.warn("onConnectionLost", "Method called.");

			dispatchEvent(new SocketEvent(SocketEvent.CONNECTION_LOST));
		}

		private function onIOError(event:IOErrorEvent):void
		{
			_logger.error("onIOError", "Method called.");

			_isConnecting = false;

			dispatchEvent(new SocketEvent(SocketEvent.CONNECTION_ERROR));
		}

		private function onSecurityError(event:SecurityErrorEvent):void
		{
			_logger.error("onSecurityError", event.text);

			_isConnecting = false;

			dispatchEvent(new SocketEvent(SocketEvent.CONNECTION_ERROR));
		}

		private function onSocketData(event:ProgressEvent):void
		{
			_parser.readData();
		}

		////////////////////////////////////////////////////////////
		//   PRIVATE METHODS 
		////////////////////////////////////////////////////////////

		private function addListeners(socket:Socket):void
		{
			if (!socket.hasEventListener(Event.CONNECT))
			{
				socket.addEventListener(Event.CONNECT, onConnect);
				socket.addEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
				socket.addEventListener(Event.CLOSE, onConnectionLost);
				socket.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
				socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			}
		}

		private function removeListeners(socket:Socket):void
		{
			if (socket.hasEventListener(Event.CONNECT))
			{
				socket.removeEventListener(Event.CONNECT, onConnect);
				socket.removeEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
				socket.removeEventListener(Event.CLOSE, onConnectionLost);
				socket.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
				socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			}
		}

		////////////////////////////////////////////////////////////
		//   GETTERS / SETTERS 
		////////////////////////////////////////////////////////////

		public function get endian():String
		{
			return _endian;
		}

		public function get host():String
		{
			return _host;
		}

		public function get isConnected():Boolean
		{
			if (!_socket)
			{
				return false;
			}

			return _socket.connected;
		}

		public function get parser():ICommandParser
		{
			return _parser;
		}

		public function get port():int
		{
			return _port;
		}

		public function get socket():Socket
		{
			return _socket;
		}
	}
}


