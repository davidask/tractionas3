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
