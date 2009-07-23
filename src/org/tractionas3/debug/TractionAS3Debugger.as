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
	import org.tractionas3.core.interfaces.Connectable;
	import org.tractionas3.events.LocalConnectionDataEvent;
	import org.tractionas3.events.TractionAS3DebuggerEvent;
	import org.tractionas3.events.WeakEventDispatcher;
	import org.tractionas3.net.LocalConnectionInbound;
	import org.tractionas3.net.LocalConnectionOutbound;
	import org.tractionas3.profiler.BandwidthProfiler;
	import org.tractionas3.profiler.FPSProfiler;
	import org.tractionas3.profiler.MemoryProfiler;
	import org.tractionas3.reflection.ClassDescriptor;
	import org.tractionas3.reflection.MethodDescriptor;
	import org.tractionas3.reflection.ParameterDescriptor;
	import org.tractionas3.reflection.PropertyDescriptor;

	import flash.display.Stage;
	import flash.events.TimerEvent;
	import flash.net.registerClassAlias;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	/**
	 * TractionAS3Debugger is used to communicate with the TractionAS3 Debugger application.
	 */	
	public class TractionAS3Debugger extends WeakEventDispatcher implements Connectable
	{
		/*
		 * Commands
		 */
		
		/** @private */
		public static const COMMAND_LOG:String = "command_log";

		/** @private */
		public static const COMMAND_CONNECT:String = "command_connect";

		/** @private */
		public static const COMMAND_PROFILE:String = "command_profile";

		/** @private */
		public static const COMMAND_INSPECT:String = "command_inspect";

		/** @private */
		public static const COMMAND_HELLO:String = "command_hello";

		/** @private */
		public static const COMMAND_ASSIGN_SLIDER:String = "command_asign_slider";

		/*
		 * Responses
		 */
		
		/** @private */
		public static const RESPONSE_CONNECT:String = "response_connect";

		/** @private */
		public static const RESPONSE_DISCONNECT:String = "response_disconnect";

		/** @private */
		public static const RESPONSE_CHANGE_PROPERTY:String = "response_change_property";

		/** @private */
		public static const RESPONSE_HELLO_REQUEST:String = "response_hello";

		/*
		 * Aliases
		 */
		 
		/** @private */
		public static const ALIAS_PROPERTY_DESCRIPTOR:String = "org.tractionas3.reflection.PropertyDescriptor";

		/** @private */
		public static const ALIAS_METHOD_DESCRIPTOR:String = "org.tractionas3.reflection.MethodDescriptor";

		/** @private */
		public static const ALIAS_PARAMETER_DESCRIPTOR:String = "org.tractionas3.reflection.ParameterDescriptor";

		/** @private */
		public static const ALIAS_CLASS:String = "topLevel.Class"; 

		/*
		 * General
		 */

		/** @private */
		public static const VERSION:String = "1.08";

		/** @private */
		public static const INBOUND:String = "_tractionAS3InboundConnection";

		/** @private */
		public static const OUTBOUND:String = "_tractionAS3OutboundConnection";

		/**
		 * Specifies, in seconds, the connection timeout
		 */
		public static var CONNECTION_TIMEOUT:uint = 5;

		/**
		 * Specifies the number of connection attempts to to be made to the debugger.
		 */
		public static var CONNECTION_ATTEMPTS:uint = 3;

		/**
		 * Specifies allowed domain.
		 */
		public static const ALLOWED_DOMAIN:String = "*";

		private static var _instance:TractionAS3Debugger;

		/**
		 * Specifies whether the debugger connector is enabled
		 */
		public var enabled:Boolean = true;


		private var _objectInspectMap:Dictionary;

		private var _objectInspectMapKeyNum:uint;

		private var _objectInspectMapKeyPrefix:String = "objectReference_";


		private var _propertySliderReferenceMap:Dictionary;
		
		private var _propertySliderReferenceMapKeyNum:uint;
		
		private var _propertySliderReferenceMapPrefix:String = "propertySlider_";
		

		private var _buffer:Array;


		private var _inbound:LocalConnectionInbound;

		private var _outbound:LocalConnectionOutbound;


		private var _fpsProfiler:FPSProfiler;

		private var _memoryProfiler:MemoryProfiler;

		private var _bandwidthProfiler:BandwidthProfiler;

		private var _profilerTimer:Timer;

		private var _profilerTargetStage:Stage;


		private var _connected:Boolean;

		private var _connecting:Boolean;

		private var _connectTimeout:uint;

		private var _numConnectionAttempts:uint;

		/**
		 * Attempts to connect to TractionAS3 Debugger.
		 */
		public static function connect():void
		{
			getInstance().connect();
		}

		/**
		 * Disconnects from TractionAS3 Debugger.
		 */
		public static function disconnect():void
		{
			getInstance().disconnect();
		}

		/**
		 * Indicates whether a connection has been established with the TractionAS3 Debugger.
		 */
		public static function get connected():Boolean
		{
			return getInstance().connected;
		}

		/**
		 * Starts profiling of the application.
		 * 
		 * @param stage Specified stage accociated with the profiling.
		 */
		public static function startProfiler(stage:Stage):void
		{
			getInstance()._profilerTargetStage = stage;
			
			getInstance()._profilerTimer.start();
			
			getInstance()._fpsProfiler.start();
		}

		/**
		 * Stops profiling of the application.
		 */
		public static function stopProfiler():void
		{
			getInstance()._profilerTimer.stop();
			
			getInstance()._fpsProfiler.stop();
		}

		/**
		 * Sends the specified object to TractionAS3 Debugger and allows for live modifying of its properties.
		 * 
		 * @param target Object to be inspected
		 * @param label Label of the inspected object (shown in the TractionAS3 Debugger inspector window).
		 */
		public static function inspect(target:Object, label:String):void
		{
			getInstance().sendInspectMessage(target, label);
		}

		public static function assignPropertySlider(target:Object, label:String, minValue:Number, maxValue:Number):void
		{
			getInstance().sendPropertySliderMessage(target, label, minValue, maxValue);
		}

		/**
		 * Sends a log message to TractionAS3 Debugger.
		 */
		public static function sendLogMessage(message:String, origin:String, line:int, level:uint):Boolean
		{
			return getInstance().sendLogMessage(message, origin, line, level);
		}

		private static function getInstance():TractionAS3Debugger
		{
			if(!_instance) _instance = new TractionAS3Debugger(new SingletonEnforcer());
			
			return _instance;
		}

		/**
		 * @private
		 */
		public function TractionAS3Debugger(singletonEnforcer:SingletonEnforcer)
		{
			super(this);
			
			if(!singletonEnforcer)
			{
				throw new Error("TractionAS3Debugger is a singleton and may only be accessed via its accessor getInstance().");
				
				return;
			}

			_buffer = [];

			setupLocalConnections();
			
			setupProfilers();
			
			registerClassAliases();
		}

		/**
		 * @private
		 */
		public function connect():void
		{
			if(connected == true || _connecting == true) return;
			
			_connectTimeout = setTimeout(connectFailure, CONNECTION_TIMEOUT * 1000);
			
			var success:Boolean = false;
			
			log("Attempting to connect to TractionAS3 Debugger...", LogLevel.TRACTIONAS3);
			
			try
			{
				_inbound.connect();
				
				success = true;
			}
			catch(e:Error)
			{
				log(e.toString(), LogLevel.TRACTIONAS3);
			}
			
			if(success)
			{
				sendConnectMessage();
			}
		}

		/**
		 * @private
		 */
		public function disconnect():void
		{
			try
			{
				_inbound.disconnect();	
			}
			catch(e:Error)
			{
				/* Do nothing */
			}
		}

		/**
		 * @private
		 */
		public function get connected():Boolean
		{
			return _connected;
		}

		private function connectFailure():void
		{
			var message:String;
			
			if(_numConnectionAttempts < CONNECTION_ATTEMPTS - 1)
			{
				message = "Unable to connect to TractionAS3 Debugger. The application may not be running. Retrying(" + (_numConnectionAttempts + 1) + ") in 5 seconds...";
			}
			else
			{
				message = "Failed to connect to TractionAS3 Debugger after " + CONNECTION_ATTEMPTS + " attempts. Clearing buffer.";
			}
		
			log(message, LogLevel.TRACTIONAS3);
			
			disconnect();
			
			if(!_numConnectionAttempts) _numConnectionAttempts = 0;
			
			_numConnectionAttempts++;
			
			if(_numConnectionAttempts >= CONNECTION_ATTEMPTS)
			{
				_numConnectionAttempts = 0;
				
				_buffer = []; //Empty buffer
			}
			else
			{
				setTimeout(connect, 5000);
			}
		}

		/**
		 * @private
		 */
		private function sendLogMessage(message:String, origin:String, line:int, level:uint):Boolean
		{
			return send({ command: COMMAND_LOG, timestamp: new Date(), message: { text: message, origin: origin, line: line, level: level, time: new Date() } });
		}

		private function sendConnectMessage():void
		{
			_outbound.send({ command: COMMAND_CONNECT, version: VERSION, timestamp: new Date() });
		}

		private function sendProfilingData():void
		{
			send({ command: COMMAND_PROFILE, stage: _profilerTargetStage, fpsCurrent: _fpsProfiler.currentFPS, fpsAverage: _fpsProfiler.averageFPS, currentMemory: _memoryProfiler.currentMemory, peakMemory: _memoryProfiler.peakMemory, bandwidthCurrent: _bandwidthProfiler.bytesPerSecond, timestamp: new Date() });
		}

		private function sendHelloMessage():void
		{
			send({ command: COMMAND_HELLO, message: "Still here!", timestamp: new Date() });
		}

		private function sendInspectMessage(target:Object, label:String):void
		{
			var propertyValues:Array = [];
			
			var properties:Array = ClassDescriptor.getProperties(target);
			
			var validProperties:Array = [];
			
			var propertyDescriptor:PropertyDescriptor;
			
			var propertyReadSuccess:Boolean;
			
			for(var i:int = 0;i < properties.length; ++i)
			{
				propertyDescriptor = properties[i] as PropertyDescriptor;
				
				propertyReadSuccess = true;
				
				/*
				 * Try to read the property.
				 * If an error is thrown, the property isn't really readable and should not be passed.
				 */
				try
				{
					(target[propertyDescriptor.name] != null);
				}
				catch(e:Error)
				{
					propertyReadSuccess = false;
					
					log("Could not pass property " + "\"" + propertyDescriptor.name + "\" to TractionAS3 Debugger. Error: " + e.toString(), LogLevel.TRACTIONAS3);
				}
				
				/*
				 * Pass the property as valid.
				 */
				if(propertyReadSuccess)
				{
					validProperties.push(propertyDescriptor);
					
					propertyValues.push(target[propertyDescriptor.name]);
				}
			}
			
			send({ command: COMMAND_INSPECT, label: label, target: getObjectInspectReference(target), methods: ClassDescriptor.getMethods(target), properties: validProperties, propertyValues: propertyValues });
		}

		private function sendPropertySliderMessage(target:Object, label:String, minValue:Number, maxValue:Number):void
		{
			var type:Class;
			
			switch(true)
			{
				case target is Number:
					
					type = Number;
					
					break;
				
				case target is int:
				
					minValue = int(minValue);
					
					maxValue = int(maxValue);
					
					type = int;
					
					break;
					
				case target is uint:
						
					minValue = uint(Math.max(0, minValue));
						
					maxValue = uint(maxValue);
					
					type = uint;
					
					break;
					
				default:
				
					return;
				
					break;
					
				send({ command: COMMAND_ASSIGN_SLIDER, label: label, target: getPropertySliderReference(target), type: type });
			}
		}

		private function send(dataObject:Object):Boolean
		{
			if(!_connected)
			{
				_buffer.push(dataObject);
				
				return false;
			}
			
			return _outbound.send(dataObject);
		}

		private function setupLocalConnections():void
		{	
			_inbound = new LocalConnectionInbound(INBOUND);
			
			_inbound.allowDomain(ALLOWED_DOMAIN);
			
			_inbound.addEventListener(LocalConnectionDataEvent.DATA_RECEIVE, onReceiveData);
			
			_outbound = new LocalConnectionOutbound(OUTBOUND);
			
			_connected = false;
			
			_connecting = false;
		}

		private function setupProfilers():void
		{
			_profilerTimer = new Timer(300);
			
			_profilerTimer.addEventListener(TimerEvent.TIMER, onProfilerTick);
			
			_fpsProfiler = new FPSProfiler(10);
	
			_memoryProfiler = new MemoryProfiler();
			
			_bandwidthProfiler = BandwidthProfiler.getInstance();
		}

		private function registerClassAliases():void
		{
			registerClassAlias(ALIAS_PROPERTY_DESCRIPTOR, PropertyDescriptor);
			
			registerClassAlias(ALIAS_METHOD_DESCRIPTOR, MethodDescriptor);
			
			registerClassAlias(ALIAS_PARAMETER_DESCRIPTOR, ParameterDescriptor);
			
			registerClassAlias(ALIAS_CLASS, Class);
		}

		private function onProfilerTick(e:TimerEvent):void
		{
			sendProfilingData();
		}

		private function createObjectInspectMap():void
		{
			_objectInspectMap = new Dictionary(true);
			
			_objectInspectMapKeyNum = 0;
		}
		
		private function createPropetySliderReferenceMap():void
		{
			_propertySliderReferenceMap = new Dictionary(true);
			
			_propertySliderReferenceMapKeyNum = 0;
		}

		private function getObjectInspectReference(target:Object):String
		{
			if(!_objectInspectMap) createObjectInspectMap();
			
			for(var existingKey:String in _objectInspectMap)
			{
				if(_objectInspectMap[existingKey] == target) return existingKey;
			}
			
			var key:String = (_objectInspectMapKeyPrefix + _objectInspectMapKeyNum++).toString();
			
			_objectInspectMap[key] = target;
			
			return key;
		}
		
		private function getPropertySliderReference(target:Object):String
		{
			if(!_propertySliderReferenceMap) createPropetySliderReferenceMap();
			
			for(var existingKey:String in _propertySliderReferenceMap)
			{
				if(_propertySliderReferenceMap[existingKey] == target) return existingKey;
			}
			
			var key:String = (_propertySliderReferenceMapPrefix + _propertySliderReferenceMapKeyNum++).toString();
			
			_propertySliderReferenceMapPrefix[key] = target;
			
			return key;
		}

		private function setPropertyValue(target:String, property:String, value:*):void
		{
			var propertyChangeTarget:Object;
			
			if(_objectInspectMap[target])
			{
				propertyChangeTarget = _objectInspectMap[target] as Object;
				
				try
				{
					propertyChangeTarget[property] = value;
				}
				catch(e:Error)
				{
					/* An error occured when trying to set a property. Ignore and carry on. */
				}
			}
		}

		private function onReceiveData(e:LocalConnectionDataEvent):void
		{
			var command:String = e.data["command"] as String;
			
			var message:String = e.data["message"] as String;
			
			switch(command)
			{
				case RESPONSE_CONNECT:
					
					_connected = true;
					
					_connecting = false;
					
					clearTimeout(_connectTimeout);
						
					dispatchEvent(new TractionAS3DebuggerEvent(TractionAS3DebuggerEvent.CONNECT));
					
					for(var i:int = 0;i < _buffer.length; ++i)
					{
						send(_buffer[i]);
					}
					
					_buffer = [];
					
					log("Sucessfully connected to TractionAS3 Debugger. Response message: " + message, LogLevel.TRACTIONAS3);
					
					break;
				
				case RESPONSE_DISCONNECT:
				
					_connected = false;
					
					dispatchEvent(new TractionAS3DebuggerEvent(TractionAS3DebuggerEvent.DISCONNECT));
					
					log("TractionAS3Debugger debugger disconnected. Response message: " + message, LogLevel.TRACTIONAS3);
					
					break;
					
				case RESPONSE_CHANGE_PROPERTY:
					
					setPropertyValue(e.data["target"], e.data["property"], e.data["value"]);
					
					break;
					
				case RESPONSE_HELLO_REQUEST:
					
					sendHelloMessage();
					
					break;
			}
		}
	}
}

internal class SingletonEnforcer 
{
}
