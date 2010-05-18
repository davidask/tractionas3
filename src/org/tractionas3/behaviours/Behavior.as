package org.tractionas3.behaviours 
{
	import org.tractionas3.core.CoreObject;
	import org.tractionas3.core.interfaces.IBehavior;

	import flash.display.DisplayObject;

	public class Behavior extends CoreObject implements IBehavior 
	{
		private var _targets:Array;
		
		public function Behavior()
		{
			super();
			
			_targets = [];
		}
		
		public function apply(target:DisplayObject):void
		{
			_targets.push(target);
		}
		
		public function isAppliedTo(target:DisplayObject):Boolean
		{
			return _targets.indexOf(target) > -1;
		}
		
		public function release(target:DisplayObject):void
		{
			if(!isAppliedTo(target)) return;
			
			_targets.splice(_targets.indexOf(target), 1);
		}
		
		final public function releaseAll():void
		{
			if(_targets.length == 0) return;
			
			release(_targets[0]);
			
			releaseAll();
		}
		
		override public function destruct(deepDestruct:Boolean = false):void
		{
			super.destruct(deepDestruct);
			
			releaseAll();
			
			_targets = null;
		}
	}
}
