/**
 * @version 1.0
 * @author David Dahlstroem | daviddahlstroem.com
 * 
 * 
 * Copyright (c) 2010 David Dahlstroem | daviddahlstroem.com
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
 
package org.tractionas3.display.behaviors 
{
	import org.tractionas3.core.CoreObject;
	

	import flash.display.DisplayObject;

	public class Behavior extends CoreObject implements IBehavior 
	{
		/** @private */
		protected var targets:Array;
		
		public function Behavior()
		{
			super();
			
			targets = [];
		}
		
		public function apply(target:DisplayObject):void
		{
			targets.push(target);
		}
		
		public function isAppliedTo(target:DisplayObject):Boolean
		{
			return targets.indexOf(target) > -1;
		}
		
		public function release(target:DisplayObject):void
		{
			if(!isAppliedTo(target)) return;
			
			targets.splice(targets.indexOf(target), 1);
		}
		
		final public function releaseAll():void
		{
			if(targets.length == 0) return;
			
			release(targets[0]);
			
			releaseAll();
		}
		
		override public function destruct(deepDestruct:Boolean = false):void
		{
			super.destruct(deepDestruct);
			
			releaseAll();
			
			targets = null;
		}
	}
}
