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
	import org.tractionas3.core.interfaces.IRenderable;
	import org.tractionas3.events.EnterFrame;

	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	public class MotionBehavior extends Behavior implements IRenderable 
	{
		public var friction:Number = 0.95;

		public var bounceOffMotionLimits:Boolean = true;

		public var bounceFriction:Number = 0.6;

		/** @private */
		protected static var currentTarget:DisplayObject;

		/** @private */
		protected var velocityReferences:Dictionary;

		/** @private */
		protected var motionLimitsRect:Rectangle;

		/** @private */
		protected var motionLimitsScope:DisplayObject;

		public function MotionBehavior()
		{
			super();
			
			velocityReferences = new Dictionary(true);
		}

		public function setMotionLimits(limits:Rectangle, scope:DisplayObject):void
		{
			motionLimitsRect = limits;
			
			motionLimitsScope = scope;
		}

		public function getVelocityByObject(target:DisplayObject):Point
		{
			return velocityReferences[target] as Point || new Point();
		}

		public function getMotionLimitsRect():Rectangle
		{
			return motionLimitsRect.clone();
		}

		public function getMotionLimitsScope():DisplayObject
		{
			return motionLimitsScope;
		}

		public function copyMotionLimitsFrom(otherBehavior:MotionBehavior):void
		{
			setMotionLimits(otherBehavior.getMotionLimitsRect(), otherBehavior.getMotionLimitsScope());
		}

		public function render():void
		{
			var target:DisplayObject;
			
			var velocity:Point;
		
			for(var i:int = 0;i < targets.length;i++)
			{
				target = targets[i] as DisplayObject;
				
				if(target == currentTarget)
				{
					continue;
				}
				
				velocity = getVelcityReferenceForTarget(target);
				
				target.x += velocity.x;
				
				target.y += velocity.y;
				
				
				velocity.x *= friction;
				
				velocity.y *= friction;
				
				
				if(motionLimitsRect)
				{
					var rect:Rectangle = getDragLimitsRectForTarget(target);
					
					if(target.x <= rect.left)
					{
						target.x = rect.left;
						
						if(bounceOffMotionLimits)
						{
							velocity.x *= -1;
							
							velocity.x *= bounceFriction;
						}
					}
				
					else if(target.x >= rect.right)
					{
						target.x = rect.right;
						
						if(bounceOffMotionLimits)
						{
							velocity.x *= -1;
							
							velocity.x *= bounceFriction;
						}
					}
			
					if(target.y <= rect.top)
					{
						target.y = rect.top;
						
						if(bounceOffMotionLimits)
						{
							velocity.y *= -1;
							
							velocity.y *= bounceFriction;
						}
					}
				
					else if(target.y >= rect.bottom)
					{
						target.y = rect.bottom;
						
						if(bounceOffMotionLimits)
						{
							velocity.y *= -1;
							
							velocity.y *= bounceFriction;
						}
					}
				}
			}
		}

		public function startRender():void
		{
			EnterFrame.addEnterFrameHandler(render);
		}

		public function stopRender():void
		{
			EnterFrame.removeEnterFrameHandler(render);
		}

		public function get rendering():Boolean
		{
			return EnterFrame.hasEnterFrameHandler(render);
		}

		override public function destruct(deepDestruct:Boolean = false):void
		{
			stopRender();
			
			super.destruct(deepDestruct);
		}

		/** @private */
		protected function getVelcityReferenceForTarget(target:DisplayObject):Point
		{
			var point:Point;
			
			if(!velocityReferences[target])
			{
				point = new Point();
				
				velocityReferences[target] = point;
			}
			else
			{
				point = velocityReferences[target];
			}
			
			return point;
		}

		/** @private */
		protected function getDragLimitsRectForTarget(target:DisplayObject):Rectangle
		{
			var scopeGlobalPosition:Point = motionLimitsScope.localToGlobal(new Point());
				
				
			var globalRect:Rectangle = motionLimitsRect.clone();
				
			globalRect.offsetPoint(scopeGlobalPosition);
				
				
			var targetParentLocalPosition:Point = target.parent.globalToLocal(new Point(globalRect.x, globalRect.y));
				
				
			var localRect:Rectangle = motionLimitsRect.clone();
				
			localRect.offsetPoint(targetParentLocalPosition);
				
				
			return localRect;
		}
	}
}
