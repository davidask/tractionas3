package org.tractionas3.media 
{
	import org.tractionas3.utils.MathUtil;
	import org.tractionas3.core.interfaces.IRunnable;
	import org.tractionas3.events.EnterFrame;
	import org.tractionas3.events.WeakEventDispatcher;

	import flash.media.SoundMixer;
	import flash.utils.ByteArray;
	public class SoundLevelResponder2 extends WeakEventDispatcher implements IRunnable 
	{

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

		public function getLeftChannelBars(numberOfBars:uint):Array
		{
			return getChannelbars(leftChannelValues, numberOfBars);
		}
		
		public function getRightChannelbars(numberOfBars:uint):Array
		{
			return getChannelbars(rightChannelValues, numberOfBars);
		}
		
		public function getStereoBars(numberOfBars:uint):Array
		{
			var lc:Array = getChannelbars(leftChannelValues, numberOfBars);
			
			var rc:Array = getChannelbars(rightChannelValues, numberOfBars);
			
			var a:Array = [];
			
			var v:Number;
			
			for(var i:int = 0; i < lc.length; ++i)
			{
				v = lc[i] as Number;
				
				v += rc[i] as Number;
				
				v /= 2;
				
				a.push(v);
			}
			
			return a;
		}

		public function update():void
		{
			_byteArray = new ByteArray();
			
			SoundMixer.computeSpectrum(_byteArray, true, 0);
			
			_leftChannelValues = [];
			
			_rightChannelValues = [];
			
			var i:int = 0;
			
			var lv:Number;
			
			var rv:Number;
			
			while(i < 1024)
			{
				_byteArray.position = i;
				
				lv = _byteArray.readUnsignedByte() / 255;
				
				_leftChannelValues.push(lv);
				
				_byteArray.position += 1024;
				
				rv = _byteArray.readUnsignedByte() / 255;
				
				_rightChannelValues.push(rv);
				
				i += 4;
			}
		}

		private function getChannelbars(channel:Array, numberOfBars:uint):Array
		{
			var values:Array = [];
			
			numberOfBars = Math.max(numberOfBars, 1);
			
			numberOfBars += MathUtil.isEven(numberOfBars) ? 0 : 1;
			
			var v:Number = 0;
			
			var l:uint = (channel.length / numberOfBars);
			
			for(var i:int = 0;i < channel.length; ++i)
			{
				v += (channel[i] as Number);
				
				if(i % l == 0)
				{
					values.push(v / l);
					
					v = 0;
				}
			}
			
			return values;
		}
	}
}
