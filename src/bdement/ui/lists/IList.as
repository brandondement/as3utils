package bdement.ui.lists
{

	import bdement.ui.effects.ListPageEffect;
	import flash.display.DisplayObject;

	public interface IList
	{
		function get data():*;
		function set data(value:*):void;

		function get divider():DisplayObject;
		function set divider(divider:DisplayObject):void;

		function get itemRenderer():Class;
		function set itemRenderer(value:Class):void;

		function get itemsPerPage():int;
		function set itemsPerPage(itemsPerPage:int):void;

		function get page():int;
		function set page(page:int):void;

		function get pageEffect():ListPageEffect;
		function set pageEffect(pageEffect:ListPageEffect):void;

		function get pages():int;

		function get selected():IItemRenderer;
		function set selected(item:IItemRenderer):void;

		function get selectedIndex():int;
	}
}
