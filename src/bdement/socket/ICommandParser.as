package bdement.socket
{

	import flash.net.Socket;

	public interface ICommandParser
	{
		function initialize():void;
		function readData():void;
		function sendRequest(command:ICommand):void;
		function setSocket(socket:Socket):void;
	}
}
