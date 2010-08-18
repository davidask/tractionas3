package org.tractionas3.display.behaviors 
{
	import org.tractionas3.core.interfaces.IRenderable;

	import flash.geom.Point;
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
			
			if(reference)
			{
				reference.x += _throwVelocity.x;
			
				reference.y += _throwVelocity.y;
			}
			
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
			
			super.render();
		}
	}
}


