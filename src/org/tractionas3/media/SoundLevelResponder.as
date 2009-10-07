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

package org.tractionas3.media 
{
	import org.tractionas3.core.interfaces.IRunnable;
	import org.tractionas3.events.EnterFrame;
	import org.tractionas3.events.SoundLevelResponderEvent;
	import org.tractionas3.events.WeakEventDispatcher;

	import flash.media.SoundMixer;
	import flash.utils.ByteArray;
	/**
	 * SoundLevelResponder uses the <i>SoundMixer.computeSoundSpectrum()</i> method to allow for a response to specified sound level.
	 */
	
	public class SoundLevelResponder extends WeakEventDispatcher implements IRunnable 
	{
		public static var CHANNEL_LENGTH:uint = 512;
		
		/**
		 * Specifies the number of sample loops for the sound level reference.
		 */
		
		public var sampleLoops:uint;
		
		/**
		 * Specifies the threshold at which the SoundLevelResponder is responding.
		 */
		
		public var threshold:Number;
		
		private var _sampleLoopCounter:int;
		
		private var _tot:Number;
		
		private var _currentSoundLevel:Number;
		
		/**
		 * Creates a new SoundLevelResponder object.
		 */
		
		public function SoundLevelResponder()
		{
			super(this);
			
			sampleLoops = 10;
			
			threshold = 0.3;
			
			_tot = 0;
			
			_currentSoundLevel = 0;
		}
		
		/**
		 * Starts the SoundLevelResponder
		 */
		
		public function start():void
		{
			if(!EnterFrame.hasEnterFrameHandler(analyze)) EnterFrame.addEnterFrameHandler(analyze);
		}
		
		/**
		 * Stops the SoundLevelResponder
		 */
		
		public function stop():void
		{
			EnterFrame.removeEnterFrameHandler(analyze);
			
			_currentSoundLevel = 0;
		}
		
		/**
		 * Indicates whether the SoundLevelResponder is running.
		 */
		
		public function get running():Boolean
		{
			return EnterFrame.hasEnterFrameHandler(analyze);
		}
		
		/**
		 * Indicates the current sound level.
		 */
		
		public function get currentSoundLevel():Number
		{
			return _currentSoundLevel;
		}

		private function analyze():void
		{
			var byteArray:ByteArray = new ByteArray();
			
			SoundMixer.computeSpectrum(byteArray, false, 0);
			
			var floatVal:Number;
			
			_currentSoundLevel = 0;
			
			for(var i:int = 0; i < CHANNEL_LENGTH; ++i)
			{
				floatVal = byteArray.readFloat();
				
				_currentSoundLevel += (floatVal < 0) ? -floatVal : floatVal;
			}
			
			_currentSoundLevel /= CHANNEL_LENGTH;

			
			var avg:Number = _tot / _sampleLoopCounter;
			
			if(_currentSoundLevel && avg && _currentSoundLevel > threshold)
			{
				dispatchEvent(new SoundLevelResponderEvent(SoundLevelResponderEvent.RESPOND, _currentSoundLevel));
			}
			
			if(_sampleLoopCounter > sampleLoops)
			{
				_sampleLoopCounter = 0;
				
				_tot = 0;
			}
			
			_tot += _currentSoundLevel;
			
			_sampleLoopCounter++;
		}
	}
}
