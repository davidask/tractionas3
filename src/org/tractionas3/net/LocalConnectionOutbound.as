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
 
package org.tractionas3.net 
{
	import org.tractionas3.core.interfaces.IDestructable;
	import org.tractionas3.debug.LogLevel;
	import org.tractionas3.debug.log;
	import org.tractionas3.events.WeakEventDispatcher;

	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.SecurityErrorEvent;
	import flash.events.StatusEvent;
	import flash.net.LocalConnection;
	import flash.utils.ByteArray;
	public class LocalConnectionOutbound extends WeakEventDispatcher implements IDestructable
	{
		public static var MAX_PACKAGE_SIZE:uint = 40000;

		private var _localConnection:LocalConnection;

		private var _connectionName:String;

		public function LocalConnectionOutbound(connectionName:String)
		{
			super(this);
			
			_connectionName = connectionName;
			
			setupLocalConnection();
		}

		public function get connectionName():String
		{
			return _connectionName;
		}

		public function get client():Object
		{
			return _localConnection.client;
		}

		public function set client(value:Object):void
		{
			_localConnection.client = value;
		}

		public function send(dataObject:Object):Boolean
		{
			var
			data:ByteArray = new ByteArray();
			
			data.writeObject(dataObject);
			
			data.compress();
			
			var dataPackages:Array = [];
			
			var i:int = 0;
			
			if(data.length > MAX_PACKAGE_SIZE)
			{
				var bytesAvailable:int = data.length;
				
				var offset:int = 0;
				
				var numPackages:int = Math.ceil(data.length / MAX_PACKAGE_SIZE);
				
				var readLength:int;
				
				var tempData:ByteArray;
				
				for(i = 0;i < numPackages;++i)
				{
					readLength = (bytesAvailable > MAX_PACKAGE_SIZE) ? MAX_PACKAGE_SIZE : bytesAvailable;
					
					tempData = new ByteArray();
					
					tempData.writeBytes(data, offset, readLength);
					
					dataPackages.push({ data: tempData, totalPackages: numPackages, packageIndex: (i + 1) });
					
					bytesAvailable -= readLength;
					
					offset += readLength;
				}
			}
			else
			{
				dataPackages.push({ data: data, totalPackages: 1, packageIndex: 1 });
			}
			
			for(i = 0;i < dataPackages.length;++i)
			{
				try
				{
					_localConnection.send(_connectionName, LocalConnectionInbound.RECEIVE_METHOD, dataPackages[i]);
				}
				catch(e:Error)
				{
					trace(e.toString());
					
					break;
					return false;
				}
			}
			
			return true;
		}

		override public function destruct(deepDestruct:Boolean = false):void
		{
			setEventListeners(false);
			
			_localConnection = null;
			
			_connectionName = null;
			
			super.destruct(deepDestruct);
		}

		private function setupLocalConnection():void
		{
			_localConnection = new LocalConnection();
			
			setEventListeners(true);
		}

		private function handleLocalConnectionEvents(e:Event):void
		{
			var connection:LocalConnection = e.target as LocalConnection;
			
			switch(e.type)
			{
				case AsyncErrorEvent.ASYNC_ERROR:
					
					log(connection + " Async Error", LogLevel.TRACTIONAS3);
					
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
