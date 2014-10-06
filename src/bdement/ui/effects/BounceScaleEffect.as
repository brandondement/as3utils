package bdement.ui.effects
{

	import com.greensock.OverwriteManager;
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;

	public class BounceScaleEffect extends ScaleEffect
	{

		////////////////////////////////////////////////////////////
		//   CONSTRUCTOR 
		////////////////////////////////////////////////////////////

		public function BounceScaleEffect(scaleXTo:Number = 2.0, scaleYTo:Number = 2.0, duration:Number = 0.3, autoCenter:Boolean = true)
		{
			super(scaleXTo, scaleYTo, duration, autoCenter);
		}

		////////////////////////////////////////////////////////////
		//   PUBLIC API 
		////////////////////////////////////////////////////////////

		public override function play(target:DisplayObject):void
		{
			_target = target;

			_originalX = target.x;
			_originalY = target.y;

			var xTo:Number = target.x;
			var yTo:Number = target.y;

			if (autoCenter)
			{
				// create the illusion that the scale effect is centered 
				// around the target's center point
				//TODO: fix slight offset 
				xTo = target.x + ((target.scaleX - scaleXTo) * target.width / 2);
				yTo = target.y + ((target.scaleY - scaleYTo) * target.height / 2);
			}

			var timeline:TimelineLite = new TimelineLite();
			timeline.append(TweenLite.to(target, duration / 2, {scaleX:scaleXTo, scaleY:scaleYTo, x:xTo, y:yTo, overwrite:OverwriteManager.AUTO, onStart:onEffectStart}));
			timeline.append(TweenLite.to(target, duration / 2, {scaleX:1, scaleY:1, x:_originalX, y:_originalY, overwrite:OverwriteManager.AUTO, onComplete:effectEnd}));
			timeline.play();
		}
	}
}
