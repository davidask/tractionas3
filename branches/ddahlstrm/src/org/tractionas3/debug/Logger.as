/** * @version 1.0 * @author David Dahlstroem | daviddahlstroem.com *  *  * Copyright (c) 2009 David Dahlstroem | daviddahlstroem.com *  * Permission is hereby granted, free of charge, to any person obtaining a copy * of this software and associated documentation files (the "Software"), to deal * in the Software without restriction, including without limitation the rights * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell * copies of the Software, and to permit persons to whom the Software is * furnished to do so, subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in * all copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN * THE SOFTWARE. * */package org.tractionas3.debug {	import org.tractionas3.debug.output.ILoggerOutput;	import org.tractionas3.debug.output.TraceOutput;	import org.tractionas3.reflection.stringify;	/**	 * Logger handles log messages and relays them to its added outputs.	 * 	 * @see org.tractionas3.debug.log	 */	public class Logger	{		private static var _outputMap:Array = [];		private static var _enabled:Boolean = true;				/**		 * Adds a logger output to the Logger output list.		 * 		 * @see org.tractionas3.debug.output.LoggerOutput		 */		public static function addOutput(targetOutput:ILoggerOutput):ILoggerOutput		{			_outputMap.push(targetOutput);						return targetOutput;		}		/**		 * Removes an added output from logger.		 */		public static function removeOutput(targetOutput:ILoggerOutput):void		{			var currentOutput:ILoggerOutput;						for(var i:int = 0;i < _outputMap.length; ++i)			{				currentOutput = _outputMap[i] as ILoggerOutput;								if(currentOutput === targetOutput)				{						_outputMap.splice(i, 1);					return;				}			}		}		/**		 * Specifies whether the Logger will relay messages to the added outputs.		 * When releasing your project, you can simply set this property to <code>false</code>		 * to stop log messages from reaching the outputs.		 */		public static function get enabled():Boolean		{			return _enabled;		}		public static function set enabled(value:Boolean):void		{			_enabled = value;		}		/**		 * Indicates whether Logger has specified output added to it.		 * 		 * @param output Specified output.		 */		public static function hasOutput(output:ILoggerOutput):Boolean		{			return _outputMap.indexOf(output) > -1;		}		/**		 * Indicates whether Logger has specified output type added to it.		 */		public static function hasOutputType(outputType:Class):Boolean		{			for(var i:int = 0;i < _outputMap.length; ++i)			{				if(_outputMap[i] is outputType) return true;			}						return false;		}		/**		 * Clears the Logger of all outputs.		 * 		 * @param destructOutputs Specifies whether the outputs are to be destructed.		 */		public static function clearOutputs(destructOutputs:Boolean = false):void		{			if(destructOutputs)			{				for(var i:int = 0;i < _outputMap.length; ++i)				{					ILoggerOutput(_outputMap[i]).destruct();				}			}						_outputMap = [];		}		/**		 * Returns a list of the outputs added to Logger		 */		public static function get outputs():Array		{			var a:Array = [];						for(var i:int = 0;i < _outputMap.length; ++i)			{				a.push(_outputMap[i]);			}						return a;		}		/**		 * Indicates the number of outputs added to Logger.		 */		public static function get numOutputs():uint		{			return _outputMap.length;		}		/**		 * @private		 */		public static function relayLogMessage(message:Object, messageType:uint):void		{				if(!enabled) return;						if(message == null) message = "null";						var output:ILoggerOutput;						var numLogOutputs:int = _outputMap.length as int;						var messageOutput:String = toLogMessage(message);						var stackTrace:StackTrace;						var stackStr:String;						var i:int;						if(numLogOutputs == 0)			{				addOutput(new TraceOutput());								relayLogMessage(message, messageType);								return;			}						try			{				throw new Error();			}			catch(e:Error)			{				stackStr = e.getStackTrace();								stackTrace = new StackTrace();								stackTrace.entries.splice(0, 3);								var t:StackTraceEntry;								var rawTraces:Array = stackStr.split("\n");								rawTraces.splice(0, 3);								for(i = 0;i < rawTraces.length; ++i)				{					t = new StackTraceEntry();					t.parseTrace(rawTraces[i] as String);										stackTrace.addTrace(t);				}			}						for(i = 0;i < numLogOutputs; ++i)			{				output = _outputMap[i] as ILoggerOutput;								output.send(new LogMessage(messageOutput, messageType, stackTrace));			}		}		private static function toLogMessage(message:Object):String		{			var output:String;						if(message is String)			{				output = message as String;			}			else if(message["toString"] != null)			{				output = message.toString();			}			else			{				output = stringify(message);			}						return output;		}	}}