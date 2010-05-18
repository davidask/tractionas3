package org.tractionas3.core.interfaces 
{
	import flash.display.DisplayObject;

	public interface IBehavior 
	{
		function apply(target:DisplayObject):void;
		
		function isAppliedTo(target:DisplayObject):Boolean;
		
		function release(target:DisplayObject):void;
		
		function releaseAll():void;
	}
}
