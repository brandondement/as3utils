package bdement.socket
{

	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;

	public interface ICommand
	{
		function read(input:IDataInput):void;
		function write(output:IDataOutput):void;

		function get id():int;
		function get length():int;
	}
}
