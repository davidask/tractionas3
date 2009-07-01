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
{	import org.tractionas3.core.CoreObject;
	import org.tractionas3.core.interfaces.Cloneable;
	import org.tractionas3.core.interfaces.CoreInterface;
	import org.tractionas3.reflection.stringify;
	public class Version extends CoreObject implements CoreInterface, Cloneable 
	{
		public var major:uint;

		public var minor:uint;

		public var build:uint;

		public var internalBuild:uint;

		
		public function Version(mav:uint = 0, miv:uint = 0, b:uint = 0, ib:uint = 0)
		{
			major = mav;
			
			minor = miv;
			
			build = b;
			
			internalBuild = ib;
		}

		public function isLaterThan(version:Version):Boolean
		{
			if(version.major > major) return true;
			
			if(version.major < major && version.minor > minor) return true;
			
			if(version.major < major && version.minor < minor && version.build > build) return true;
			
			if(version.major < major && version.minor < minor && version.build < build && version.internalBuild > internalBuild) return true;
			
			
			return false;
		}

		override public function toString():String
		{			return stringify(this) + "[major=" + major + ", minor=" + minor + ", build=" + build + ", internal build=" + internalBuild + "]";
		}

		override public function destruct(deepDestruct:Boolean = false):void
		{	
			super.destruct(deepDestruct);		}

		public function clone():Object
		{			return new Version(major, minor, build, internalBuild);
		}
	}}