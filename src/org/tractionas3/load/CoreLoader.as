/** * @version 1.0 * @author David Dahlstroem | daviddahlstroem.com *  *  * Copyright (c) 2009 David Dahlstroem | daviddahlstroem.com *  * Permission is hereby granted, free of charge, to any person obtaining a copy * of this software and associated documentation files (the "Software"), to deal * in the Software without restriction, including without limitation the rights * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell * copies of the Software, and to permit persons to whom the Software is * furnished to do so, subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in * all copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN * THE SOFTWARE. * */package org.tractionas3.load{	import org.tractionas3.core.interfaces.ICancelable;	import org.tractionas3.events.LoaderEvent;	import org.tractionas3.events.WeakEventDispatcher;	import org.tractionas3.profiler.BandwidthProfiler;	import org.tractionas3.reflection.stringify;	import flash.errors.IOError;	import flash.events.Event;	import flash.net.URLRequest;	import flash.utils.getTimer;	/**	 * CoreLoader class is the base class of all loader classes.	 * <p />	 * Providing core functinality to all loader classes, CoreLoader is the type to reference when dealing with common loader properties	 * such as <code>name</code> and <code>priority</code>.	 * <p />	 */	public class CoreLoader extends WeakEventDispatcher implements ILoadable 	{		/**		 * Defines the priority of the loader.		 * Loaders with a low priority value will be loaded before loaders with a higher priority value		 * in a loader queue.		 * 		 * @see org.tractionas3.load.LoaderQueue		 */		public var priority:uint = 0;		/**		 * Specifies the name of the loader.		 */		public var name:String;		/** @private */		protected var _urlRequest:URLRequest;		/** @private */		protected var _bytesTotalPrefetcher:BytesTotalPrefetcher;		/** @private */		protected var _byteReference:ByteReference;		private var _isLoaded:Boolean = false;		private var _loadStartTime:uint;		private var _loadCompleteTime:uint;		private var _bytesLoadedRegisterHolder:uint;				/**		 * Creates a new CoreLoader object.		 * 		 * @param url The URL from wich the data should be loaded.		 * @param loaderName Assigned name to the loader.		 */		public function CoreLoader(url:String = null, loaderName:String = null)		{			super(this);						_urlRequest = new URLRequest(url);						name = loaderName;						_bytesLoadedRegisterHolder = 0;						reset();		}		/**		 * @inheritDoc		 */		public function load(newURL:String = null):void		{			return;		}		/**		 * @inheritDoc		 */		public function clone():Object		{			return new CoreLoader(url, name);		}		public function get url():String		{			return getURLRequest().url;		}		public function set url(newURL:String):void		{			_urlRequest = new URLRequest(newURL);		}		/**		 * Resets the loader and its properties to what they were upon instantiation.		 */		public function reset():void		{			return;		}		/**		 * @inheritDoc		 */		override public function toString():String		{			return stringify(this);		}		/**		 * @inheritDoc		 */		final public function get progress():Number		{			var p:Number = bytesLoaded / bytesTotal;						return (isNaN(p)) ? 0 : p;		}		/**		 * @inheritDoc		 */		final public function get bytesLoaded():uint		{				return (_byteReference.hasValidTarget) ? _byteReference.bytesLoaded : 0;		}		/**		 * @inheritDoc		 */		final public function get bytesTotal():int		{			if(!_byteReference.hasValidTarget) return 0;						if(_byteReference.bytesTotal <= 0)			{					return (bytesTotalPrefetcher && bytesTotalPrefetcher.prefetchComplete) ? bytesTotalPrefetcher.getPrefetchedBytesTotal() : 0;			}						return _byteReference.bytesTotal;		}		/**		 * @inheritDoc		 */		final public function get loaded():Boolean		{			return _isLoaded;		}		/**		 * @inheritDoc		 */		final public function get loading():Boolean		{			return (_byteReference.bytesLoaded > 0 && _byteReference.bytesLoaded < _byteReference.bytesTotal);		}		/**		 * @inheritDoc		 */		final public function get loadTime():uint		{			return _loadCompleteTime - _loadStartTime;		}		/**		 * Returns the loaded data of the CoreLoader.		 * @inheritDoc		 */		public function get data():*		{			return null;		}		/**		 * @inheritDoc		 */		final public function getURLRequest():URLRequest		{			return _urlRequest;		}		/**		 * @inheritDoc		 */		final public function get cancelable():Boolean		{			return (this is ICancelable);		}		/**		 * @inheritDoc		 */		final public function get bytesTotalPrefetcher():BytesTotalPrefetcher		{			return _bytesTotalPrefetcher;		}		/**		 * @inheritDoc		 */		final public function prefetchBytesTotal():void		{			if(_bytesTotalPrefetcher)			{				_bytesTotalPrefetcher.destruct();				_bytesTotalPrefetcher = null;			}						_bytesTotalPrefetcher = new BytesTotalPrefetcher(_urlRequest);						_bytesTotalPrefetcher.addEventListener(LoaderEvent.BYTESTOTAL_PREFETCHED, bytesTotalPrefetchComplete);		}		/**		 * @inheritDoc		 */		override public function listDestructableProperties():Array		{			return ["priority"];		}		/** @private */		final protected function dispatchLoadStartEvent(e:Event = null):void		{			_isLoaded = false;						_loadStartTime = getTimer();						BandwidthProfiler.getInstance().registerLoadOperation();							BandwidthProfiler.getInstance().registerLoadOperationCurrent();						if(hasEventListener(LoaderEvent.START)) dispatchEvent(new LoaderEvent(LoaderEvent.START));		}		/** @private */		final protected function dispatchLoadProgressEvent(e:Event = null):void		{				_isLoaded = false;						BandwidthProfiler.getInstance().registerBytesLoaded(bytesLoaded - _bytesLoadedRegisterHolder);							_bytesLoadedRegisterHolder = bytesLoaded;						//No need for creating hundreds of new LoaderEvent instances if nobody wants em.			if(hasEventListener(LoaderEvent.PROGRESS)) dispatchEvent(new LoaderEvent(LoaderEvent.PROGRESS));		}		/** @private */		final protected function dispatchLoadCompleteEvent(e:Event = null):void		{			_isLoaded = true;						_loadCompleteTime = getTimer(); 						BandwidthProfiler.getInstance().registerBytesLoaded(bytesLoaded - _bytesLoadedRegisterHolder);							BandwidthProfiler.getInstance().registerLoadOperationCompleted();							_bytesLoadedRegisterHolder = 0;						if(hasEventListener(LoaderEvent.COMPLETE)) dispatchEvent(new LoaderEvent(LoaderEvent.COMPLETE));		}		/** @private */		final protected function dispatchIOErrorEvent(e:Event = null):void		{			_isLoaded = false;						if(hasEventListener(LoaderEvent.IO_ERROR)) 			{				dispatchEvent(new LoaderEvent(LoaderEvent.IO_ERROR));			}			else			{				throw new IOError("File was not found or was cancelled incorrectly. (" + getURLRequest().url + ")");			}		}		/** @private */		final protected function dispatchSecurityErrorEvent(e:Event = null):void		{			_isLoaded = false;						if(hasEventListener(LoaderEvent.SECURITY_ERROR)) 			{				dispatchEvent(new LoaderEvent(LoaderEvent.SECURITY_ERROR));			}			else			{				throw new SecurityError("SecurityError occured while attempting to load data from URL " + getURLRequest().url);			}		}		/** @private */		final protected function dispatchLoadCancelEvent(e:Event = null):void		{			BandwidthProfiler.getInstance().registerByteWaste(_bytesLoadedRegisterHolder);							BandwidthProfiler.getInstance().registerLoadOperationCancelled();							_bytesLoadedRegisterHolder = 0;						if(hasEventListener(LoaderEvent.CANCEL)) dispatchEvent(new LoaderEvent(LoaderEvent.CANCEL));		}		private function bytesTotalPrefetchComplete(e:LoaderEvent):void		{			if(hasEventListener(LoaderEvent.BYTESTOTAL_PREFETCHED)) this.dispatchEvent(new LoaderEvent(LoaderEvent.BYTESTOTAL_PREFETCHED));		}	}}