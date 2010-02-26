package org.tractionas3.ui 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.DisplayObject;
	import org.tractionas3.core.interfaces.IDrawable;
	import org.tractionas3.display.CoreSprite;

	import flash.events.Event;
	public class UISprite extends CoreSprite implements IDrawable 
	{
		public function UISprite()
		{
			super();
		}
		
		public function draw():void
		{
			return;
		}
		
		final public function redraw():void
		{
			clear();
			draw();
		}
		
		public function clear():void
		{
			return;
		}
		
		public function drawChildren(deepDraw:Boolean = false):void
		{
			var child:DisplayObject;
			
			for(var i:int = 0; i < numChildren; ++i)
			{
				child = getChildAt(i);
				
				if(child is IDrawable)
				{
					IDrawable(child).draw();
					
					if(deepDraw && child is DisplayObjectContainer) deepDrawChild(DisplayObjectContainer(child));
				}
			}
		}
		
		final public function redrawChildren(deepRedraw:Boolean = false):void
		{
			clearChildren(deepRedraw);
			drawChildren(deepRedraw);
		}
		
		public function clearChildren(deepClear:Boolean = false):void
		{
			var child:DisplayObject;
			
			for(var i:int = 0; i < numChildren; ++i)
			{
				child = getChildAt(i);
				
				if(child is IDrawable)
				{
					IDrawable(child).clear();
					
					if(deepClear && child is DisplayObjectContainer) deepClearChild(DisplayObjectContainer(child));
				}
			}
		}
		
		override protected function onAddedToStageInternal(e:Event = null):void
		{
			redraw();
		}
		
		override protected function onRemovedFromStageInternal(e:Event = null):void
		{
			clear();
		}
		
		private function deepDrawChild(target:DisplayObjectContainer):void
		{
			var child:DisplayObject;
			
			for(var i:int = 0; i < target.numChildren; ++i)
			{
				child = target.getChildAt(i);
				
				if(child is IDrawable)
				{
					IDrawable(child).draw();
					
					if(child is DisplayObjectContainer) deepDrawChild(DisplayObjectContainer(child));
				}
			}
		}
		
		private function deepClearChild(target:DisplayObjectContainer):void
		{
			var child:DisplayObject;
			
			for(var i:int = 0; i < target.numChildren; ++i)
			{
				child = target.getChildAt(i);
				
				if(child is IDrawable)
				{
					IDrawable(child).clear();
					
					if(child is DisplayObjectContainer) deepClearChild(DisplayObjectContainer(child));
				}
			}
		}
	}
}
