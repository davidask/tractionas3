package org.tractionas3.display.behaviors 
{
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.display.DisplayObject;
	import org.tractionas3.events.EnterFrame;
	import org.tractionas3.core.interfaces.IRenderable;
	public class MotionBehavior extends Behavior implements IRenderable 
	{
		public var friction:Number = 0.95;
		
		/** @private */
		protected var velocityReferences:Dictionary;
		
		public function MotionBehavior()
		{
			super();
			
			velocityReferences = new Dictionary(true);
			
			startRender();
		}
		
		public function render():void
		{
			var target:DisplayObject;
			
			var velocity:Point;
			
			for(var i:int = 0; i < targets.length; i++)
			{
				target = targets[i] as DisplayObject;
				
				if(!velocityReferences[target])
				{
					velocityReferences[target] = new Point();
				}
	
				velocity = velocityReferences[target] as Point;
				
				target.x += velocity.x;
				
				target.y += velocity.y;
				
				
				velocity.x *= friction;
				
				velocity.y *= friction;
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
	}
}
