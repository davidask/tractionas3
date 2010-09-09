/**
 * @version 1.0
 * @author David A
 * 
 * 
 * Copyright (c) 2010 David A
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
	import flash.display.DisplayObject;
	import flash.geom.Point;

	public class SpringBehavior extends MotionBehavior 
	{
		public var spring:Number = 0.01;
		
		public var destination:Point;
		
		public function SpringBehavior()
		{
			super();
			
			destination = new Point(200, 200);
			
			startRender();
		}
		
		override public function render():void
		{
			super.render();
			
			var target:DisplayObject;
			
			var velocity:Point;
			
			var dx:Number;
			
			var dy:Number;
			
			for(var i:int = 0;i < targets.length;i++)
			{
				target = targets[i] as DisplayObject;
				
				if(target == currentTarget)
				{
					continue;
				}
				
				dx = (destination.x - target.x) * spring;
			
				dy = (destination.y - target.y) * spring;
				
				velocity = getVelcityReferenceForTarget(target);
				
				velocity.x += dx;
				
				velocity.y += dy;
			}
		}
	}
}
