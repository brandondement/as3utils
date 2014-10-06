package bdement.ui.effects
{

	import com.greensock.TweenLite;
	import flash.display.DisplayObject;

	public class TweenEffect extends Effect
	{

		////////////////////////////////////////////////////////////
		//   ATTRIBUTES 
		////////////////////////////////////////////////////////////

		public var params:Object;

		////////////////////////////////////////////////////////////
		//   CONSTRUCTOR 
		////////////////////////////////////////////////////////////

		public function TweenEffect(duration:Number, params:Object)
		{
			this.duration = duration;
			this.params = params;
		}

		////////////////////////////////////////////////////////////
		//   PUBLIC API 
		////////////////////////////////////////////////////////////

		public override function play(target:DisplayObject):void
		{
			params.onStart = onEffectStart;
			params.onComplete = onEffectEnd;

			TweenLite.to(target, duration, params);
		}
	}
}
