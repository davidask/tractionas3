/** * @version 1.0 * @author David Dahlstroem | daviddahlstroem.com *  *  * Copyright (c) 2009 David Dahlstroem | daviddahlstroem.com *  * Permission is hereby granted, free of charge, to any person obtaining a copy * of this software and associated documentation files (the "Software"), to deal * in the Software without restriction, including without limitation the rights * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell * copies of the Software, and to permit persons to whom the Software is * furnished to do so, subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in * all copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN * THE SOFTWARE. * */package org.tractionas3.events {	import flash.utils.Timer;	/**	 * Interval allows you to call functions at an interval, without using a Timer.	 */	public class Interval	{		/**		 * Default interval in milliseconds.		 */		public static const DEFAULT_INTERVAL:Number = 50;		private static var _instance:Interval;		private var timerInstance:Timer;		private var functions:Array = [];				/**		 * @private		 */		public function Interval(singletonEnforcer:SingletonEnforcer = null)		{			super();						if(!singletonEnforcer)			{				throw new ArgumentError("Interval is a singleton class and may only be accessed via its accessor method getInstance()."); 			}						timerInstance = new Timer(DEFAULT_INTERVAL);		}		/**		 * Specifies the interval of the function calls.		 */		public static function get interval():Number		{			return getInstance().timerInstance.delay;		}		public static function set interval(value:Number):void		{			getInstance().timerInstance.delay = value;		}		/**		 * Adds an interval handler to the Interval class.		 */		public static function addIntervalHandler(handler:Function):void		{			if(!getInstance().timerInstance.running) getInstance().timerInstance.start();							getInstance().functions.push(handler);		}		/**		 * Removes an interval handler from the Interval class.		 */		public static function removeIntervalHandler(handler:Function):void		{			if(!getInstance().timerInstance.running) getInstance().timerInstance.start();							for(var i:int = 0;i < getInstance().functions.length; ++i)			{				if(getInstance().functions[i] === handler)				{					getInstance().functions.splice(i, 1);					break;					return;				}			}		}		/**		 * Interval accessor.		 */		public static function getInstance():Interval 		{			if(_instance == null) _instance = new Interval(new SingletonEnforcer());			return _instance;		}	}}internal class SingletonEnforcer { }