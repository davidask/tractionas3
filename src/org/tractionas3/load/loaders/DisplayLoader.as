/** * @version 1.0 * @author David Dahlstroem | daviddahlstroem.com *  *  * Copyright (c) 2009 David Dahlstroem | daviddahlstroem.com *  * Permission is hereby granted, free of charge, to any person obtaining a copy * of this software and associated documentation files (the "Software"), to deal * in the Software without restriction, including without limitation the rights * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell * copies of the Software, and to permit persons to whom the Software is * furnished to do so, subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in * all copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN * THE SOFTWARE. * */package org.tractionas3.load.loaders{	import org.tractionas3.core.interfaces.ICancelable;	import org.tractionas3.core.interfaces.ICloneable;	import org.tractionas3.events.LoaderEvent;	import org.tractionas3.load.ILoadable;	import org.tractionas3.load.IUnloadable;	import flash.display.Loader;	import flash.events.Event;	import flash.events.IOErrorEvent;	import flash.events.ProgressEvent;	import flash.events.SecurityErrorEvent;	import flash.system.LoaderContext;	/**	 * DisplayLoader provides a standard base API loader for loading display files. 	 */	public class DisplayLoader extends LoaderCore implements ILoadable, ICancelable, IUnloadable	{		/**		 * Specifies the LoaderContext object.		 * <p />		 * Has properties that define the following:		 * <ul>		 * <li>Whether or not to check for the existence of a policy file upon loading the object</li>		 * <li>The ApplicationDomain for the loaded object</li>		 * <li>The SecurityDomain for the loaded object</li>		 * </ul>		 */		public var loaderContext:LoaderContext;		/** @private */		protected var _loader:Loader;				/**		 * Creates a new DisplayLoader object.		 * 		 * @param url The URL from wich the data should be loaded.		 * @param loaderName Assigned name to the loader.		 */		public function DisplayLoader(url:String = null, loaderName:String = null)		{			super(url, loaderName);		}		/**		 * Cancels the loading process.		 * The <code>reset()</code> method must be called before calling the <code>load()</code> method again.		 */		public function cancel():void		{			var success:Boolean = true;						try			{				_loader.close();			}			catch(e:Error)			{				success = false;			}						if(success) dispatchLoadCancelEvent();		}		/**		 * @inheritDoc		 */		override public function load(newURL:String = null):void		{			if(newURL) url = newURL;						_loader.load(getURLRequest(), loaderContext);		}		public function unload():void		{			_loader.unload();						reset();		}		/**		 * @inheritDoc		 */		override public function clone():ICloneable		{			var			loader:DisplayLoader = new DisplayLoader(url, name);						loader.loaderContext = loaderContext;						return loader;		}		/**		 * @inheritDoc		 */		override public function reset():void		{						if(_loader) destruct();						_loader = new Loader();						loaderContext = new LoaderContext();						_byteReference = new ByteReference(_loader.contentLoaderInfo);						setEventListeners(true);		}		/**		 * @inheritDoc		 */		override public function destruct(deepDestruct:Boolean = false):void		{			cancel();						try			{				_loader.unload();			}			catch(e:Error) 			{ 			};						setEventListeners(false);						_byteReference.destruct(true);						_loader = null;						super.destruct(deepDestruct);		}		/**		 * Returns the root display object of the SWF file or image (JPG, PNG, or GIF) file that was loaded.		 * @inheritDoc		 */		override public function get data():*		{			return _loader.content;		}		private function setEventListeners(add:Boolean):void		{						if(!_loader) return;						var method:String = add ? "addEventListener" : "removeEventListener";						_loader.contentLoaderInfo[method](Event.OPEN, dispatchLoadStartEvent);						_loader.contentLoaderInfo[method](Event.COMPLETE, dispatchLoadCompleteEvent);						_loader.contentLoaderInfo[method](ProgressEvent.PROGRESS, dispatchLoadProgressEvent);						_loader.contentLoaderInfo[method](IOErrorEvent.IO_ERROR, dispatchIOErrorEvent);						_loader.contentLoaderInfo[method](SecurityErrorEvent.SECURITY_ERROR, dispatchSecurityErrorEvent);						_loader.contentLoaderInfo[method](Event.INIT, dispatchInitEvent);		}		/** @private */		protected function dispatchInitEvent(e:Event):void		{			dispatchEvent(new LoaderEvent(LoaderEvent.INIT));		}	}}