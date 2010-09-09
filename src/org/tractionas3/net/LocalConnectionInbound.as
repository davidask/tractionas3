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

package org.tractionas3.net 
{
	import org.tractionas3.core.interfaces.IDestructable;
	import org.tractionas3.debug.LogLevel;
	import org.tractionas3.events.LocalConnectionDataEvent;
	import org.tractionas3.events.WeakEventDispatcher;

	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.SecurityErrorEvent;
	import flash.events.StatusEvent;
	import flash.net.LocalConnection;
	import flash.utils.ByteArray;

	public class LocalConnectionInbound extends WeakEventDispatcher implements IDestructable
	{
		internal static const RECEIVE_METHOD:String = "receiveData";

		private var _connectionName:String;

		private var _localConnection:LocalConnection;

		private var _buffer:Array;

		public function LocalConnectionInbound(connectionName:String)
		{
			super(this);
			
			_connectionName = connectionName;
			
			setupLocalConnection();
		}

		public function get connectionName():String
		{
			return _connectionName;
		}

		public function allowDomain(...args:Array):void
		{
			_localConnection.allowDomain.apply(null, args);
		}

		public function connect():Boolean
		{
			try
			{
				_localConnection.connect(connectionName);
			}
			catch(e:Error)
			{
				return false;
			}
			
			return true;
		}

		public function disconnect():Boolean
		{
			try
			{
				_localConnection.close();	
			}
			catch(e:Error)
			{
				return false;
			}
			
			return true;
		}

		override public function destruct(deepDestruct:Boolean = false):void
		{
			disconnect();
			
			_buffer = null;
			
			_connectionName = null;
			
			super.destruct(deepDestruct);
			
			_localConnection = null;
		}

		public function receiveData(data:Object):void
		{	
			if(data["packageIndex"] == 1 && data["totalPackages"] == 1)
			{
				processPackages([data]);
				return;
			}
			
			if(data["packageIndex"] == 1)
			{
				_buffer = [];
				
				_buffer.push(data);
			}
			else if(data["packageIndex"] == data["totalPackages"])
			{
				_buffer.push(data);
				
				processPackages(_buffer);
			}
			else
			{
				_buffer.push(data);
			}
		}

		private function setupLocalConnection():void
		{
			_localConnection = new LocalConnection();
			
			setEventListeners(true);
			
			_localConnection.client = this;
		}

		private function processPackages(buffer:Array):void
		{
			var packageObject:Object;
			
			var packageData:ByteArray;
			
			var data:ByteArray;
			
			data = new ByteArray();
			
			for(var i:int = 0;i < buffer.length;++i)
			{
				packageObject = buffer[i] as Object;
				
				packageData = packageObject["data"] as ByteArray;
				
				data.writeBytes(packageData, 0, data.bytesAvailable);
			}
			
			data.uncompress();
			
			dispatchEvent(new LocalConnectionDataEvent(LocalConnectionDataEvent.DATA_RECEIVE, data.readObject()));
		}

		private function handleLocalConnectionEvents(e:Event):void
		{
			var connection:LocalConnection = e.target as LocalConnection;
			
			switch(e.type)
			{
				case AsyncErrorEvent.ASYNC_ERROR:
					
					log(connection + " Async Error: " + AsyncErrorEvent(e).error.message, LogLevel.TRACTIONAS3);
					
					break;
				
				case SecurityErrorEvent.SECURITY_ERROR:
					
					log(connection + " Security Error", LogLevel.TRACTIONAS3);
					
					break;
				
				case StatusEvent.STATUS:
				
					/* STATUS */
					break;
			}
		}

		private function setEventListeners(add:Boolean):void
		{
			var method:String = add ? "addEventListener" : "removeEventListener";
			
			_localConnection[method](AsyncErrorEvent.ASYNC_ERROR, handleLocalConnectionEvents);
			
			_localConnection[method](SecurityErrorEvent.SECURITY_ERROR, handleLocalConnectionEvents);
			
			_localConnection[method](StatusEvent.STATUS, handleLocalConnectionEvents);
		}
	}
}
