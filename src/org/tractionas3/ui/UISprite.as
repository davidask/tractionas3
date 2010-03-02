/**
 * @version 1.0
 * @author David Dahlstroem | daviddahlstroem.com
 * 
 * 
 * Copyright (c) 2010 David Dahlstroem | daviddahlstroem.com
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */
 
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
			super.onAddedToStageInternal(e);
			
			redraw();
		}
		
		override protected function onRemovedFromStageInternal(e:Event = null):void
		{
			super.onRemovedFromStageInternal(e);
			
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
