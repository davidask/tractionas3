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

package org.tractionas3.utils 
{
	import flash.system.Capabilities;
	public class FlashPlayer 
	{
		public static function get debugger():Boolean
		{
			return Capabilities.isDebugger;
		}
		public static function get version():Version
		{
			var vstr:String = Capabilities.version;
			
			var strarr:Array = vstr.split(" ");
			
			var varr:Array = String(strarr[1]).split(",");
			
			var major:uint = parseInt(varr[0]);
			
			var minor:uint = parseInt(varr[1]);
			
			var build:uint = parseInt(varr[2]);
			
			var internalBuild:uint = parseInt(varr[3]);
			
			return new Version(major, minor, build, internalBuild);		}
		public static function get pluginPlayer():Boolean
		{
			if(Capabilities.playerType == "PlugIn")return true;
			return false;
		}
		public static function get activeX():Boolean
		{
			if(Capabilities.playerType == "ActiveX")return true;
			return false;
		}
		public static function get standAlone():Boolean
		{
			if(Capabilities.playerType == "StandAlone") return true;
			return false;
		}
		public static function get IDE():Boolean
		{
			if(Capabilities.playerType == "External") return true;
			return false;
		}
		public static function get runningOnPC():Boolean
		{
			var v:String = String(Capabilities.version).toLowerCase();
			return (v.indexOf("win") > -1);
		}
		public static function get runninOnMac():Boolean
		{
			var v:String = String(Capabilities.version).toLowerCase();
			return (v.indexOf("mac") > -1);
		}       
		public static function get runningOnLinux():Boolean
		{
			var v:String = String(Capabilities.version).toLowerCase();
			return (v.indexOf("linux") > -1);
		}
	}}