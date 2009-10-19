package org.tractionas3.media 
{
	import org.tractionas3.core.interfaces.IRunnable;
	import org.tractionas3.events.EnterFrame;
	import org.tractionas3.events.WeakEventDispatcher;

	import flash.media.SoundMixer;
	import flash.utils.ByteArray;
	public class SoundLevelResponder2 extends WeakEventDispatcher implements IRunnable 
	{
		
		public var freqWidth:uint = 16;
		
		private var _byteArray:ByteArray;
		
		private var _leftChannelValues:Array;
		
		private var _rightChannelValues:Array;
		
		public function SoundLevelResponder2()
		{
			super();
		}
		
		public function start():void
		{
			EnterFrame.addEnterFrameHandler(update);
		}
		
		public function stop():void
		{
			EnterFrame.removeEnterFrameHandler(update);
		}
		
		public function get running():Boolean
		{
			return EnterFrame.hasEnterFrameHandler(update);
		}
		
		public function get leftChannelValues():Array
		{
			return _leftChannelValues || [];
		}
		
		public function get rightChannelValues():Array
		{
			return _rightChannelValues || [];
		}

		public function update():void
		{
			_byteArray = new ByteArray();
			
			SoundMixer.computeSpectrum(_byteArray, true, 0);
			
			_leftChannelValues = [];
			
			_rightChannelValues = [];
			
			var i:int;
			
			var value:Number;
			
			/*
			 * Calculate left channel values
			 */
			
			value = 0;
			
			for(i = 0; i < 256; ++i)
			{
				value += _byteArray.readFloat();
				
				if(i % freqWidth == 0)
				{
					_leftChannelValues.push(value);
					
					value = 0;
				}
			}
			
			/*
			 * Calculate right channel values
			 */
			
			value = 0;
			
			for(i = 0; i < 256; ++i)
			{
				value += _byteArray.readFloat();
				
				if(i % freqWidth == 0)
				{
					_rightChannelValues.push(value);
					
					value = 0;
				}
			}
			
		}
	}
}
