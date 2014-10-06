package bdement.ui.effects
{

	import flash.display.DisplayObject;

	public class Effect
	{

		////////////////////////////////////////////////////////////
		//   ATTRIBUTES 
		////////////////////////////////////////////////////////////

		public var duration:Number;

		public var onEffectEnd:Function;

		public var onEffectStart:Function;

		////////////////////////////////////////////////////////////
		//   PUBLIC API 
		////////////////////////////////////////////////////////////

		public function play(target:DisplayObject):void
		{
			throw new Error("Effect.play should be implemented by a subclass!");
		}
	}
}
