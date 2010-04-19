/**
 * @version 1.0
 * @author David Dahlstroem | daviddahlstroem.com
 * 
 * 
 * Copyright (c) 2009 David Dahlstroem | daviddahlstroem.com
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

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
			
			for(var i:int = 0;i < _eventReferences.length;++i)
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
		public function removeEventListenersOfType(type:String):void
		{
			var eventReference:EventReference;
			
			for(var i:int = 0;i < _eventReferences.length;++i)
			{
				eventReference = _eventReferences[i] as EventReference;
				
				if(eventReference.type == type)
				{
					_eventReferences.splice(i, 1);
					
					super.removeEventListener(eventReference.type, eventReference.listener, eventReference.useCapture);
					
					eventReference.destruct();
				}
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get numEventListeners():uint
		{
			return _eventReferences.length;
		}

		/**
		 * @inheritDoc
		 */
		public function destruct(deepDestruct:Boolean = false):void
		{
			removeAllEventListeners();
			
			Destructor.destruct(this, deepDestruct);
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

		/**
		 * @private
		 */
		protected function removeEventReference(type:String, listener:Function, useCapture:Boolean):void
		{
			var eventReference:EventReference;
			
			for(var i:int = 0;i < _eventReferences.length;++i)
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
