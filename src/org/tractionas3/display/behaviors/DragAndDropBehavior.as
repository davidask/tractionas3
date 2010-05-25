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
 
package org.tractionas3.display.behaviors
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	public class DragAndDropBehavior extends MotionBehavior 
	{
		/** @private */
		protected var currentTarget:DisplayObject;

		/** @private */
		protected var currentStage:Stage;

		/** @private */
		protected var dragLimitsRect:Rectangle;

		/** @private */
		protected var dragLimitsScope:DisplayObject;

		private var _offset:Point;

		private var _dragging:Boolean;

		public function DragAndDropBehavior()
		{
			super();
			
			_offset = new Point();
			
			stopRender();
		}

		override public function apply(target:DisplayObject):void
		{
			super.apply(target);
			
			setEventListeners(target, true);
		}

		override public function release(target:DisplayObject):void
		{
			super.release(target);
			
			setEventListeners(target, false);
			
			currentTarget = null;
		}

		public function setDragLimits(limits:Rectangle, scope:DisplayObject):void
		{
			dragLimitsRect = limits;
			
			dragLimitsScope = scope;
		}

		public function get dragging():Boolean
		{
			return _dragging;
		}

		public function isDraggingObject(target:DisplayObject):Boolean
		{
			return currentTarget == target;
		}

		override public function destruct(deepDestruct:Boolean = false):void
		{
			dragLimitsScope = null;
			
			super.destruct(deepDestruct);
		}

		/** @private */
		protected function handleMouseDown():void
		{			
			var globalOffset:Point = currentTarget.localToGlobal(new Point(currentTarget.mouseX, currentTarget.mouseY));
			
			_offset.x = globalOffset.x - currentTarget.x;
			
			_offset.y = globalOffset.y - currentTarget.y;
					
			currentStage = currentTarget.stage;
					
			currentStage.addEventListener(MouseEvent.MOUSE_MOVE, handleTargetEvent);
					
			currentStage.addEventListener(MouseEvent.MOUSE_UP, handleTargetEvent);
			
			_dragging = true;
		}

		/** @private */
		protected function handleMouseMove(target:DisplayObject = null, changePosition:Boolean = true):void
		{
			if(!target)
			{
				target = currentTarget;
			}
			
			if(changePosition)
			{
				var p:Point = target.localToGlobal(new Point(target.mouseX, target.mouseY));
			
					
				target.x = p.x - _offset.x;
					
				target.y = p.y - _offset.y;
			}
			
			if(dragLimitsRect && dragLimitsScope)
			{
				var rect:Rectangle = getDragLimitsRectForTarget(target);
				
				if(target.x <= rect.left) target.x = rect.left;
				
				if(target.x >= rect.right) target.x = rect.right;
				
				if(target.y <= rect.top) target.y = rect.top;
				
				if(target.y >= rect.bottom) target.y = rect.bottom;
			}
		}

		/** @private */
		protected function handleMouseUp():void
		{
			currentTarget = null;
					
			currentStage.removeEventListener(MouseEvent.MOUSE_MOVE, handleTargetEvent);
					
			currentStage.removeEventListener(MouseEvent.MOUSE_UP, handleTargetEvent);
			
			_dragging = false;
		}

		/** @private */
		protected function getDragLimitsRectForTarget(target:DisplayObject):Rectangle
		{
			var scopeGlobalPosition:Point = dragLimitsScope.localToGlobal(new Point());
				
				
			var globalRect:Rectangle = dragLimitsRect.clone();
				
			globalRect.offsetPoint(scopeGlobalPosition);
				
				
			var targetParentLocalPosition:Point = target.parent.globalToLocal(new Point(globalRect.x, globalRect.y));
				
				
			var localRect:Rectangle = dragLimitsRect.clone();
				
			localRect.offsetPoint(targetParentLocalPosition);
				
				
			return localRect;
		}

		private function setEventListeners(target:DisplayObject, add:Boolean):void 
		{
			var method:String = add ? "addEventListener" : "removeEventListener";
			
			target[method](MouseEvent.MOUSE_DOWN, handleTargetEvent);
			
			removeStageEventListeners();
		}

		private function removeStageEventListeners():void 
		{
			if(!currentStage) return;
			
			currentStage.removeEventListener(MouseEvent.MOUSE_MOVE, handleTargetEvent);
					
			currentStage.removeEventListener(MouseEvent.MOUSE_UP, handleTargetEvent);
		}

		private function handleTargetEvent(e:Event):void 
		{
			var target:DisplayObject = e.currentTarget as DisplayObject;
			
			switch(e.type)
			{
				case MouseEvent.MOUSE_DOWN:
					
					if(target.stage != currentStage)
					{
						removeStageEventListeners();
					}

					
					if(currentTarget)
					{
						return;
					}
									
					currentTarget = target;
					
					handleMouseDown();
			
					break;
				
				case MouseEvent.MOUSE_MOVE:
					
					handleMouseMove(currentTarget, true);
					
					for(var i:int = 0;i < targets.length;i++)
					{
						target = targets[i] as DisplayObject;
						
						if(target != currentTarget)
						{
							handleMouseMove(target, false);
						}
					}
					
					break;
				
				case MouseEvent.MOUSE_UP:
					
					handleMouseUp();
					
					break;
			}
			
			if(e is MouseEvent)
			{
				MouseEvent(e).updateAfterEvent();
			}
		}
	}
}
