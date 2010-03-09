package org.tractionas3.display 
{
	import org.tractionas3.display.DraggableSprite;

	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ThrowableSprite is a DraggableSprite with throwing functionality.
	 * 
	 * @see org.tractionas3.display.DraggableSprite;
	 */
	public class ThrowableSprite extends DraggableSprite 
	{
		/**
		 * Specifies the friction multiplier adding resistance to the ThrowableSprite motion.
		 */
		public var frictionMultiplier:Number = 0.9;

		/**
		 * Specifies whether throwing is enabled
		 */
		public var throwEnabled:Boolean = true;

		private var _currentPosition:Point;

		private var _throwVelocity:Point;

		/**
		 * Creates a new ThrowableSprite object.
		 */
		public function ThrowableSprite(bounds:Rectangle = null)
		{
			super(bounds);
			
			_currentPosition = new Point(0, 0);
			
			_throwVelocity = new Point(0, 0);
		}

		/**
		 * @inheritDoc
		 */
		final override public function render():void
		{	
			if(dragging)
			{
				lastPosition.x = _currentPosition.x;
				
				lastPosition.y = _currentPosition.y;
				
				_currentPosition.x = x;
				
				_currentPosition.y = y;
				
				_throwVelocity.x = _currentPosition.x - lastPosition.x;
				
				_throwVelocity.y = _currentPosition.y - lastPosition.y;
			}
			else
			{
				_throwVelocity.x *= frictionMultiplier;
				
				_throwVelocity.y *= frictionMultiplier;
			}
			
			if(!throwEnabled)
			{
				_throwVelocity.x = 0;
				
				_throwVelocity.y = 0;
			}
			
			super.render();
		}

		/**
		 * @private
		 */
		override public function invertVelocityX(multiplier:Number = 1):void
		{
			super.invertVelocityX();
			
			_throwVelocity.x *= multiplier;
			_throwVelocity.x *= -1;
		}

		/**
		 * @private
		 */
		override public function invertVelocityY(multiplier:Number = 1):void
		{
			super.invertVelocityY();
			
			_throwVelocity.y *= multiplier;
			_throwVelocity.y *= -1;
		}

		/**
		 * @inheritDoc
		 */
		override public function get velocityX():Number
		{
			return super.velocityX + _throwVelocity.x;
		}

		/**
		 * @inheritDoc
		 */
		override public function get velocityY():Number
		{
			return super.velocityY + _throwVelocity.y;
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct(deepDestruct:Boolean = false):void
		{
			dragEnabled = false;
			
			stopRender();
			
			super.destruct(deepDestruct);
			
			bounceFrictionMultiplier = NaN;
			
			frictionMultiplier = NaN;
			
			_currentPosition = null;
			
			_throwVelocity = null;
		}

		override protected function handleMouseDown(e:MouseEvent = null):void
		{
			applyVelocity = false;
			
			super.handleMouseDown(e);
		}

		override protected function handleMouseUp(e:MouseEvent = null):void
		{
			applyVelocity = true;
			
			super.handleMouseUp(e);
		}
	}
}
