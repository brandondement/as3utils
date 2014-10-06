package bdement.ui.effects
{

	import com.greensock.TweenLite;
	import flash.display.DisplayObject;

	public class AlphaEffect extends Effect
	{

		////////////////////////////////////////////////////////////
		//   ATTRIBUTES 
		////////////////////////////////////////////////////////////

		public var end:Number;

		public var start:Number;

		////////////////////////////////////////////////////////////
		//   CONSTRUCTOR 
		////////////////////////////////////////////////////////////

		public function AlphaEffect(start:Number = 0, end:Number = 1, duration:Number = 0.3)
		{
			this.start = start;
			this.end = end;
			this.duration = duration;
		}

		////////////////////////////////////////////////////////////
		//   PUBLIC API 
		////////////////////////////////////////////////////////////

		public override function play(target:DisplayObject):void
		{
			target.alpha = start;
			TweenLite.to(target, duration, {alpha:end, onStart:onEffectStart, onComplete:onEffectEnd});
		}
	}
}
