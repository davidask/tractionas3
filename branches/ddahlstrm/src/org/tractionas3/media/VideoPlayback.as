/** * @version 1.0 * @author David Dahlstroem | daviddahlstroem.com *  *  * Copyright (c) 2009 David Dahlstroem | daviddahlstroem.com *  * Permission is hereby granted, free of charge, to any person obtaining a copy * of this software and associated documentation files (the "Software"), to deal * in the Software without restriction, including without limitation the rights * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell * copies of the Software, and to permit persons to whom the Software is * furnished to do so, subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in * all copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN * THE SOFTWARE. * */package org.tractionas3.media {	import org.tractionas3.core.Destructor;	import org.tractionas3.core.interfaces.ICoreInterface;	import org.tractionas3.events.LoaderEvent;	import org.tractionas3.load.VideoLoader;	import org.tractionas3.media.IMediaPlayback;	import org.tractionas3.reflection.stringify;	import flash.media.SoundTransform;	import flash.media.Video;	import flash.net.NetStream;	/**	 * VideoPlayback provides an API coupled with VideoLoader class and is used for playing back video.	 *	 * @see org.tractionas3.load.VideoLoader	 */	 	/*	 * TODO Extend functionality of VideoPlayback class	 * TODO There's an issue with F4V files not displaying and FLV files displaying after a delay.	 */	public class VideoPlayback extends Video implements IMediaPlayback, ICoreInterface	{		private var _loader:VideoLoader;		private var _netStream:NetStream;		private var _playing:Boolean;		private var _soundTransform:SoundTransform;		private var _autoSizeOnMetaData:Boolean;				/**		 * Creates a new VideoPlayback object.		 * 		 * When creating a VideoPlayback you must assign it a VideoLoader. The VideoLoader and VideoPlayback instance will both have a connection to the		 * required NetStream object. You may change the NetStream propeties, e.g. bufferTime, both via VideoLoader and VideoPlayback.		 * 		 * @param loader VideoLoader providing the video data to be played.		 * @param width Video width.		 * @param height Video height.		 */		public function VideoPlayback(loader:VideoLoader, width:int = 320, height:int = 240)		{			super(width, height);						_loader = loader;						_netStream = _loader.netStream;						attachNetStream(_netStream);						_playing = false;						_soundTransform = new SoundTransform();						_autoSizeOnMetaData = false;		}		/**		 * Returns the VideoLoader instance coupled with the VideoPlayback instance.		 */		public function get loader():VideoLoader		{			return _loader;		}		/**		 * Instructs the VideoPlayback to autosize according to the retrieved meta data.		 * If meta data has not yet been loaded, the video will be resized when meta data loading is complete.		 * Setting the width or height property after calling <code>autoSize()</code> will disable autosizing.		 */		public function autoSize():void		{			if(loader.hasMetaData)			{				width = loader.metaData.width;								height = loader.metaData.height;			}			else			{				_autoSizeOnMetaData = true;								loader.addEventListener(LoaderEvent.META_DATA, onMetaDataRecieve);			}		}		override public function set width(value:Number):void		{			_autoSizeOnMetaData = false;						loader.removeEventListener(LoaderEvent.META_DATA, onMetaDataRecieve);						super.width = value;		}		override public function set height(value:Number):void		{			_autoSizeOnMetaData = false;						loader.removeEventListener(LoaderEvent.META_DATA, onMetaDataRecieve);						super.height = value;		}		/**		 * Returns the buffer length of the video playback.		 */		public function get bufferLength():Number		{			return _netStream.bufferLength;		}		/**		 * Defines the buffer time of the video playback.		 */		public function get bufferTime():Number		{			return _netStream.bufferTime;		}		public function set bufferTime(value:Number):void		{			_netStream.bufferTime = value;		}		/**		 * Indicates the duration of the vide playback. If metadata isn't yet loaded a qualified guess of the duration will be returned.		 */		public function get duration():Number		{			return loader.metaData.duration || (loader.bytesTotal / (loader.bytesLoaded / bufferLength));		}		/**		 * Indicates the position of the playhead, in seconds.		 */		public function get time():Number		{			return _netStream.time;		}		/**		 * Defines the audio volume of the video playback.		 */		public function get volume():Number		{			return _soundTransform.volume;		}		public function set volume(value:Number):void		{			_soundTransform.volume = value;						_netStream.soundTransform = _soundTransform;		}		/**		 * Defines the audio pan of the video playback.		 */		public function get pan():Number		{			return _soundTransform.pan;		}		public function set pan(value:Number):void		{			_soundTransform.pan = value;						_netStream.soundTransform = _soundTransform;		}		/**		 * Starts video playback.		 */		public function play():void		{			_netStream.resume();		}		/**		 * Starts video playback at specified position.		 */		public function playAt(position:Number):void		{			_netStream.seek(position);			_netStream.resume();		}		/**		 * Pauses video playback.		 */		public function pause():void		{			_netStream.pause();		}		/**		 * Stops video playback.		 */		public function stop():void		{			pause();			seek(0);		}		/**		 * Moves the playhead to specified position.		 */		public function seek(position:Number):void		{			_netStream.seek(position);		}		/**		 * Destructs of the VideoPlayback instance.		 */		public function destruct(deepDestruct:Boolean = false):void		{			loader.removeEventListener(LoaderEvent.META_DATA, onMetaDataRecieve);						_loader = null;						_playing = false;						_soundTransform = null;						Destructor.destruct(this, deepDestruct);		}		/**		 * @inheritDoc		 */		public function listDestructableProperties():Array		{			return [];		}		/**		 * @inheritDoc		 */		override public function toString():String		{			return stringify(this);		}		private function onMetaDataRecieve(e:LoaderEvent):void		{			loader.removeEventListener(LoaderEvent.META_DATA, onMetaDataRecieve);						if(_autoSizeOnMetaData)			{				width = loader.metaData.width;								height = loader.metaData.height;								_autoSizeOnMetaData = false;			}		}	}}