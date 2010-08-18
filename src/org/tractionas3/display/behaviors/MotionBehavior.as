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
		protected var currentTarget:DisplayObject;

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
				
				if(!velocityReferences[target])
				{
					velocityReferences[target] = new Point();
				}
				
				velocity = velocityReferences[target] as Point;
				
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
