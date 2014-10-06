package bdement.ui.effects
{

	import com.greensock.OverwriteManager;
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	import flash.geom.Orientation3D;

	public class ScaleEffect extends Effect
	{

		////////////////////////////////////////////////////////////
		//   ATTRIBUTES 
		////////////////////////////////////////////////////////////

		public var autoCenter:Boolean;

		public var scaleXTo:Number;

		public var scaleYTo:Number;

		protected var _originalX:Number;

		protected var _originalY:Number;

		protected var _target:DisplayObject;

		////////////////////////////////////////////////////////////
		//   CONSTRUCTOR 
		////////////////////////////////////////////////////////////

		public function ScaleEffect(scaleXTo:Number = 1.0, scaleYTo:Number = 1.0, duration:Number = 0.3, autoCenter:Boolean = true)
		{
			this.scaleXTo = scaleXTo;
			this.scaleYTo = scaleYTo;
			this.duration = duration;
			this.autoCenter = autoCenter;
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
				xTo = target.x + ((target.scaleX - scaleXTo) * target.width / 2);
				yTo = target.y + ((target.scaleY - scaleYTo) * target.height / 2);
			}

			TweenLite.to(target, duration, {scaleX:scaleXTo, scaleY:scaleYTo, x:xTo, y:yTo, overwrite:OverwriteManager.AUTO, onStart:onEffectStart, onComplete:effectEnd});
		}

		////////////////////////////////////////////////////////////
		//   PROTECTED METHODS 
		////////////////////////////////////////////////////////////

		protected function effectEnd():void
		{
			// restore the object to it's original location (auto centering doesn't seem to be 100% accurate, especially with textfields)  
			_target.x = _originalX;
			_target.y = _originalY;

			if (onEffectEnd is Function)
			{
				onEffectEnd();
			}
		}
	}
}
