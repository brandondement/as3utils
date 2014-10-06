package bdement.ui.effects
{

	import flash.display.DisplayObject;

	public class SequenceEffect extends Effect
	{

		////////////////////////////////////////////////////////////
		//   ATTRIBUTES 
		////////////////////////////////////////////////////////////

		public var sequence:Array;

		private var _index:int = 0;

		private var _target:DisplayObject;

		////////////////////////////////////////////////////////////
		//   CONSTRUCTOR 
		////////////////////////////////////////////////////////////

		public function SequenceEffect(sequence:Array = null)
		{
			this.sequence = sequence;
		}

		////////////////////////////////////////////////////////////
		//   PUBLIC API 
		////////////////////////////////////////////////////////////

		public override function play(target:DisplayObject):void
		{
			_target = target;

			if (onEffectStart is Function)
			{
				onEffectStart();
			}

			playNext();
		}

		public function playNext():void
		{
			if (!sequence || _index >= sequence.length)
			{
				if (onEffectEnd is Function)
				{
					onEffectEnd();
				}
				return;
			}

			var effect:Effect = sequence[_index++];
			effect.onEffectEnd = playNext;
			effect.play(_target);
		}
	}
}
