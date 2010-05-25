package org.tractionas3.display.behaviors 
{
	import org.tractionas3.core.interfaces.IRenderable;

	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	public class DragAndThrowBehavior extends DragAndDropBehavior implements IRenderable
	{
		private var _lastPosition:Point;

		private var _currentPosition:Point;

		private var _throwVelocity:Point;

		public function DragAndThrowBehavior()
		{
			super();
			
			_currentPosition = new Point();
			
			_throwVelocity = new Point();
			
			_lastPosition = new Point();
			
			startRender();
		}

		override protected function handleMouseUp():void
		{
			var reference:Point = velocityReferences[currentTarget] as Point;
			
			reference.x += _throwVelocity.x;
			
			reference.y += _throwVelocity.y;
			
			super.handleMouseUp();
		}

		override public function render():void
		{
			if(dragging)
			{
				_lastPosition.x = _currentPosition.x;
				
				_lastPosition.y = _currentPosition.y;
				
				_currentPosition.x = currentTarget.x;
				
				_currentPosition.y = currentTarget.y;
				
				_throwVelocity.x = _currentPosition.x - _lastPosition.x;
				
				_throwVelocity.y = _currentPosition.y - _lastPosition.y;
			}
			
			var target:DisplayObject;
			
			var velocity:Point;
			
			for(var i:int = 0; i < targets.length; i++)
			{
				target = targets[i] as DisplayObject;
				
				velocity = velocityReferences[target];
				
				if(dragLimitsRect && velocity)
				{
					var rect:Rectangle = getDragLimitsRectForTarget(target);
					
					if(target.x <= rect.left)
					{
						target.x = rect.left;
						
						velocity.x *= -1;
					}
				
					else if(target.x >= rect.right)
					{
						target.x = rect.right;
						
						velocity.x *= -1;
					}
			
					if(target.y <= rect.top)
					{
						target.y = rect.top;
						
						velocity.y *= -1;
					}
				
					else if(target.y >= rect.bottom)
					{
						target.y = rect.bottom;
						
						velocity.y *= -1;
					}
				}
					
			}
			
			super.render();
		}
	}
}


