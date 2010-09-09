/**
 * @version 1.0
 * @author David A
 * 
 * 
 * Copyright (c) 2009 David A
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
 
package org.tractionas3.display 
{
	import org.tractionas3.core.interfaces.IDrawable;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;

	/**
	 * DrawableSprite provides a standard implementation of the IDrawable core interface.
	 */
	public class DrawableSprite extends CoreSprite implements IDrawable 
	{
		/**
		 * Creats a new DrawableSprite object.
		 */
		public function DrawableSprite()
		{
			super();
		}

		/**
		 * Draws the DrawableSprite object. Should be overridden for implementation of functionality.
		 */
		public function draw():void
		{
			return;
		}

		/**
		 * Redraws the DrawableSprite object. Cannot be overridden.
		 */
		final public function redraw():void
		{
			clear();
			draw();
		}

		/**
		 * Clears the DrawableSprite object. Should be overridden for implementation of functionality.
		 */
		public function clear():void
		{
			return;
		}
		
		public function redrawParents():void
		{
			if(!parent) return;
			
			if(parent is IDrawable)
			{
				IDrawable(parent).redraw();
				
				if(parent is DrawableSprite)
				{
					DrawableSprite(parent).redrawParents();
				}
			}
		}

		/**
		 * Draws the children of the DrawableSprite object if they implement the IDrawable interface.
		 * @see org.tractionas3.core.interfaces.IDrawable
		 */
		public function drawChildren(deepDraw:Boolean = false):void
		{
			var child:DisplayObject;
			
			for(var i:int = 0;i < numChildren;++i)
			{
				child = getChildAt(i);
				
				if(child is IDrawable)
				{
					if(deepDraw && child is DisplayObjectContainer) deepDrawChild(DisplayObjectContainer(child));
					
					IDrawable(child).draw();
				}
			}
		}

		/**
		 * Redraws the children of the DrawableSprite object if they implement the IDrawable interface.
		 * Cannot be overridden.
		 * @see org.tractionas3.core.interfaces.IDrawable
		 */
		final public function redrawChildren(deepRedraw:Boolean = false):void
		{
			clearChildren(deepRedraw);
			drawChildren(deepRedraw);
		}

		/**
		 * Clears the children of the DrawableSprite object if they implement the IDrawable interface.
		 * @see org.tractionas3.core.interfaces.IDrawable
		 */
		public function clearChildren(deepClear:Boolean = false):void
		{
			var child:DisplayObject;
			
			for(var i:int = 0;i < numChildren;++i)
			{
				child = getChildAt(i);
				
				if(child is IDrawable)
				{
					if(deepClear && child is DisplayObjectContainer) deepClearChild(DisplayObjectContainer(child));
					
					IDrawable(child).clear();
				}
			}
		}
		
	

		/**
		 * @private
		 */
		override protected function onAddedToStageInternal(e:Event = null):void
		{
			super.onAddedToStageInternal(e);
			
			redraw();
		}

		/**
		 * @private
		 */
		override protected function onRemovedFromStageInternal(e:Event = null):void
		{
			super.onRemovedFromStageInternal(e);
			
			clear();
		}

		private function deepDrawChild(target:DisplayObjectContainer):void
		{
			var child:DisplayObject;
			
			for(var i:int = 0;i < target.numChildren;++i)
			{
				child = target.getChildAt(i);
				
				if(child is IDrawable)
				{
					if(child is DisplayObjectContainer) deepDrawChild(DisplayObjectContainer(child));
					
					IDrawable(child).draw();
				}
			}
		}

		private function deepClearChild(target:DisplayObjectContainer):void
		{
			var child:DisplayObject;
			
			for(var i:int = 0;i < target.numChildren;++i)
			{
				child = target.getChildAt(i);
				
				if(child is IDrawable)
				{
					if(child is DisplayObjectContainer) deepClearChild(DisplayObjectContainer(child));
					
					IDrawable(child).clear();
				}
			}
		}
	}
}
