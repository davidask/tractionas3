/** * @version 1.0 * @author David Dahlstroem | daviddahlstroem.com *  *  * Copyright (c) 2009 David Dahlstroem | daviddahlstroem.com *  * Permission is hereby granted, free of charge, to any person obtaining a copy * of this software and associated documentation files (the "Software"), to deal * in the Software without restriction, including without limitation the rights * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell * copies of the Software, and to permit persons to whom the Software is * furnished to do so, subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in * all copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN * THE SOFTWARE. * */package org.tractionas3.events{	import flash.events.Event;	/**	 * LoadProgressObjectiveEvent is the event class used for LoadProgressObjective instances.	 */	public class LoadProgressObjectiveEvent extends Event 	{		/**		 * Defines the value of the type property of a loadProgressObjectiveMet event object.		 */		public static const OBJECTIVE_MET:String = "loadProgressObjectiveMet";		/**		 * Defines the value of the type property of a loadProgressObjectiveProgress event object.		 */		public static const PROGRESS:String = "loadProgressObjectiveProgress";				/**		 * Creates a new LoadProgressObjectiveEvent object.		 * 		 * @see org.tractionas3.load.LoadProgressObjective		 */		public function LoadProgressObjectiveEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)		{			super(type, bubbles, cancelable);		}		/**		 * @inheritDoc		 */		override public function clone():Event		{			return new LoadProgressObjectiveEvent(type, bubbles, cancelable);		}	}}