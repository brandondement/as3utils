package bdement.ui.modals
{

	import flash.display.DisplayObjectContainer;

	public interface IModalManager
	{
		function addModal(modal:Modal, priority:String = "SEQUENTIAL"):void;

		function dispose():void;

		function removeModal(modal:Modal):void;

		function get container():DisplayObjectContainer;

		function set container(value:DisplayObjectContainer):void
	}
}
