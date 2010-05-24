package org.tractionas3.display.behaviors
{
	public interface IBehaviorDriven 
	{
		function addBehavior(behavior:IBehavior):IBehavior;
		
		function removeBehavior(behavior:IBehavior):void;
		
		function hasBehavior(behavior:IBehavior):Boolean;
	}
}
