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
{
	import flash.events.Event;

	/**
	 * LocalConnectionDataEvent provides a base event for LocalConnectionInbound and LocalConnectionOutbound classes.
	 */
	public class LocalConnectionDataEvent extends Event 
	{	
		/**
		 * Defines the value of the type property of a localConnectionDataReceive event object.
		 */
		public static const DATA_RECEIVE:String = "localConnectionDataReceive";

		/**
		 * Defines the value of the type property of a localConnectionDataSend event object.
		 */
		public static const DATA_SEND:String = "localConnectionDataSend";

		/**
		 * Indicates the data sent/received by the LocalConnectionInbound/LocalConnectionOutbound class.
		 */
		public var data:*;

		/**
		 * Creates a new LocalConnectionDataEvent object,.
		 */
		public function LocalConnectionDataEvent(type:String, localConnectionData:*, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			
			data = localConnectionData;
		}

		/**
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			return new LocalConnectionDataEvent(type, data, bubbles, cancelable);
		}
	}
}
