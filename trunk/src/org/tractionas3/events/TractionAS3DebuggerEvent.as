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
	import flash.events.Event;

	/**
	 * TractionAS3DebuggerEvent provides a base event for TractionAS3Debugger class.
	 */
	
	public class TractionAS3DebuggerEvent extends Event 
	{	
		/**
		 * Defines the value of the type property of a tractionAS3DebuggerConnect event object.
		 */
		
		public static const CONNECT:String = "tractionAS3DebuggerConnect";
		
		/**
		 * Defines the value of the type property of a tractionAS3DebuggerDisconnect event object.
		 */
		
		public static const DISCONNECT:String = "tractionAS3DebuggerDisconnect";
		
		/**
		 * Creates a new TractionAS3DebuggerEvent object.
		 */
		
		public function TractionAS3DebuggerEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
		
		/**
		 * @inheritDoc
		 */
		
		override public function clone():Event
		{
			return new TractionAS3DebuggerEvent(type, bubbles, cancelable);
		}
	}
}
