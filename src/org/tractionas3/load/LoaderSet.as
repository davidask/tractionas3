/** * @version 1.0 * @author David Dahlstroem | daviddahlstroem.com *  *  * Copyright (c) 2009 David Dahlstroem | daviddahlstroem.com *  * Permission is hereby granted, free of charge, to any person obtaining a copy * of this software and associated documentation files (the "Software"), to deal * in the Software without restriction, including without limitation the rights * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell * copies of the Software, and to permit persons to whom the Software is * furnished to do so, subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in * all copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN * THE SOFTWARE. * */package org.tractionas3.load{	import org.tractionas3.core.Destructor;	import org.tractionas3.core.interfaces.ICoreInterface;	import org.tractionas3.core.interfaces.IResetable;	import org.tractionas3.events.LoaderSetEvent;	import org.tractionas3.events.WeakEventDispatcher;	import org.tractionas3.load.loaders.LoaderCore;	import org.tractionas3.reflection.stringify;	import flash.events.TimerEvent;	import flash.utils.Timer;	/**	 * Allows you to set marks defining a point in a loading process.	 * <p>	 * A LoaderSet instance defines a custom loading progress allowing your application to react to	 * when a certain amount of data has loaded - complete files or partially.	 * </p>	 * Unlike the LoaderSequence the LoaderSet does not interfere with loaders, it is simply an indicator. Use	 * LoaderSet when you e.g. want your applicaiton to respond to when one or several file streams have reached a	 * a certain progress. 	 */	 	/*	 * TODO Thourough testing of LoaderSet class required!	 */	public class LoaderSet extends WeakEventDispatcher implements ICoreInterface, IResetable	{				/**		 * Defines an identifier for the LoaderSet		 */		private var _loaderMap:Array;		private var _progressMap:Array;		private var _timer:Timer;				private var _name:String;				/**		 * LoaderSet Constructor		 */		public function LoaderSet(loaderSetName:String = null)		{			super(this);						name = loaderSetName || LoadManager.getNextLoaderSetName();						reset();		}				/**		 * Specifies the name of the loader set.		 */		public function get name():String		{			return _name;		}		public function set name(value:String):void		{				if(LoadManager.registerLoaderSetName(value))			{				_name = value;			}			else			{				throw new Error("Loader set name \"" + value + "\" allready used by another loader set.");			}		}		/**		 * Indicates the average progress of all the loaders referenced by a LoaderSet instance		 * with regard to each loaders progress goal.		 */		public function get progress():Number		{			var p:Number = 0;						var loader:LoaderCore;						var progressObjective:Number;							for(var i:int = 0;i < numLoaders; ++i)			{				loader = _loaderMap[i] as LoaderCore;								progressObjective = _progressMap[i] as Number;								p += Math.min(loader.progress / progressObjective, 1);			}						return p / numLoaders;		}		/**		 * Indicates the progress of all the loaders references by a LoaderSet		 * with regard to actual byte size and progress goal. Note that this method only returns an accurate		 * progress indication if the file size of each loader is known.		 * <p />		 * Use of the <i>prefetchBytesTotal()</i> method can retrieve a file size before		 * loading it.		 * 		 * @see org.tractionas3.load.LoaderCore#prefetchBytesTotal()		 */		public function get byteProgress():Number		{			var bytesTotalObjective:Number = 0;						var bytesLoaded:Number = 0;						var progressObjective:Number;						var loader:LoaderCore;						for(var i:int = 0;i < numLoaders; ++i)			{				loader = _loaderMap[i] as LoaderCore;								progressObjective = _progressMap[i] as Number;								bytesTotalObjective += loader.bytesTotal * progressObjective;								bytesLoaded += loader.bytesLoaded;			}						var p:Number = Math.min(bytesLoaded / bytesTotalObjective, 1);						if(isNaN(p) || !isFinite(p)) return 0;						return (p >= 1 && progress < 1) ? 0 : p;		}		/**		 * Indicates the number of loaders referenced by a LoaderSet instance.		 */		public function get numLoaders():uint		{			return _loaderMap.length;		}		/**		 * Returns an array containing the loader references of the load objective.		 */		public function get loaders():Array		{			return _loaderMap.concat();		}		/**		 * Adds a loader reference to the LoaderSet instance.		 * 		 * @param loader Loader reference.		 * @param progressGoal The progress goal of the loader reference. A loader only needs to reach this progress to be concidered fully loaded by a LoaderSet instance.		 */		public function addLoader(target:LoaderCore, progressGoal:Number = 1):LoaderCore		{			_timer.start();						_loaderMap.push(target);						_progressMap.push(Math.min(progressGoal, 1));						return target;		}		/**		 * Removes a loader reference from a LoaderSet instance.		 */		public function removeLoader(target:LoaderCore):void		{			var loader:LoaderCore;						for(var i:int = 0;i < numLoaders; ++i)			{				loader = _loaderMap[i] as LoaderCore;								if(loader == target)				{					_loaderMap.splice(i, 1);								_progressMap.splice(i, 1);				}			}		}		/**		 * Indicates whether the load objective instance has a loader reference.		 */		public function hasLoader(target:LoaderCore):Boolean		{			return _loaderMap.indexOf(target) >= 0;		}		/**		 * @inheritDoc		 */		override public function destruct(deepDestruct:Boolean = false):void		{			_timer.stop();						_timer.removeEventListener(TimerEvent.TIMER, update);						if(deepDestruct) Destructor.destructMultiple(_loaderMap);						_loaderMap = null;						_progressMap = null;						_timer = null;						LoadManager.unregisterLoaderSetName(name);						super.destruct(deepDestruct);		}				/**		 * @inheritDoc		 */				override public function toString():String		{			return stringify(this) + "(" + name + ")";		}		/**		 * @inheritDoc		 */		public function reset():void		{			_loaderMap = [];						_progressMap = [];						if(_timer)			{				_timer.stop();								_timer.removeEventListener(TimerEvent.TIMER, update);			}			_timer = null;						_timer = new Timer(50);						_timer.addEventListener(TimerEvent.TIMER, update);						_loaderMap = [];						_progressMap = [];		}		private function update(e:TimerEvent):void		{			if(progress >= 1)			{				/*				 * Only dispatch LoaderSetEvent.OBJECTIVE_MET if all loaders with a progress goal of 1				 * are acctually loaded.				 */				var loader:LoaderCore;								var progressGoal:Number;								for(var i:int = 0;i < _loaderMap.length; ++i)				{					loader = _loaderMap[i] as LoaderCore;										progressGoal = _progressMap[i] as Number;										if(progressGoal >= 1 && !loader.loaded)					{						return;					}					}								_timer.stop();								dispatchEvent(new LoaderSetEvent(LoaderSetEvent.COMPLETE));			}			else			{				if(hasEventListener(LoaderSetEvent.PROGRESS)) dispatchEvent(new LoaderSetEvent(LoaderSetEvent.PROGRESS));			}		}	}}