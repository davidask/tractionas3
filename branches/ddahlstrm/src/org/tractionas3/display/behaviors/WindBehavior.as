package org.tractionas3.display.behaviors 
{
	import flash.geom.Point;
	public class WindBehavior extends MotionBehavior 
	{
		public var windX:Number = 10;
		
		public var windY:Number = 1;
		
		public function WindBehavior()
		{
			super();
		}
		
		override public function render():void
		{
			var point:Point;
			
			for(var reference:Object in velocityReferences)
			{
				point = velocityReferences[reference] as Point;
				
				point.x += windX;
				
				point.y += windY;
			}
			
			super.render();
		}
	}
}
