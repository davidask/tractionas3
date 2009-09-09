package org.tractionas3.events 
{
	import flash.events.IEventDispatcher;
	public interface IEnhancedEventDispatcher extends IEventDispatcher 
	{

		function removeAllEventListeners():void;
	}
}
