package org.tractionas3.events 
{
	import org.tractionas3.core.CoreObject;
	import org.tractionas3.core.interfaces.IRenderable;

	public class Renderer extends CoreObject implements IRenderable 
	{
		private var _callback:Function;
		
		public function Renderer()
		{
			super();
		}
		
		public function render():void
		{
		}
		
		public function setCallback(callback:Function):void
		{
			_callback = callback;
		}
		
		public function get hasCallback():Boolean
		{
			return _callback is Function;
		}

		public function startRender():void
		{
			if(!hasCallback)
				return;
				
			EnterFrame.addEnterFrameHandler(_callback);
		}

		public function stopRender():void
		{
			if(!hasCallback)
				return;
			
			EnterFrame.removeEnterFrameHandler(_callback);
		}

		public function get rendering():Boolean
		{
			if(!hasCallback)
				return false;
			
			return EnterFrame.hasEnterFrameHandler(_callback);
		}
		
		override public function destruct(deepDestruct:Boolean = false):void
		{
			stopRender();
			
			_callback = undefined;
			
			super.destruct(deepDestruct);
		}
	}
}
