package bdement.ui.effects
{

	import com.greensock.TweenLite;
	import flash.display.DisplayObject;

	public class DelayEffect extends Effect
	{

		////////////////////////////////////////////////////////////
		//   CONSTRUCTOR 
		////////////////////////////////////////////////////////////

		public function DelayEffect(duration:Number = 1.0)
		{
			this.duration = duration;
		}

		////////////////////////////////////////////////////////////
		//   PUBLIC API 
		////////////////////////////////////////////////////////////

		public override function play(target:DisplayObject):void
		{
			TweenLite.to(target, duration, {onStart:onEffectStart, onComplete:onEffectEnd});
		}
	}
}
