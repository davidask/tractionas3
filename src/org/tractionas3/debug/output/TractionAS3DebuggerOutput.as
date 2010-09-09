/**
 * @version 1.0
 * @author David A
 * 
 * 
 * Copyright (c) 2009 David A
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
 
package org.tractionas3.debug.output 
{
	import org.tractionas3.core.CoreObject;
	import org.tractionas3.debug.LogMessage;
	import org.tractionas3.debug.StackTraceEntry;
	import org.tractionas3.debug.TractionAS3Debugger;

	/**
	 * TractionAS3DebuggerOutput allows you to relay debug messages to the TractionAS3 Debugger log console.
	 * 
	 *
	 * @see org.tractionas3.debugger.TractionAS3Debugger
	 * @see org.tractionas3.debug.Logger
	 * @see org.tractionas3.debug.Logger#addOutput()
	 */
	public class TractionAS3DebuggerOutput extends CoreObject implements ILoggerOutput 
	{
		/**
		 * Creates a new TractionAS3DebuggerOutput object.
		 */
		public function TractionAS3DebuggerOutput()
		{
			super();
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct(deepDestruct:Boolean = false):void
		{
			super.destruct(deepDestruct);
		}

		/**
		 * @inheritDoc
		 */
		public function send(message:LogMessage):void
		{
			var stackTrace:StackTraceEntry = message.stackTrace.entries[message.stackTrace.entries.length - 1];
			
			var classNameSplit:Array = stackTrace.className.split(".");
			
			var className:String = classNameSplit[classNameSplit.length - 1];
			
			TractionAS3Debugger.sendLogMessage(message.text, className + "." + stackTrace.methodName, stackTrace.line, message.level);
		}
	}
}
