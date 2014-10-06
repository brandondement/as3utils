package bdement.ui.effects
{

	import bdement.assets.IAssetManager;
	import bdement.loading.ILoadService;
	import bdement.loading.LoadPriority;
	import bdement.loading.events.LoadEvent;
	import bdement.loading.loaditems.SoundLoadItem;
	import com.pblabs.sound.ISoundHandle;
	import com.pblabs.sound.ISoundManager;
	import flash.display.DisplayObject;
	import flash.media.Sound;

	public class SoundEffect extends Effect
	{

		////////////////////////////////////////////////////////////
		//   CLASS ATTRIBUTES 
		////////////////////////////////////////////////////////////

		public static var assetManager:IAssetManager;

		public static var soundManager:ISoundManager;

		////////////////////////////////////////////////////////////
		//   ATTRIBUTES 
		////////////////////////////////////////////////////////////

		private var _sound:Object;

		////////////////////////////////////////////////////////////
		//   CONSTRUCTOR 
		////////////////////////////////////////////////////////////

		public function SoundEffect(source:Object)
		{
			constructor(source);
		}

		private function constructor(source:Object):void
		{
			_sound = source;
		}

		////////////////////////////////////////////////////////////
		//   PUBLIC API 
		////////////////////////////////////////////////////////////

		public override function play(target:DisplayObject):void
		{
			var soundToPlay:* = _sound;

			// If _sound is a string, assume it's a resource id and load accordingly
			if (_sound is String)
			{
				loadAndPlayResource(String(_sound));
				return;
			}

			if (_sound is Class)
			{
				var soundClass:Class = Class(_sound);
				soundToPlay = new soundClass();
			}
			soundManager.play(soundToPlay)
		}

		////////////////////////////////////////////////////////////
		//   PRIVATE METHODS 
		////////////////////////////////////////////////////////////

		// lazy loads and plays sound on demand - until cached, then instant
		private function loadAndPlayResource(assetId:String):void
		{
			assetManager.getSound(assetId, playSoundResource);
		}

		private function playSoundResource(sound:Sound):void
		{
			_sound = sound;
			play(null);
		}
		////////////////////////////////////////////////////////////
		//   EVENT HANDLERS 
		////////////////////////////////////////////////////////////
	}
}

