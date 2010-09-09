/**
 * @version 1.0
 * @author David A
 * 
 * 
 * Copyright (c) 2010 David A
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

package org.tractionas3.display.behaviors 
{
	import org.tractionas3.core.interfaces.IRenderable;

	import flash.geom.Point;

	public class MouseThrowBehavior extends MouseDragBehavior implements IRenderable
	{
		private var _lastPosition:Point;

		private var _currentPosition:Point;

		private var _throwVelocity:Point;

		public function MouseThrowBehavior()
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


