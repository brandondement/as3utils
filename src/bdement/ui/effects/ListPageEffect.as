package bdement.ui.effects
{

	import flash.display.DisplayObjectContainer;

	public class ListPageEffect extends Effect
	{

		////////////////////////////////////////////////////////////
		//   PUBLIC API 
		////////////////////////////////////////////////////////////

		public function prePlay(list:DisplayObjectContainer, currentPageIndex:int, nextPageIndex:int):void
		{
			throw new Error("ListPageEffect.prePlay() should be implemented by a subclass!");
		}
	}
}
