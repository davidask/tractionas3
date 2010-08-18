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
 
package org.tractionas3.load 
{
	import org.tractionas3.core.interfaces.ICoreInterface;
	import org.tractionas3.core.interfaces.IResetable;
	import org.tractionas3.events.WeakEventDispatcher;
	import org.tractionas3.load.loaders.LoaderCore;
	/**
	 * LoadManager uses a loader queue to orchestrate loading of loader sets, providing a centralized load mechanism for an application.
	 */
	public class LoadManager extends WeakEventDispatcher implements ICoreInterface, IResetable 
	{
		/**
		 * LoadManager accessor
		 */
		public static function getInstance():LoadManager
		{
			if(!_instance) _instance = new LoadManager(new SingletonEnforcer());
			
			return _instance;
		}

		public static function getNextHighestLoaderPriority():uint
		{
			return _highestLoaderPriority++;
		}

		/**
		 * @private
		 */
		public static function registerPriority(value:uint):void
		{
			_highestLoaderPriority = Math.max(_highestLoaderPriority, value);
		}

		/**
		 * @private
		 */
		public static function registerLoaderName(name:String):Boolean
		{
			if(_loaderNames.indexOf(name) == -1)
			{
				_loaderNames.push(name);
				
				return true;
			}
			
			return false;
		}

		/**
		 * @private
		 */
		public static function unregisterLoaderName(name:String):void
		{
			_loaderNames.splice(_loaderNames.indexOf(name), 1);
		}

		/**
		 * Returns the next automatic loader name
		 */
		public static function getNextLoaderName():String
		{
			_loaderNameIncrement++;
			
			return "loader_" + _loaderNameIncrement.toString();
		}

		/**
		 * @private
		 */
		public static function registerLoaderSetName(name:String):Boolean
		{
			if(_loaderSetNames.indexOf(name) == -1)
			{
				_loaderSetNames.push(name);
				
				return true;
			}
			
			return false;
		}

		/**
		 * @private
		 */
		public static function unregisterLoaderSetName(name:String):void
		{
			_loaderSetNames.splice(_loaderSetNames.indexOf(name), 1);
		}

		/**
		 * Returns the next automatic loader set name
		 */
		public static function getNextLoaderSetName():String
		{	
			_loaderSetNameIncrement++;
			
			return "loaderSet_" + _loaderSetNameIncrement.toString();
		}

		public static var supressIOErrors:Boolean = false;

		private static var _instance:LoadManager;

		private static var _highestLoaderPriority:uint = 0;

		private static var _loaderNames:Array = [];
		
		private static var _loaderNameIncrement:uint = 0;

		private static var _loaderSetNames:Array = [];
		
		private static var _loaderSetNameIncrement:uint = 0;

		private var _loaderQueue:LoaderQueue;

		private var _loaderSets:Array;

		/**
		 * @private
		 */
		public function LoadManager(singletonEnforcer:SingletonEnforcer)
		{
			super(this);
			
			if(!singletonEnforcer)
			{
				throw new Error("LoadManager is a singleton and may only be accessed via its accessor getInstance().");
				return;
			}
			
			reset();
		}

		/**
		 * Starts loading
		 */
		public function startLoading():void
		{
			_loaderQueue.start();
		}

		/**
		 * Stops loading
		 */
		public function stopLoading(cancel:Boolean = false):void
		{
			if(cancel) _loaderQueue.cancel();
			
			_loaderQueue.stop();
		}

		/**
		 * Defines the number of load operations to be allowed at any given time.
		 */
		public function get simultaneousLoadOperationsAllowed():uint
		{
			return _loaderQueue.slots;
		}

		public function set simultaneousLoadOperationsAllowed(value:uint):void
		{
			_loaderQueue.slots = value;
		}

		/**
		 * Increases the priority of each loader in specified set, allowing them to load before loaders in other sets.
		 * @param loaderSet Target loader set
		 * @param cancelCurrentLoading Specifies whether the any current loaders should be aborted.
		 */
		public function prioritizeLoaderSet(loaderSet:LoaderSet, cancelCurrentLoading:Boolean = false):void
		{
			var loader:LoaderCore;
			
			var highestPriority:uint = getNextHighestLoaderPriority();
			
			for(var i:int = 0;i < loaderSet.loaders.length;++i)
			{
				loader = loaderSet.loaders[i] as LoaderCore;
				
				loader.priority += highestPriority;
			}
			
			if(cancelCurrentLoading && _loaderQueue.running)
			{
				_loaderQueue.cancelAndStop();
				
				_loaderQueue.start();
			}
		}

		/**
		 * Adds a loader set to the LoadManager
		 * @param loaderSet Target loader set
		 * @param prefetchLoaderSetBytesTotal Specifies whether the loaders in target loader set should have their filesize prefetched
		 */
		public function addLoaderSet(loaderSet:LoaderSet, prefetchLoaderSetBytesTotal:Boolean = false):LoaderSet
		{
			_loaderSets.push(loaderSet);
			
			var loader:LoaderCore;
			
			for(var i:int = 0;i < loaderSet.loaders.length;++i)
			{
				loader = loaderSet.loaders[i] as LoaderCore;
				
				if(prefetchLoaderSetBytesTotal) loader.prefetchBytesTotal();
				
				_loaderQueue.addLoader(loader);
			}
			
			return loaderSet;
		}

		/**
		 * Removes a loader set from the LoadManager
		 * @param loaderSet Target loader set
		 * @param cancel Specifies whether the loaders in the set should cancel their loading process.
		 */
		public function removeLoaderSet(loaderSet:LoaderSet, cancel:Boolean = false):void
		{
			_loaderSets.splice(_loaderSets.indexOf(loaderSet), 1);
			
			var loader:LoaderCore;
			
			for(var i:int = 0;i < loaderSet.loaders.length;++i)
			{
				loader = loaderSet.loaders[i] as LoaderCore;
				
				_loaderQueue.removeLoader(loader, cancel);
			}
		}

		/**
		 * Returns a loader set with specified name
		 */
		public function getLoaderSetByName(name:String):LoaderSet
		{
			var loaderSet:LoaderSet;
			
			for(var i:int = 0;i < _loaderSets.length;++i)
			{
				loaderSet = getLoaderSetByIndex(i);
				
				if(loaderSet.name == name)
				{
					return loaderSet;
				}
			}
			
			return null;
		}

		/**
		 * Returns a loader in any of the sets registered to LoadManager with specified name
		 */
		public function getLoaderByName(name:String):LoaderCore
		{
			var loader:LoaderCore;
			
			for(var i:int = 0;i < _loaderQueue.numLoaders;++i)
			{
				loader = _loaderQueue.loaders[i] as LoaderCore;
				
				if(loader.name == name)
				{
					return loader;
				}
			}
			
			return null;
		}

		/**
		 * Returns a loader set by specified index
		 */
		public function getLoaderSetByIndex(index:uint):LoaderSet
		{
			return _loaderSets[index] as LoaderSet;
		}

		/**
		 * Resets the LoadManager, clearing it of all sets.
		 */
		public function reset():void
		{
			_loaderSets = [];
			
			if(!_loaderQueue)
			{
				_loaderQueue = new LoaderQueue(1);
			}
		}
	}
}

internal class SingletonEnforcer 
{
}
