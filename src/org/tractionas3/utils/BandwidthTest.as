/** * @version 1.0 * @author David Dahlstroem | daviddahlstroem.com *  *  * Copyright (c) 2009 David Dahlstroem | daviddahlstroem.com *  * Permission is hereby granted, free of charge, to any person obtaining a copy * of this software and associated documentation files (the "Software"), to deal * in the Software without restriction, including without limitation the rights * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell * copies of the Software, and to permit persons to whom the Software is * furnished to do so, subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in * all copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN * THE SOFTWARE. * */package org.tractionas3.utils {	import org.tractionas3.core.interfaces.ICloneable;	import org.tractionas3.core.interfaces.ICoreInterface;	import org.tractionas3.core.interfaces.IResetable;	import org.tractionas3.core.interfaces.IRunnable;	import org.tractionas3.debug.LogLevel;	import org.tractionas3.debug.log;	import org.tractionas3.events.BandwidthTestEvent;	import org.tractionas3.events.WeakEventDispatcher;	import flash.events.Event;	import flash.events.IOErrorEvent;	import flash.events.ProgressEvent;	import flash.net.URLLoader;	import flash.net.URLRequest;	import flash.utils.clearTimeout;	import flash.utils.getTimer;	import flash.utils.setTimeout;	/**	 * Using a reference file, BandwidthTest records connection speed and latency between the client and server.	 */	public class BandwidthTest extends WeakEventDispatcher implements ICoreInterface, IResetable, ICloneable, IRunnable 	{		/**		 * Bytes per second threshold to determine the score of the clients bandwith and connection.		 * 		 * @see #score		 */		public var threshold:Number;		private var _latency:Number;		private var _loader:URLLoader;		private var _loadStartTime:uint;		private var _urlRq:URLRequest;		private var _latencyTestStartTime:uint;		private var _timeout:uint;		private var _timeoutID:uint;		private var _result:Number;		private var _running:Boolean;				/**		 * BandwidthTest constructor.		 * 		 * @param referenceFile A URLRequest to a reference file.		 * This file may be of any file type but should be large enough so that loading		 * it fully takes longer than your specified timeout.		 * 		 * When timeout is reached any loading will be cancelled and the test will dispatch event indicating that it has been completed.		 * 		 * @param timeout Test timeout in milliseconds.		 * When timeout is reached the loading of the reference file is cancelled and bandwidth is measured based on the elapsed time.		 * 		 * @param bandwidthThreshold The threshold of the bandwidth in bytes per second. On test completion the threshold is compared with the test result and the score is being calculated.		 * 		 * @see #score		 * @see #threshold		 * 		 * @see org.tractionas3.events.BandwidthTestEvent#COMPLETE		 * @see org.tractionas3.events.BandwidthTestEvent#PROGRESS		 */		public function BandwidthTest(referenceFile:URLRequest, timeout:uint, bandwidthThreshold:Number = NaN)		{			super();						_urlRq = referenceFile;						_timeout = timeout;						threshold = bandwidthThreshold;						reset();		}		/**		 * Indicates the URL of the test reference file.		 */		public function get referenceFileURL():String		{			return _urlRq.url;		}		/**		 * Indicates the progress of the bandwith test.		 * If loading is likely to finish before timeout is reached the progress		 * is measured by how many bytes are loaded in relation to how many bytes total of the reference file.		 * Otherwise the progress simply indicates the elapsed time in relation to the timeout.		 */		public function get progress():Number		{			return Math.min(Math.max(Math.min(elapsedTime / timeout, 1), _loader.bytesLoaded / _loader.bytesTotal), 1);		}		/**		 * Indicates, in milliseconds, for how long the test has been running.		 */		public function get elapsedTime():uint		{			return getTimer() - _loadStartTime;		}		/**		 * Determines the score of the band width test based on the specified threshold.		 * A score of 1.0 or higher indicates that the bandwidth has exceeded the specified threshold.		 * 		 * @see #threshold		 */		public function get score():Number		{			return bytesPerSecond / threshold;		}		/**		 * Cancels test loading and destructs the test.		 */		override public function destruct(deepDestruct:Boolean = false):void		{			clearTimeout(_timeoutID);						try			{				_loader.close();			}			catch(e:Error) 			{			}						setEventListeners(false);						threshold = NaN;						_latency = NaN;						_loader = null;						_loadStartTime = 0;						_urlRq = null;						_latencyTestStartTime = 0;						_timeout = 0;						_timeoutID = 0;						_result = NaN;						_running = false;						super.destruct(deepDestruct);		}		/**		 * Resets the test and cancels any current loading.		 */		public function reset():void		{			if(_loader)			{				try				{					_loader.close();				}				catch(e:Error) 				{				};								setEventListeners(false);			}						_loader = new URLLoader();						_latency = NaN;						setEventListeners(true);		}		/**		 * Indicates the result of the speed test in number of bytes per second.		 * This property is only accessible after the test is complete.		 */		public function get bytesPerSecond():Number		{			return _result;		}		/**		 * Indicates, in milliseconds, the timeout of the test.		 */		public function get timeout():uint		{			return _timeout;		}		/**		 * Indicates, in milliseconds, the latency result measured by the test.		 */		public function get latency():uint		{			return _latency;		}		/**		 * Clones the BandwidthTest instance.		 * 		 * @return New BandiwthTest instance with same properties as caller instance.		 */		public function clone():ICloneable		{			return new BandwidthTest(_urlRq, timeout);		}		/**		 * Starts the test.		 */		public function start():void		{			_loader.load(_urlRq);						_latencyTestStartTime = getTimer();						_loadStartTime = getTimer();						_timeoutID = setTimeout(testTimeoutReached, timeout);						_running = true;		}		/**		 * Stops the test.		 * When a test is stopped manually it is concidered to be completed and will dispatch event as if it has		 * either finished loading the reference file or reached its timeout.		 */		public function stop():void		{			testTimeoutReached();		}		/**		 * Indicates whether the test is currently running.		 */		public function get running():Boolean		{			return _running;		}		private function setEventListeners(add:Boolean):void		{			var method:String = add ? "addEventListener" : "removeEventListener";						_loader[method](Event.OPEN, handleEvents);						_loader[method](ProgressEvent.PROGRESS, handleEvents);						_loader[method](Event.COMPLETE, handleEvents);						_loader[method](IOErrorEvent.IO_ERROR, handleEvents);		}		private function handleEvents(e:Event):void		{			switch(e.type)			{				case Event.OPEN:					_latency = getTimer() - _latencyTestStartTime;					break;								case ProgressEvent.PROGRESS:					if(hasEventListener(BandwidthTestEvent.PROGRESS)) dispatchEvent(new BandwidthTestEvent(BandwidthTestEvent.PROGRESS));					break;								case Event.COMPLETE:					testTimeoutReached();					break;								case IOErrorEvent.IO_ERROR:					log("BandwidthTest was interrupted incorrectly.", LogLevel.TRACTIONAS3);					break;			}		}		private function testTimeoutReached():void		{				if(!_loader) return;						var bytesLoaded:uint = _loader.bytesLoaded;						try			{				_loader.close();			}			catch(e:Error) 			{			}						if(!_latency) _latency = getTimer() - _latencyTestStartTime;						if(_loader.bytesLoaded == _loader.bytesTotal)			{				log("BandithTest finished in less time than specified timeout. Calculating bandwidth based on elapsed time.", LogLevel.INFO);			}						_result = bytesLoaded / (elapsedTime / 1000);						dispatchEvent(new BandwidthTestEvent(BandwidthTestEvent.COMPLETE));						_running = false;						clearTimeout(_timeoutID);		}	}}