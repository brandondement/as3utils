package bdement.loading.loaditems
{

	import bdement.collections.priorityqueue.IPrioritizable;
	import flash.events.IEventDispatcher;

	public interface ILoadItem extends IEventDispatcher, IPrioritizable
	{
		function cancel():void;
		function load():void;

		function get asset():Object;
		function set asset(asset:Object):void;

		function get progress():Number;

		function get url():String;
		function set url(url:String):void;
	}
}
