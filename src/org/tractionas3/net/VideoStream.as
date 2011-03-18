/**
 * @version 1.0
 * @author David A
 * 
 * 
 * Copyright (c) 2010 David A
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
 
package org.tractionas3.net 
{
	import org.tractionas3.core.interfaces.ICoreInterface;
	import org.tractionas3.events.EnterFrame;
	import org.tractionas3.events.VideoStreamEvent;
	import org.tractionas3.geom.Dimension;

	import flash.media.SoundTransform;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.getQualifiedClassName;

	/**
	 * VideoStream extends the functinality of NetStream
	 */
	public class VideoStream extends NetStream implements ICoreInterface
	{
		private var _metaData:VideoStreamMetaData;

		private var _playing:Boolean = false;

		private var _ready:Boolean;

		private var _soundTransform:SoundTransform;

		private var _actualSize:Dimension;

		/**
		 * Creates a new VideoStream object
		 */
		public function VideoStream()
		{
			var netConnection:NetConnection = new NetConnection();
			
			netConnection.connect(null);
			
			super(netConnection);
			
			super.client = this;
			
			_soundTransform = new SoundTransform();
		}

		/**
		 * @inheritDoc
		 */
		override public function set client(object:Object):void
		{
			throw new Error("Property client cannot be changed on ExtendedNetStream.");
		}

		/**
		 * @private
		 */
		public function onMetaData(data:Object):void
		{
			_metaData = new VideoStreamMetaData();
			
			for(var property:String in data)
			{
				if(!_metaData.hasOwnProperty(property)) trace("Property " + property + "(" + getQualifiedClassName(data[property]) + ") is not defined in VideoMetaData. Adding dynamic property.");
				
				_metaData[property] = data[property];
			}
			
			if(_metaData.width > 0 && metaData.height > 0 && !_actualSize)
			{	
				_actualSize = new Dimension(metaData.width, metaData.height);
				
				dispatchEvent(new VideoStreamEvent(VideoStreamEvent.SIZE_RECEIVED));
			}
			
			dispatchEvent(new VideoStreamEvent(VideoStreamEvent.META_DATA_RECEIVED));
		}

		/**
		 * Indicates the actual size of the VideoStream.
		 */
		public function get actualSize():Dimension
		{
			return _actualSize;
		}

		/**
		 * Indicates whether the VideoStream is currently playing.
		 */
		public function get playing():Boolean
		{
			return _playing;
		}

		/**
		 * Seeks the VideoStream and plays it at specified time.
		 */
		public function playAt(position:Number):void
		{
			seek(position);
			play();
		}

		/**
		 * @inheritDoc
		 */
		override public function resume():void
		{
			super.resume();
			
			_playing = true;
			
			dispatchEvent(new VideoStreamEvent(VideoStreamEvent.PLAY));
		}

		/**
		 * @inheritDoc
		 */
		override public function pause():void
		{
			super.pause();
			
			_playing = false;
			
			dispatchEvent(new VideoStreamEvent(VideoStreamEvent.PAUSE));
		}

		/**
		 * @inheritDoc
		 */
		override public function togglePause():void
		{
			if(_playing)
			{
				pause();
			}
			else
			{
				resume();
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function play(...args:*):void
		{
			super.resume();
			
			_playing = true;
			
			dispatchEvent(new VideoStreamEvent(VideoStreamEvent.PLAY));
		}

		/**
		 * @inheritDoc
		 */
		public function stop():void
		{
			pause();
			seek(0);
			
			dispatchEvent(new VideoStreamEvent(VideoStreamEvent.STOP));
		}

		/**
		 * Defines the volume of the VideoStream object.
		 */
		public function get volume():Number
		{
			return _soundTransform.volume;
		}

		public function set volume(value:Number):void
		{
			_soundTransform.volume = value;
			
			soundTransform = _soundTransform;
		}

		/**
		 * Defines the pan of the VideoStream object.
		 */
		public function get pan():Number
		{
			return _soundTransform.pan;
		}

		public function set pan(value:Number):void
		{
			_soundTransform.pan = value;
			
			soundTransform = _soundTransform;
		}

		/**
		 * @inheritDoc
		 */
		override public function get soundTransform():SoundTransform
		{
			return _soundTransform;
		}

		override public function set soundTransform(sndTransform:SoundTransform):void
		{
			super.soundTransform = sndTransform;
		}

		/**
		 * Specifies whether the VideoStream object is ready for playback.
		 */
		public function get streamReady():Boolean
		{
			return _ready;
		}

		public function load(streamUrl:String):void
		{
			EnterFrame.removeEnterFrameHandler(resolveReadyState);
			
			_actualSize = null;
			
			_ready = false;
			
			super.play(streamUrl);
			super.pause();
			seek(0);
			
			EnterFrame.addEnterFrameHandler(resolveReadyState);
		}

		/**
		 * Returns the metadata of the VideoStream object, if the meta data has been received.
		 */
		public function get metaData():VideoStreamMetaData
		{
			return _metaData;
		}

		/**
		 * @private
		 */
		public function onXMPData(data:Object):void
		{
		}

		/**
		 * @private
		 */
		public function onPlayStatus(data:Object):void
		{
		}

		/**
		 * @private
		 */
		public function onImageData(data:Object):void
		{
		}

		/**
		 * @private
		 */
		public function onCuePoint(data:Object):void
		{
		}

		/**
		 * @inheritDoc
		 */
		public function destruct(deepDestruct:Boolean = false):void
		{
			if(_metaData) _metaData.destruct(deepDestruct);
		}

		/**
		 * @inheritDoc
		 */
		public function listDestructableProperties():Array
		{
			return [];
		}

		private function resolveReadyState():void
		{
			if(bytesLoaded > 0 && bytesTotal > 0 && _actualSize)
			{
				_ready = true;
				
				if(_metaData.framerate)
				{
					seek(1 / metaData.framerate);
				}
				
				dispatchEvent(new VideoStreamEvent(VideoStreamEvent.READY));
				
				EnterFrame.removeEnterFrameHandler(resolveReadyState);
			}
		}
	}
}
