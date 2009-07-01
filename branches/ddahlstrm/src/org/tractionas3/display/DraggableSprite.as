/** * @version 1.0 * @author David Dahlstroem | daviddahlstroem.com *  *  * Copyright (c) 2009 David Dahlstroem | daviddahlstroem.com *  * Permission is hereby granted, free of charge, to any person obtaining a copy * of this software and associated documentation files (the "Software"), to deal * in the Software without restriction, including without limitation the rights * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell * copies of the Software, and to permit persons to whom the Software is * furnished to do so, subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in * all copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN * THE SOFTWARE. * */package org.tractionas3.display {	import org.tractionas3.core.interfaces.CoreInterface;	import org.tractionas3.geom.Grid;	import flash.events.Event;	import flash.events.MouseEvent;	import flash.geom.Point;	import flash.geom.Rectangle;	/**	 * DraggableSprite directly implements drag and drop functionality and responds to mouse events similar to	 * <code>flash.display.Sprite.startDrag()</code> and <code>flash.display.Sprite.stopDrag()</code> methods.	 * <p />	 * Using <code>startDrag()</code> and <code>stopDrag()</code> methods on DragabbleSprite is not allowed and will throw an error. 	 */	public class DraggableSprite extends MotionSprite implements CoreInterface	{			/** @private */		protected var offset:Point;		private var _dragging:Boolean = false;		private var _dragEnabled:Boolean = true;		private var _snapGrid:Grid;				/**		 * Creates a new DraggableSprite object.		 */		public function DraggableSprite(bounds:Rectangle = null)		{			super();						motionBounds = bounds;						offset = new Point(0, 0);		}		/**		 * Indicates whether the DraggableSprite instance is currently being dragged.		 */		public function get dragging():Boolean		{			return _dragging;		}		/**		 * Defines whether dragging of the DraggableSprite is enabled.		 */		public function get dragEnabled():Boolean		{			return _dragEnabled;		}		public function set dragEnabled(value:Boolean):void		{			if(value)			{				if(_dragEnabled) return;				activateDragging();			}			else			{				deactivateDragging();			}						_dragEnabled = value;		}		/**		 * Specifies a snap grid for the DragableSprite instance.		 */		public function get snapGrid():Grid		{			return _snapGrid;		}		public function set snapGrid(value:Grid):void		{			_snapGrid = value;		}		/**		 * @private		 */		override public function startDrag(lockCenter:Boolean = false, bounds:Rectangle = null):void		{			throw new Error("startDrag() method not allowed in DraggableSprite. Drag and drop functionality is automatically implemented.");		}		/**		 * @private		 */		override public function stopDrag():void		{			throw new Error("stopDrag() method not allowed in DraggableSprite. Drag and drop functionality is automatically implemented.");		}		/**		 * @inheritDoc		 */		override public function destruct(deepDestruct:Boolean = false):void		{			dragEnabled = false;						motionBounds = null;						offset.x = offset.y = NaN;						_dragging = false;						_dragEnabled = false;						super.destruct(deepDestruct);		}		/**		 * @private		 */		protected function handleMouseDown(e:MouseEvent = null):void		{			var globalOffset:Point = localToGlobal(new Point(mouseX, mouseY));						offset.x = globalOffset.x - x;						offset.y = globalOffset.y - y;						stage.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);						stage.addEventListener(MouseEvent.MOUSE_UP, handleMouseUp);						_dragging = true;		}		/**		 * @private		 */		protected function handleMouseMove(e:MouseEvent = null):void		{			var p:Point = localToGlobal(new Point(mouseX, mouseY));						x = p.x - offset.x;								y = p.y - offset.y;						if(!motionBounds) return;						if(x >= motionBounds.right) x = motionBounds.right;						if(x <= motionBounds.left) x = motionBounds.left;						if(y >= motionBounds.bottom) y = motionBounds.bottom;						if(y <= motionBounds.top) y = motionBounds.top;		}		/**		 * @private		 */		protected function handleMouseUp(e:MouseEvent = null):void		{			if(stage) stage.removeEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);								if(stage) stage.removeEventListener(MouseEvent.MOUSE_UP, handleMouseUp);						_dragging = false;		}		/**		 * @private		 */		protected function handleMouseLeave(e:Event = null):void		{			if(_dragging) handleMouseUp();		}		/**		 * @private		 */		protected function activateDragging(e:Event = null):void		{			stage.addEventListener(Event.MOUSE_LEAVE, handleMouseLeave);						this.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);		}		/**		 * @private		 */		protected function deactivateDragging(e:Event = null):void		{			if(stage) stage.removeEventListener(Event.MOUSE_LEAVE, handleMouseLeave);						this.removeEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);						handleMouseUp();		}		/**		 * @private		 */		override protected function onAddedToStageInternal(e:Event = null):void		{			if(dragEnabled) activateDragging();						super.onAddedToStageInternal(e);		}		/**		 * @private		 */		override protected function onRemovedFromStageInternal(e:Event = null):void		{			deactivateDragging();						super.onRemovedFromStageInternal(e);		}	}}