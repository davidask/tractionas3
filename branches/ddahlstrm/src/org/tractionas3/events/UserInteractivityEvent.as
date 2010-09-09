/**
 * @version 1.0
 * @author David A
 * 
 * 
 * Copyright (c) 2009 David A
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
{	import flash.events.Event;

	/**
	 * UserInteractivityEvent provides a base event for UserActivityManager class.
	 */
	public class UserInteractivityEvent extends Event 
	{
		/**
		 * Defines the value of the type property of a userIdle event object.
		 */
		public static const USER_IDLE:String = "userIdle";

		/**
		 * Defines the value of the type property of a userActive event object.
		 */
		public static const USER_PRESENT:String = "userActive";

		/**
		 * Creates a new UserInteractivityEvent object.
		 */
		public function UserInteractivityEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{			super(type, bubbles, cancelable);		}

		/**
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			return new UserInteractivityEvent(type, bubbles, cancelable);
		}
	}}