package org.tractionas3.monitor 
{
	import org.tractionas3.core.Application;
	import org.tractionas3.core.CoreObject;
	import org.tractionas3.core.interfaces.ICloneable;
	import org.tractionas3.core.interfaces.ICoreInterface;
	import org.tractionas3.core.interfaces.IRunnable;
	import org.tractionas3.events.EnterFrame;

	import flash.display.DisplayObject;
	import flash.geom.Point;
	/**
	 * MouseMonitor is used to monitor mouse activity.
	 */
	public class MouseMonitor extends CoreObject implements ICoreInterface, ICloneable, IRunnable 
	{
		public var scope:DisplayObject;

		private var _mouseLastPosition:Point;

		private var _mousePosition:Point;

		private var _mouseVelocity:Point;

		/**
		 * Creates a new MouseMonitor object.
		 * @param scope The scope in which the mouse is to be monitored
		 */
		public function MouseMonitor(scope:DisplayObject = null)
		{
			scope = scope || Application.stage;
			
			if(!Application.stage)
			{
				throw new Error("Parameter scope cannot be undefined as Application.stage is not defined.");
				return;
			}
			
			_mouseLastPosition = new Point(0, 0);
			
			_mousePosition = new Point(0, 0);
		}

		/**
		 * Indicates the mouse velocity along the x-axis.
		 */
		public function get mouseVelocityX():Number
		{
			return _mouseVelocity.x;
		}

		/**
		 * Indicates the mouse velocity along the y-axis.
		 */
		public function get mouseVelocityY():Number
		{
			return _mouseVelocity.y;
		}

		/**
		 * Indicates the mouse velocity in 2D space
		 */
		public function get mouseVelocity2D():Number
		{
			return Math.sqrt(_mouseVelocity.x * _mouseVelocity.x + _mouseVelocity.y * _mouseVelocity.y); 
		}

		/**
		 * @inheritDoc
		 */
		public function start():void
		{
			EnterFrame.addEnterFrameHandler(render);
		}

		/**
		 * @inheritDoc
		 */
		public function stop():void
		{
			EnterFrame.removeEnterFrameHandler(render);
		}

		/**
		 * @inheritDoc
		 */
		public function get running():Boolean
		{
			return EnterFrame.hasEnterFrameHandler(render);
		}

		/**
		 * @inheritDoc
		 */
		public function clone():ICloneable
		{
			return new MouseMonitor(scope);
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct(deepDestruct:Boolean = false):void
		{
			stop();
			
			scope = null;
			
			super.destruct(deepDestruct);
		}

		private function render():void
		{
			_mousePosition.x = scope.mouseX;
			
			_mousePosition.y = scope.mouseY;
			
			_mouseVelocity = _mousePosition.subtract(_mouseLastPosition);
			
			_mouseLastPosition = _mousePosition.clone();
		}
	}
}
