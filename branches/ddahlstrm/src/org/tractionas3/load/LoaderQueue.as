/** * @version 1.0 * @author David Dahlstroem | daviddahlstroem.com *  *  * Copyright (c) 2009 David Dahlstroem | daviddahlstroem.com *  * Permission is hereby granted, free of charge, to any person obtaining a copy * of this software and associated documentation files (the "Software"), to deal * in the Software without restriction, including without limitation the rights * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell * copies of the Software, and to permit persons to whom the Software is * furnished to do so, subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in * all copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN * THE SOFTWARE. * */package org.tractionas3.load{	import org.tractionas3.core.Destructor;	import org.tractionas3.core.interfaces.ICancelable;	import org.tractionas3.core.interfaces.ICoreInterface;	import org.tractionas3.core.interfaces.IRunnable;	import org.tractionas3.events.LoaderQueueEvent;	import org.tractionas3.events.WeakEventDispatcher;	import org.tractionas3.load.CoreLoader;	import org.tractionas3.load.ILoadable;	import flash.events.TimerEvent;	import flash.utils.Timer;	/**	 * LoaderQueue is used for loading multiple files in a queue.	 * <p />	 * Using the  LoaderQueue class you can load multiple files of various types. All loaders in the org.tractionas3.load package are supported.	 * Many times when creating a web application you have to deal with required external assets for a specific part, or section, of that application.	 * LoaderQueue provides a good way to gather and control the loading of these assets.	 * <p />	 * LoaderQueue will dispatch a range of events allowing you to monitor the progress of both overall and individual load progress. By naming the loaders	 * you can easily monitor what is loading, allowing you to progressively deploy the loaded content.	 */	 	/*	 * TODO Testing of LoaderQueue required!	 * TODO Implement naming and centralization of several queues.	 */	public class LoaderQueue extends WeakEventDispatcher implements ICoreInterface, ICancelable, IRunnable	{		/**		 * Total number of loaders allowed to be in progress at any given time.		 * The number of slots may be changed at any time. Setting the number of slots to zero while the queue is running will		 * prevent the queue from processing loaders further.		 */		public var slots:uint;		/** @private */		protected var _loaderMap:Array;		/** @private */		protected var _loadersInQueuePool:Array;		/** @private */		protected var _loadersInProgressPool:Array;		/** @private */		protected var _loadersInCompletePool:Array;		private var _complete:Boolean = false;		private var _loading:Boolean = false;		private var _timer:Timer;		private var _name:String;				/**		 * Creates a new LoaderQueue object.		 * 		 * @param numSlots Number of open slots in the queue. This may be changed via the <code>LoaderQueue.slots</code> property.		 * 		 * @see #slots		 */		public function LoaderQueue(numSlots:uint = 1, name:String = null)		{			super(this);						_name = name;						slots = numSlots;						_loaderMap = [];						_loadersInProgressPool = [];						_loadersInCompletePool = [];						_loadersInQueuePool = [];						_timer = new Timer(50);						_timer.addEventListener(TimerEvent.TIMER, processQueue);		}		/**		 * Indicates the name of the LoaderQueue.		 * A loader queue name can only be set in the LoaderQueue constructor.		 */		public function get name():String		{			return _name;		}		/**		 * Starts the queue.		 * A running queue will actively process loaders and instruct them to load appropriately.		 * 		 * @see #running		 * @see #stop()		 */		public function start():void		{			_timer.start();						dispatchEvent(new LoaderQueueEvent(LoaderQueueEvent.QUEUE_START));		}		/**		 * Stops the queue.		 * An inactive queue will not instruct loaders to load and will remain in its current state untill resumed.		 * 		 * @see #running		 * @see #start()		 */		public function stop():void		{			_timer.stop();						dispatchEvent(new LoaderQueueEvent(LoaderQueueEvent.QUEUE_STOP));		}		/**		 * Stops the queue and cancels all cancelable loaders. Any loaders canceled are reenqueued and will begin loading		 * when the queue is started again.		 */		public function cancelAndStop():void		{			stop();						cancel();		}		/**		 * Returns an array containing references to all the loaders in the queue.		 */		public function get loaders():Array		{						var a:Array = [];						for(var i:int = 0;i < numLoaders; ++i)			{				a.push(_loaderMap[i]);			}						return a;		}		/**		 * Returns an array containing references to loaders currently waiting to be loaded.		 */		public function get loadersQueued():Array		{			var a:Array = [];						for(var i:int = 0;i < _loadersInQueuePool.length; ++i)			{				a.push(_loadersInQueuePool[i]);			}						return a;		}		/**		 * Returns an array containing references to loaders currently in load progress.		 */		public function get loadersProgress():Array		{			var a:Array = [];						for(var i:int = 0;i < _loadersInProgressPool.length; ++i)			{				a.push(_loadersInProgressPool[i]);			}						return a;		}		/**		 * Returns an array containing references to loaders completed their loading process.		 */		public function get loadersComplete():Array		{			var a:Array = [];						for(var i:int = 0;i < _loadersInCompletePool.length; ++i)			{				a.push(_loadersInCompletePool[i]);			}						return a;		}		/**		 * Indicates the current number of empty slots.		 * 		 * @see #slots		 */		public function get emptySlots():uint		{			return Math.max(slots - _loadersInProgressPool.length, 0);		}		/**		 * Adds a loader to the queue.		 * 		 * @param target Target loader.		 * 		 * @see #removeLoader()		 */		public function addLoader(target:CoreLoader):CoreLoader		{			_loaderMap.push(target);						_loadersInQueuePool.push(target);						_loadersInQueuePool.sortOn("priority", Array.NUMERIC);						dispatchEvent(new LoaderQueueEvent(LoaderQueueEvent.LOADER_ENQUEUED, target));						return target;		}		/**		 * Removes a loader from the queue.		 * 		 * @param target Target loader.		 * @param cancel If set to <code>true</code> and if the loader is cancelable the loading process of the target loader will be canceled.		 * 		 * @see #addLoader()		 */		public function removeLoader(target:CoreLoader, cancel:Boolean = false):void		{			_loaderMap.splice(_loaderMap.indexOf(target), 1);						_loadersInQueuePool.splice(_loadersInQueuePool.indexOf(target), 1);						_loadersInProgressPool.splice(_loadersInProgressPool.indexOf(target), 1);						_loadersInCompletePool.splice(_loadersInCompletePool.indexOf(target), 1);						if(cancel)			{				if(target.loading && target.cancelable) ICancelable(target).cancel();			}						dispatchEvent(new LoaderQueueEvent(LoaderQueueEvent.LOADER_DEQUEUED, target));		}		/**		 * Removes a loader from the queue and cancels its loading progress if able.		 * 		 * @param target Target loader.		 */		public function removeAndCancelLoader(target:CoreLoader):void		{			if(target.cancelable) ICancelable(target).cancel();						removeLoader(target);		}		/**		 * Indicates whether the queue is loaded.		 * A queue is concidered to be loaded when all loaders in the queue are loaded.		 */		public function get loaded():Boolean		{			for(var i:int = 0;i < numLoaders; ++i)			{				if(!CoreLoader(_loaderMap[i]).loaded) return false;					}						return true;		}		/**		 * Indicates the average of all loaders current progress.		 */		public function get progress():Number		{			var bl:uint = 0;						var bt:uint = 0;						var loader:ILoadable;						for(var i:int = 0;i < numLoaders; ++i)			{				loader = _loaderMap[i] as ILoadable;								bl += loader.bytesLoaded;								bt += loader.bytesTotal;			}						var ratio:Number = bl / bt;						return (isNaN(ratio)) ? 0 : ratio;		}		/**		 * Indicates the number of loaders contained by the queue		 */		public function get numLoaders():uint		{			return _loaderMap.length;		}		/**		 * Indicates whether the queue is running.		 */		public function get running():Boolean		{			return _timer.running;		}		/**		 * Prefetches the filesize of all contained loaders in the queue. This will make the <code>LoaderQueue.progress</code>		 * indicate a more accurate value if not all loaders in the sequence are loading at any given time.		 * 		 * @see org.tractionas3.load.CoreLoader#prefetchBytesTotal()		 */		public function prefetchBytesTotal():void		{			for(var i:int = 0;i < numLoaders; ++i)			{				ILoadable(_loaderMap[i]).prefetchBytesTotal();			}		}		/**		 * Cancels all loaders currently in progress.		 * Canceled loaders are reenqueued.		 */		public function cancel():void		{			var loader:CoreLoader;						for(var i:int = 0;i < _loadersInProgressPool.length; ++i)			{				loader = _loadersInProgressPool[i] as CoreLoader;								if(loader.cancelable)				{						_loadersInProgressPool.shift();										loader.reset();										_loadersInQueuePool.splice(0, 0, loader);										cancel();										return;				}			}		}		/**		 * Destructs the LoaderQueue		 * @param deepDestruct If <code>true</code> loaders connected to the LoaderQueue will be destructed also.		 */		override public function destruct(deepDestruct:Boolean = false):void		{			_timer.removeEventListener(TimerEvent.TIMER, processQueue);						slots = 0;						if(deepDestruct)			{				Destructor.destructMultiple(_loaderMap, deepDestruct);								Destructor.destructMultiple(_loadersInQueuePool, deepDestruct);								Destructor.destructMultiple(_loadersInProgressPool, deepDestruct);								Destructor.destructMultiple(_loadersInCompletePool, deepDestruct);			}						super.destruct(deepDestruct);						_loaderMap = null;						_loadersInQueuePool = null;						_loadersInProgressPool = null;						_loadersInCompletePool = null;						_complete = false;						_loading = false;						_timer = null;						_name = null;		}		private function processQueue(e:TimerEvent):void		{						if(_loadersInQueuePool.length > 0) 			{								_complete = false;								populateProgressPool();			}			else			{				if(!_complete && _loadersInProgressPool.length == 0)				{						_complete = true;										_loading = false;										dispatchEvent(new LoaderQueueEvent(LoaderQueueEvent.QUEUE_COMPLETE));										return;				}			}						if(_loadersInProgressPool.length > 0) processLoadersInProgressPool();						if(progress < 1 && hasEventListener(LoaderQueueEvent.QUEUE_PROGRESS)) dispatchEvent(new LoaderQueueEvent(LoaderQueueEvent.QUEUE_PROGRESS)); 		}		private function populateProgressPool():void		{						_loading = true;						var numPopulations:uint = Math.min(_loadersInQueuePool.length, emptySlots);						for(var i:int = 0;i < numPopulations; ++i)			{				var				loader:CoreLoader = _loadersInQueuePool.shift();				loader.load();								_loadersInProgressPool.push(loader);								if(hasEventListener(LoaderQueueEvent.LOADER_START)) dispatchEvent(new LoaderQueueEvent(LoaderQueueEvent.LOADER_START, loader));			}		}		private function processLoadersInProgressPool():void		{							var loader:CoreLoader;						for(var i:int = 0;i < _loadersInProgressPool.length; ++i)			{					loader = _loadersInProgressPool[i] as CoreLoader;								if(loader.loading && hasEventListener(LoaderQueueEvent.LOADER_PROGRESS)) dispatchEvent(new LoaderQueueEvent(LoaderQueueEvent.LOADER_PROGRESS, loader));								if(loader.loaded)				{					_loadersInCompletePool.push(loader);										_loadersInProgressPool.splice(i, 1);										if(hasEventListener(LoaderQueueEvent.LOADER_COMPLETE)) dispatchEvent(new LoaderQueueEvent(LoaderQueueEvent.LOADER_COMPLETE, loader));										processLoadersInProgressPool();										return;				}			}		}	}}