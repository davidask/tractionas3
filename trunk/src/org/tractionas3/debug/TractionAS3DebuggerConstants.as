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
 
package org.tractionas3.debug 
{
	/**
	 * TractionAS3DebuggerConstants holds constants for communication with TractionAS3 Debugger.
	 */
	public class TractionAS3DebuggerConstants 
	{

		public static const INBOUND:String = "_tractionAS3InboundConnection";

		public static const OUTBOUND:String = "_tractionAS3OutboundConnection";

		public static const COMMAND_LOG:String = "command_log";

		public static const COMMAND_CONNECT:String = "command_connect";

		public static const COMMAND_PROFILE:String = "command_profile";

		public static const COMMAND_INSPECT:String = "command_inspect";

		public static const COMMAND_INSPECT_UPDATE:String = "command_inspect_update"; //Yet to be implemented

		public static const COMMAND_HELLO:String = "command_hello";

		public static const RESPONSE_CONNECT:String = "response_connect";

		public static const RESPONSE_DISCONNECT:String = "response_disconnect";

		public static const RESPONSE_CHANGE_PROPERTY:String = "response_change_property";

		public static const RESPONSE_REQUEST_INSPECT_UPDATE:String = "response_request_inspect_update"; //Yet to be implemented

		public static const RESPONSE_HELLO_REQUEST:String = "response_hello";

		public static const ALIAS_PROPERTY_DESCRIPTOR:String = "org.tractionas3.reflection.PropertyDescriptor";

		public static const ALIAS_METHOD_DESCRIPTOR:String = "org.tractionas3.reflection.MethodDescriptor";

		public static const ALIAS_PARAMETER_DESCRIPTOR:String = "org.tractionas3.reflection.ParameterDescriptor";
	}
}
