package org.tractionas3.display.behaviors 
{
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;

	import org.tractionas3.core.interfaces.IRenderable;
	import org.tractionas3.events.EnterFrame;

	import flash.geom.Point;
	public class DragAndThrowBehavior extends DragAndDropBehavior implements IRenderable
	{
		public var  frictionMultiplier:Number = 0.95;

		private var _references:Dictionary;

		private var _lastPosition:Point;

		private var _currentPosition:Point;

		private var _throwVelocity:Point;

		public function DragAndThrowBehavior()
		{
			super();
			
			_currentPosition = new Point();
			
			_throwVelocity = new Point();
			
			_lastPosition = new Point();
			
			_references = new Dictionary(true);
			
			startRender();
		}

		override protected function handleMouseMove():void
		{
			super.handleMouseMove();
		}

		override protected function handleMouseDown():void
		{
			super.handleMouseDown();
		}

		override protected function handleMouseUp():void
		{
			_references[currentTarget] = _throwVelocity.clone();
			
			super.handleMouseUp();
		}

		public function render():void
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
			
			var throwVelocity:Point;
		
			for(var key:Object in _references)
			{
				target = key as DisplayObject;
				
				throwVelocity = _references[key] as Point;
				
				
				target.x += throwVelocity.x;
				
				target.y += throwVelocity.y;
				
				
				throwVelocity.x *= frictionMultiplier;
				
				throwVelocity.y *= frictionMultiplier;
				
				
				if(dragBounds)
				{
					if(!dragBounds.containsPoint(new Point(target.x, target.y)))
					{
						if(target.x <= dragBounds.left)
						{
							target.x = dragBounds.left;
							
							throwVelocity.x *= -1;
						}
					
						else if(target.x >= dragBounds.right)
						{
							target.x = dragBounds.right;
							
							throwVelocity.x *= -1;
						}
				
						if(target.y <= dragBounds.top)
						{
							target.y = dragBounds.top;
							
							throwVelocity.y *= -1;
						}
					
						else if(target.y >= dragBounds.bottom)
						{
							target.y = dragBounds.bottom;
							
							throwVelocity.y *= -1;
						}
					}
				}
			}
		}

		public function get rendering():Boolean
		{
			return EnterFrame.hasEnterFrameHandler(render);
		}

		public function startRender():void
		{
			EnterFrame.addEnterFrameHandler(render);
		}

		public function stopRender():void
		{
			EnterFrame.removeEnterFrameHandler(render);
		}
	}
}


