package org.tractionas3.events 
{
	import org.tractionas3.core.Destructor;
	import org.tractionas3.core.interfaces.ICoreInterface;
	import org.tractionas3.events.IClearableEventDispatcher;
	import org.tractionas3.reflection.stringify;

	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**
	 * ClearableEventDispatcher keeps track of what events have been added, giving the posibility to remove all added event listeners via
	 * <i>removeEventListeners()</i> method defined in IClearableEventDispatcher interface.
	 */
	public class ClearableEventDispatcher extends EventDispatcher implements IClearableEventDispatcher, ICoreInterface
	{

		private var _eventReferences:Array;

		
		/**
		 * Creates a new ClearableEventDispatcher object.
		 */
		
		public function ClearableEventDispatcher(target:IEventDispatcher = null)
		{
			super(target || this);
			
			_eventReferences = [];
		}

		/**
		 * Registers an event listener object with an EventDispatcher object so that the listener receives notification of an event.
		 */
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
			
			_eventReferences.push(new EventReference(type, listener, useCapture));
		}

		/**
		 * Removes a listener from the EventDispatcher object. If there is no matching listener registered with the EventDispatcher object, a call to this method has no effect.
		 */
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{	
			removeEventReference(type, listener, useCapture);
			
			super.removeEventListener(type, listener, useCapture);
		}
		
		/**
		 * @inheritDoc
		 */
		
		public function removeAllEventListeners():void
		{
			var eventReference:EventReference;
			
			for(var i:int = 0;i < _eventReferences.length; ++i)
			{
				eventReference = _eventReferences[i] as EventReference;
				
				super.removeEventListener(eventReference.type, eventReference.listener, eventReference.useCapture);
	
				eventReference.destruct();
				
				eventReference = null;
			}
			
			_eventReferences = [];
		}

		/**
		 * @inheritDoc
		 */
		public function destruct(deepDestruct:Boolean = false):void
		{
			Destructor.destruct(this, deepDestruct);
			
			removeAllEventListeners();
		}

		/**
		 * @inheritDoc
		 */
		public function listDestructableProperties():Array
		{
			return [];
		}

		/**
		 * Returns the string representation of the specified object.
		 */
		override public function toString():String
		{
			return stringify(this);
		}

		private function removeEventReference(type:String, listener:Function, useCapture:Boolean):void
		{
			var eventReference:EventReference;
			
			for(var i:int = 0;i < _eventReferences.length; ++i)
			{
				eventReference = _eventReferences[i] as EventReference;
				
				if(eventReference.type === type && eventReference.listener === listener && eventReference.useCapture === useCapture)
				{
					_eventReferences.splice(i, 1);
					
					eventReference.destruct();
					
					removeEventReference(type, listener, useCapture);
					
					return;
				}
			}
		}
	}
}
