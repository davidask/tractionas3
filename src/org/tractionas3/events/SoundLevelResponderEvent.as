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
	 * SoundLevelResponderEvent provides a base event for SoundLevelResponder class.
	 */

	public class SoundLevelResponderEvent extends Event 
	{
		/**
		 * Defines the value of the type property of a soundLevelResponderResponse event object.
		 */
		
		public static const RESPOND:String = "soundLevelResponderResponse";
		
		private var _soundLevel:Number;
		
		/**
		 * Creates a new SoundLevelResponderEvent object.
		 */
		
		public function SoundLevelResponderEvent(type:String, soundLevel:Number, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			
			_soundLevel = soundLevel;
		}
		
		/**
		 * Indicates the sound level from the SoundLevelResponder object.
		 */
		
		public function get soundLevel():Number
		{
			return _soundLevel;
		}
		
		/**
		 * @inheritDoc
		 */
		
		override public function clone():Event
		{
			return new SoundLevelResponderEvent(type, soundLevel, bubbles, cancelable);
		}
	}
}
