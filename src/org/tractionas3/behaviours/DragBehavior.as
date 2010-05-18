package org.tractionas3.behaviours 
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class DragBehavior extends Behavior 
	{
		private var _stageReference:Stage;
		
		private var _currentTarget:DisplayObject;

		private var _offset:Point;

		public function DragBehavior()
		{
			super();
			
			_offset = new Point();
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
			
			_currentTarget = null;
		}

		private function setEventListeners(target:DisplayObject, add:Boolean):void 
		{
			var method:String = add ? "addEventListener" : "removeEventListener";
			
			target[method](MouseEvent.MOUSE_DOWN, handleTargetEvent);
			
			removeStageEventListeners();
		}

		private function removeStageEventListeners():void 
		{
			if(!_stageReference) return;
			
			_stageReference.removeEventListener(MouseEvent.MOUSE_MOVE, handleTargetEvent);
					
			_stageReference.removeEventListener(MouseEvent.MOUSE_UP, handleTargetEvent);
		}

		
		private function handleTargetEvent(e:Event):void 
		{
			var target:DisplayObject = e.currentTarget as DisplayObject;
			
			switch(e.type)
			{
				case MouseEvent.MOUSE_DOWN:
					
					if(target.stage != _stageReference)
					{
						removeStageEventListeners();
					}
					
					_currentTarget = target;
					
					var globalOffset:Point = _currentTarget.localToGlobal(new Point(_currentTarget.mouseX, _currentTarget.mouseY));
			
					_offset.x = globalOffset.x - _currentTarget.x;
			
					_offset.y = globalOffset.y - _currentTarget.y;
					
					_stageReference = _currentTarget.stage;
					
					_stageReference.addEventListener(MouseEvent.MOUSE_MOVE, handleTargetEvent);
					
					_stageReference.addEventListener(MouseEvent.MOUSE_UP, handleTargetEvent);
					
					break;
				
				case MouseEvent.MOUSE_MOVE:
					
					var p:Point = _currentTarget.localToGlobal(new Point(_currentTarget.mouseX, _currentTarget.mouseY));
					
					_currentTarget.x = p.x - _offset.x;
					
					_currentTarget.y = p.y - _offset.y;
					
					break;
				
				case MouseEvent.MOUSE_UP:
					
					_currentTarget = null;
					
					_stageReference.removeEventListener(MouseEvent.MOUSE_MOVE, handleTargetEvent);
					
					_stageReference.removeEventListener(MouseEvent.MOUSE_UP, handleTargetEvent);
					
					break;
			}
			
			if(e is MouseEvent)
			{
				MouseEvent(e).updateAfterEvent();
			}
		}
	}
}
