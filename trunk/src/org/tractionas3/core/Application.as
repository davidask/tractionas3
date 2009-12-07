/** * @version 1.0 * @author David Dahlstroem | daviddahlstroem.com *  *  * Copyright (c) 2009 David Dahlstroem | daviddahlstroem.com *  * Permission is hereby granted, free of charge, to any person obtaining a copy * of this software and associated documentation files (the "Software"), to deal * in the Software without restriction, including without limitation the rights * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell * copies of the Software, and to permit persons to whom the Software is * furnished to do so, subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in * all copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN * THE SOFTWARE. * */package org.tractionas3.core {	import org.tractionas3.display.CoreSprite;	import flash.display.LoaderInfo;	import flash.display.Stage;	import flash.display.StageAlign;	import flash.display.StageScaleMode;	/**	 * Application provides a main entry point for your application and should be extended for use as document class only.	 * 	 * It stores the stage, root and loaderInfo in static properties automatically.	 * Extend Application for modified usage.	 * <p />	 * To reference the stage, root or loaderInfo from anywhere in your application simply use the	 * <code>Application.stage</code>, <code>Application.root</code> or <code>Application.loaderInfo</code> static properties.	 */	public class Application extends CoreSprite 	{
		private static var _stage:Stage;
		private static var _root:Application;
		private static var _loaderInfo:LoaderInfo;
		private static var _referencesSet:Boolean = false;				/**		 * Static read-only property for global access to application stage.		 */
		public static function get stage():Stage		{			return _stage;		}		/**		 * Static read-only property for global access to application root.		 */
		public static function get root():Application		{			return _root;			}		/**		 * Static read-only property for global access to application loaderInfo.		 */
		public static function get loaderInfo():LoaderInfo		{			return _loaderInfo;		}		/**		 * Creates a new Application object.		 * An Application instance expects to have access to stage, root and loaderInfo properties on instantiation.		 * Using an instance of Application as other than document class will throw an error.		 * 		 * <p />		 * Application automatically sets the stage <i>scaleMode</i> property to <i>StageScaleMode.NO_SCALE</i> and the <i>align</i> property to <i>StageAlign.TOP_LEFT</i>.		 */		public function Application()		{			super();						stage.scaleMode = StageScaleMode.NO_SCALE;						stage.align = StageAlign.TOP_LEFT;						setReferences();		}		private function setReferences():void		{			if(!stage)			{				throw new Error("Application may only be used as document class.");				return;			}						if(_referencesSet)			{				throw new Error("Application should be used as a single document class for your project. Externally loaded SWF files should not extend applicaiton.");				return;			}						_stage = this.stage;						_root = this;						_loaderInfo = this.loaderInfo;						_referencesSet = true;		}	}}