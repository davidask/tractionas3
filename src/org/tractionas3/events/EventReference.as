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

package org.tractionas3.events 
{
	import org.tractionas3.core.CoreObject;
	import org.tractionas3.core.interfaces.ICoreInterface;
	public class EventReference extends CoreObject implements ICoreInterface 
	{

		private var _type:String;

		private var _listener:Function;

		private var _useCapture:Boolean;

		
		public function EventReference(type:String,listener:Function, useCapture:Boolean)
		{
			super();
			
			_type = type;
			
			_listener = listener;
			
			_useCapture = useCapture;
		}

		public function get type():String
		{
			return _type;
		}

		public function get listener():Function
		{
			return _listener;
		}

		public function get useCapture():Boolean
		{
			return _useCapture;
		}

		override public function destruct(deepDestruct:Boolean = false):void
		{
			_type = null;
			
			_listener = null;
			
			super.destruct(deepDestruct);
		}
	}
}
