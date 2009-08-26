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

package org.tractionas3.managers
{
	import org.tractionas3.core.Destructor;
	import org.tractionas3.core.interfaces.ICloneable;
	import org.tractionas3.core.interfaces.ICoreInterface;
	import org.tractionas3.core.interfaces.IResetable;
	import org.tractionas3.core.interfaces.IRunnable;
	import org.tractionas3.events.UserInteractivityEvent;
	import org.tractionas3.events.WeakEventDispatcher;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	/**
	 * UserInteractivityManager is used to monitor user interactivity.
	 */

	public class UserInteractivityManager extends WeakEventDispatcher implements ICoreInterface, IResetable, ICloneable, IRunnable
	{	
		/**
		 * The default timeout of user interactivity.
		 */

		public static var DEFAULT_TIMEOUT:uint = 15;

		public var scope:DisplayObject;

		private var _timeout:uint;

		private var _timeoutID:uint;

		private var _running:Boolean;

		private var _userActive:Boolean = false;		

		
		/**
		 * Creates a new UserInteractivityManager object.
		 * 
		 * @param targetScope Scope in wich the user activity is to be monitored.
		 * @param interactivityTimeout Timeout of user interactivity.
		 */

		public function UserInteractivityManager(targetScope:DisplayObject, interactivityTimeout:Number = NaN):void
		{
			scope = targetScope;
			
			timeout = isNaN(interactivityTimeout) ? DEFAULT_TIMEOUT : interactivityTimeout;
		}

		/**
		 * Specifies the timeout of user interactivity.
		 */

		public function get timeout():uint
		{
			return _timeout;
		}

		public function set timeout(value:uint):void
		{
			_timeout = value * 1000;
			
			if(running) resetTimeout();
		}

		/**
		 * Starts the UserInteractivityManager.
		 */

		public function start():void
		{
			setEventListeners(true);
			
			resetTimeout();
			
			_running = true;
		}

		/**
		 * Stops the UserInteractivityManager.
		 */

		public function stop():void
		{
			_running = false;
		}

		/**
		 * Indicates whether the UserInteractivityManager is running.
		 */

		public function get running():Boolean
		{
			setEventListeners(false);
			return _running;
		}

		/**
		 * @inheritDoc
		 */

		public function reset():void
		{
			scope = null;
			
			timeout = 0;
			
			setEventListeners(false);
		}

		/**
		 * @inheritDoc
		 */

		public function clone():Object
		{
			return new UserInteractivityManager(scope, timeout);
		}

		/**
		 * @inheritDoc
		 */

		override public function destruct(deepDestruct:Boolean = false):void
		{
			setEventListeners(false);
			
			scope = null;
			
			_timeout = 0;
			
			_timeoutID = 0;
			
			_running = false;
			
			_userActive = false;
			
			Destructor.destruct(this, deepDestruct);
		}

		private function setEventListeners(add:Boolean):void
		{
			var method:String = add ? "addEventListener" : "removeEventListener";
			
			scope[method](MouseEvent.MOUSE_MOVE, handleEvents);
			
			scope[method](KeyboardEvent.KEY_DOWN, handleEvents);
		}

		private function handleEvents(e:Event):void
		{
			switch(e.type)
			{
				case MouseEvent.MOUSE_MOVE:
					userIsActive();
					break;
				
				case KeyboardEvent.KEY_DOWN:
					userIsActive();
					break;
			}
		}

		private function userIsActive():void
		{
			if(!_userActive) dispatchEvent(new UserInteractivityEvent(UserInteractivityEvent.USER_PRESENT));
						
			resetTimeout();
			
			_userActive = true;
		}

		private function userIsIdle():void
		{
			if(_userActive) dispatchEvent(new UserInteractivityEvent(UserInteractivityEvent.USER_IDLE));
			
			_userActive = false;
		}

		private function resetTimeout():void
		{
			if(_timeoutID) clearTimeout(_timeoutID);
			
			_timeoutID = setTimeout(userIsIdle, timeout);
		}
	}
}