package bdement.ui.modals
{

	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public final class ModalManager extends EventDispatcher implements IModalManager
	{

		////////////////////////////////////////////////////////////
		//   CONSTANTS 
		////////////////////////////////////////////////////////////

		public static const OVERLAY:String = "OVERLAY";

		public static const SEQUENTIAL:String = "SEQUENTIAL";

		////////////////////////////////////////////////////////////
		//   ATTRIBUTES 
		////////////////////////////////////////////////////////////

		private var _container:DisplayObjectContainer;

		private var _queue:Vector.<Modal>;

		////////////////////////////////////////////////////////////
		//   CONSTRUCTOR 
		////////////////////////////////////////////////////////////

		public function ModalManager()
		{
			constructor();
		}

		private function constructor():void
		{
			_queue = new Vector.<Modal>();
		}

		////////////////////////////////////////////////////////////
		//   PUBLIC API 
		////////////////////////////////////////////////////////////

		public function addModal(modal:Modal, priority:String = "SEQUENTIAL"):void
		{
			modal.setModalManager(this);

			if (priority == OVERLAY)
			{
				// if this is the only modal being shown, be sure to show 
				// the next one in line when it's removed
				if (!isActive)
				{
					modal.addEventListener(Event.REMOVED_FROM_STAGE, onModalRemoved);
				}

				_container.addChild(modal);
				return;
			}

			_queue.push(modal);

			showNextModal();
		}

		public function dispose():void
		{
			var length:int = _queue.length;

			for (var i:int = 0; i < length; i++)
			{
				var modal:Modal = _queue[i];

				if (modal.hasEventListener(Event.REMOVED_FROM_STAGE))
				{
					modal.removeEventListener(Event.REMOVED_FROM_STAGE, onModalRemoved);
				}

				if (_container.contains(modal))
				{
					_container.removeChild(modal);
				}

				modal.dispose();
			}

			_queue = null;
		}

		public function removeModal(modal:Modal):void
		{
			// modals must be disposed before they're removed from the display
			// list so they can remove event listeners from the Stage
			modal.dispose();

			_container.removeChild(modal);
		}

		////////////////////////////////////////////////////////////
		//   EVENT HANDLERS 
		////////////////////////////////////////////////////////////

		private function onModalRemoved(event:Event):void
		{
			var modal:Modal = Modal(event.target);
			modal.removeEventListener(Event.REMOVED_FROM_STAGE, onModalRemoved);
			showNextModal(true);
		}

		////////////////////////////////////////////////////////////
		//   PRIVATE METHODS 
		////////////////////////////////////////////////////////////

		private function showNextModal(force:Boolean = false):void
		{
			// stop here if there's nothing to show or  
			// there's already a modal showing
			if (_queue.length == 0 || isActive && !force)
			{
				return;
			}

			var modal:Modal = _queue.shift();
			modal.addEventListener(Event.REMOVED_FROM_STAGE, onModalRemoved);
			_container.addChild(modal);
		}

		////////////////////////////////////////////////////////////
		//   GETTERS / SETTERS 
		////////////////////////////////////////////////////////////

		public function get container():DisplayObjectContainer
		{
			return _container;
		}

		public function set container(value:DisplayObjectContainer):void
		{
			_container = value;
		}

		public function get isActive():Boolean
		{
			return _container.numChildren > 0;
		}
	}
}
