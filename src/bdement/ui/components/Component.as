package bdement.ui.components
{

	import bdement.assets.IAssetManager;
	import bdement.ui.effects.Effect;
	import bdement.util.IDisposable;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class Component extends Sprite implements IDisposable
	{

		////////////////////////////////////////////////////////////
		//   CLASS ATTRIBUTES 
		////////////////////////////////////////////////////////////

		public static var assetManager:IAssetManager;

		////////////////////////////////////////////////////////////
		//   ATTRIBUTES 
		////////////////////////////////////////////////////////////

		[ArrayElementType("bdement.ui.effects.Effect")]
		public var addedEffects:Array;

		[ArrayElementType("bdement.ui.effects.Effect")]
		public var clickEffects:Array;

		[ArrayElementType("bdement.ui.effects.Effect")]
		public var hideEffects:Array;

		public var id:String;

		[ArrayElementType("bdement.ui.effects.Effect")]
		public var rollOutEffects:Array;

		[ArrayElementType("bdement.ui.effects.Effect")]
		public var rollOverEffects:Array;

		[ArrayElementType("bdement.ui.effects.Effect")]
		public var showEffects:Array;

		protected var _mask:DisplayObject;

		////////////////////////////////////////////////////////////
		//   CONSTRUCTOR 
		////////////////////////////////////////////////////////////

		public function Component()
		{
			super();

			buttonMode = true;
			useHandCursor = false;

			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

			addEventListener(MouseEvent.CLICK, onClick);
		}

		////////////////////////////////////////////////////////////
		//   PUBLIC API 
		////////////////////////////////////////////////////////////

		public function dispose():void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			removeEventListener(MouseEvent.CLICK, onClick);

			if (rollOverEffects)
			{
				rollOverEffects.length = 0;
			}

			if (rollOutEffects)
			{
				rollOutEffects.length = 0;
			}

			if (clickEffects)
			{
				clickEffects.length = 0;
			}

			if (showEffects)
			{
				showEffects.length = 0;
			}

			if (hideEffects)
			{
				hideEffects.length = 0;
			}

			if (addedEffects)
			{
				addedEffects.length = 0;
			}
		}

		////////////////////////////////////////////////////////////
		//   EVENT HANDLERS 
		////////////////////////////////////////////////////////////

		protected function onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			playEffects(addedEffects);
		}

		protected function onClick(event:MouseEvent):void
		{
			playEffects(clickEffects);
		}

		////////////////////////////////////////////////////////////
		//   PROTECTED METHODS 
		////////////////////////////////////////////////////////////

		protected function playEffects(effects:Array):void
		{
			if (!effects)
			{
				return;
			}

			var length:int = effects.length;

			for (var i:int = 0; i < length; i++)
			{
				Effect(effects[i]).play(this);
			}
		}

		////////////////////////////////////////////////////////////
		//   GETTERS / SETTERS 
		////////////////////////////////////////////////////////////

		public override function set mask(value:DisplayObject):void
		{
			if (_mask && contains(_mask))
			{
				removeChild(_mask);
			}

			_mask = value;

			if (!_mask.stage)
			{
				addChild(_mask);
			}

			super.mask = _mask;
		}

		public override function set visible(value:Boolean):void
		{
			if (value == super.visible)
			{
				return;
			}

			var effects:Array = value ? showEffects : hideEffects;
			playEffects(effects);

			super.visible = value;
		}
	}
}
