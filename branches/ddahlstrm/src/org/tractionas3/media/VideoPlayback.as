/**
 * @version 1.0
 * @author David Dahlstroem | daviddahlstroem.com
 * 
 * 
 * Copyright (c) 2010 David Dahlstroem | daviddahlstroem.com
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
	import org.tractionas3.display.CoreSprite;
	import org.tractionas3.events.VideoStreamEvent;
	import org.tractionas3.media.IMediaPlayback;
	import org.tractionas3.net.VideoStream;

	import flash.media.Video;
	public class VideoPlayback extends CoreSprite implements IMediaPlayback 
	{
		private var _stream:VideoStream;
		
		private var _video:Video;
		
		public function VideoPlayback(stream:VideoStream, videoWidth:Number = 640, videoHeight:Number = 360)
		{
			_stream = stream;
			
			updateVideo(videoWidth, videoHeight);
			
			super();
		}
		
		public function get videoWidth():Number
		{
			return _video.width;
		}
		
		public function set videoWidth(value:Number):void
		{
			updateVideo(value, videoHeight);
		}
		
		public function get videoHeight():Number
		{
			return _video.height;
		}
		
		public function set videoHeight(value:Number):void
		{
			updateVideo(videoWidth, value);
		}
		
		
		public function play():void
		{
			_stream.play();
		}
		
		public function autoSize():void
		{
			if(_stream.actualSize)
			{
				updateVideo(_stream.actualSize.width, _stream.actualSize.height);
			}
			else
			{
				_stream.addEventListener(VideoStreamEvent.SIZE_RECEIVED, handleVideoStreamEvent);
			}
		}
		
		public function playAt(position:Number):void
		{
			_stream.playAt(position);
		}
		
		public function pause():void
		{
			_stream.pause();
		}
		
		public function stop():void
		{
			_stream.stop();
		}
		
		public function seek(position:Number):void
		{
			_stream.seek(position);
		}
		
		public function get playing():Boolean
		{
			return _stream.playing;
		}
		
		public function reAssignVideoStream():void
		{
			_video.attachNetStream(_stream);
		}

		override public function destruct(deepDestruct:Boolean = false):void
		{
			removeChild(_video);
			
			_video = null;
			
			_stream.removeEventListener(VideoStreamEvent.SIZE_RECEIVED, handleVideoStreamEvent);
			
			_stream = null;
			
			super.destruct(deepDestruct);
		}

		private function updateVideo(videoWidth:Number, videoHeight:Number):void
		{
			if(_video)
			{
				_video.clear();
			}
			else
			{
				_video = addChild(new Video(videoWidth, videoHeight)) as Video;
				
				_video.attachNetStream(_stream);
			}
			
			_video.width = videoWidth;
			
			_video.height = videoHeight;
			
			_video.smoothing = _video.scaleX + _video.scaleY != 2;
		}

		private function handleVideoStreamEvent(e:VideoStreamEvent):void
		{
			switch(e.type)
			{
				case VideoStreamEvent.SIZE_RECEIVED:
					
					_stream.removeEventListener(VideoStreamEvent.SIZE_RECEIVED, handleVideoStreamEvent);
					
					autoSize();
					
				break;
			}
		}
	}
}
