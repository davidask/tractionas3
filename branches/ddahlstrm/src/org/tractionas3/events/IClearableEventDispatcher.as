package org.tractionas3.events 
{
	import flash.events.IEventDispatcher;
	public interface IClearableEventDispatcher extends IEventDispatcher 
	{
		
		/**
		 * Removes all event listeners from the IClearableEventDispatcher object.
		 */
		
		function removeAllEventListeners():void;
	}
}
