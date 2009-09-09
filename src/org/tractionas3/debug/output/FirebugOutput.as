/** * @version 1.0 * @author David Dahlstroem | daviddahlstroem.com *  *  * Copyright (c) 2009 David Dahlstroem | daviddahlstroem.com *  * Permission is hereby granted, free of charge, to any person obtaining a copy * of this software and associated documentation files (the "Software"), to deal * in the Software without restriction, including without limitation the rights * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell * copies of the Software, and to permit persons to whom the Software is * furnished to do so, subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in * all copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN * THE SOFTWARE. * */package org.tractionas3.debug.output {	import org.tractionas3.core.CoreObject;	import org.tractionas3.debug.LogLevel;	import org.tractionas3.debug.LogMessage;	import org.tractionas3.debug.Logger;	import org.tractionas3.debug.output.ILoggerOutput;	import flash.external.ExternalInterface;	/**	 * FirebugOutput allows you to relay debug messages to Firebug.	 * <p/>	 * <a href="http://getfirebug.com/" target="_blank">Firebug website</a>	 * 	 * @see org.tractionas3.debug.Logger	 * @see org.tractionas3.debug.Logger#addOutput()	 */	public class FirebugOutput extends CoreObject implements ILoggerOutput 	{		/**		 * Indicates whether Firebug is available.		 */		public static function get firebugAvailable():Boolean		{			if(ExternalInterface.call("function() { return typeof window.console == 'object' && typeof console.firebug == 'string'}"))			{				return true;			}						return false;		}		/**		 * @inheritDoc		 */		public function send(message:LogMessage):void		{			if(!firebugAvailable)			{				return;			}				ExternalInterface.call("console." + resolveLogMessageType(message.level), message.text);						ExternalInterface.call("console.groupCollapsed(\"StackTrace:\")");						for(var i:int = 0;i < message.stackTrace.entries.length; ++i)			{				ExternalInterface.call("console." + resolveLogMessageType(message.level), message.stackTrace.entries[i] as String);			}						ExternalInterface.call("console.groupEnd()");		}		/**		 * @inheritDoc		 */		override public function destruct(deepDestruct:Boolean = false):void		{			Logger.removeOutput(this);						super.destruct(deepDestruct);		}		private function resolveLogMessageType(messageType:uint):String		{			switch(messageType)			{				case LogLevel.TRACE:					return "info";					break;								case LogLevel.INFO:					return "info";					break;								case LogLevel.STATUS:					return "info";					break;								case LogLevel.NOTICE:					return "info";					break;								case LogLevel.DEBUG:					return "info";					break;								case LogLevel.WARNING:					return "warn";					break;								case LogLevel.ERROR:					return "error";					break;								case LogLevel.FATAL:					return "error";					break;									case LogLevel.TRACTIONAS3:					return "info";					break;			}						return "info";		}	}}