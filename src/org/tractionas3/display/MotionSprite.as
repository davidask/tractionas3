/** * @version 1.0 * @author David Dahlstroem | daviddahlstroem.com *  *  * Copyright (c) 2009 David Dahlstroem | daviddahlstroem.com *  * Permission is hereby granted, free of charge, to any person obtaining a copy * of this software and associated documentation files (the "Software"), to deal * in the Software without restriction, including without limitation the rights * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell * copies of the Software, and to permit persons to whom the Software is * furnished to do so, subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in * all copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN * THE SOFTWARE. * */package org.tractionas3.display {	import org.tractionas3.core.interfaces.ICoreInterface;	import org.tractionas3.core.interfaces.IRenderable;	import flash.events.Event;	import flash.geom.Point;	import flash.geom.Rectangle;	/**	 * MotionSprite implements properties for measuring its velocity every frame.	 */	public class MotionSprite extends RenderableSprite implements ICoreInterface, IRenderable	{		/**		 * Specifies the bounds in wich the MotionSprite is allowed to move.		 */		public var motionBounds:Rectangle;		/**		 * Specifies the friction multiplier adding resistance to the throw motion of the ThrowableSprite when bouncing of		 * its drag bounds.		 * 		 * @see #dragBounds		 */		public var bounceFrictionMultiplier:Number = 0.7;		/**		 * Specifies whether the MotionSprite instance should bounce off its bounds.		 * 		 * @see #motionBounds		 */		public var bounceOffBounds:Boolean;		/** @private */		protected var velocity:Point;		/** @private */		protected var lastPosition:Point;		/** @private */		protected var applyVelocity:Boolean;		private var _manualStop:Boolean = false;				/**		 * Creats a new MotionSprite object.		 */		public function MotionSprite()		{			super();						cacheAsBitmap = true;						lastPosition = new Point(0, 0);						applyVelocity = true;						velocity = new Point(0, 0);						bounceOffBounds = true;		}		/**		 * Specifies the current velocity of the MotionSprite instance along the x axis.		 */		public function get velocityX():Number		{			return velocity.x;		}		public function set velocityX(value:Number):void		{			velocity.x = value;		}		/**		 * Specifies the current velocity of the MotionSprite instance along the y axis.		 */		public function get velocityY():Number		{			return velocity.y;		}		public function set velocityY(value:Number):void		{			velocity.y = value;		}		/**		 * @inheritDoc		 */		override public function render():void		{						if(motionBounds)			{				if(x <= motionBounds.left)				{					x = motionBounds.left;										invertVelocityX(resolveBounceFrictionMultiplier);				}										else if(x >= motionBounds.right)				{					x = motionBounds.right;										invertVelocityX(resolveBounceFrictionMultiplier);				}									if(y <= motionBounds.top)				{					y = motionBounds.top;											invertVelocityY(resolveBounceFrictionMultiplier);				}										else if(y >= motionBounds.bottom)				{					y = motionBounds.bottom;											invertVelocityY(resolveBounceFrictionMultiplier);				}			}						lastPosition.x = x;					lastPosition.y = y;						if(!applyVelocity) return;						x += velocityX;						y += velocityY;		}		/**		 * Inverts the current velocity of the MotionSprite instance along the x axis.		 */		public function invertVelocityX(multiplier:Number = 1):void		{			velocity.x *= multiplier;			velocity.x *= -1;		}		/**		 * Inverts the current velocity of the MotionSprite instance along the y axis.		 */		public function invertVelocityY(multiplier:Number = 1):void		{			velocity.y *= multiplier;			velocity.y *= -1;		}		/**		 * Indicates the unspecified velocity of the MotionSprite instance along the x axis.		 */		public function get indirectVelocityX():Number		{			return x - lastPosition.x;		}		/**		 * Indicates the unspecified velocity of the MotionSprite instance along the y axis.		 */		public function get indirectVelocityY():Number		{			return y - lastPosition.y;		}		/**		 * Indicates the indirect 2D velocity of the MotionSprite.		 */		public function get indirectVelocity2D():Number		{			return Math.sqrt(indirectVelocityX * indirectVelocityX + indirectVelocityY * indirectVelocityY);		}		/**		 * @inheritDoc		 */		override public function destruct(deepDestruct:Boolean = false):void		{			stopRender();			super.destruct(deepDestruct);						lastPosition = null;						_manualStop = false;						velocity = null;		}		/**		 * Starts rendering of the MotionSprite.		 * <p />		 * <b>NOTE</b>: By default this method is called when the MotionSprite is added to stage.		 * Use <code>startRender()</code> if you previously called <code>stopRender()</code> and want to		 * re-enable automatic render control.		 */		override public function startRender():void		{			super.startRender();						_manualStop = false;		}		/**		 * Stops rendering and stops the autmatic render control of the MotionSprite.		 */		override public function stopRender():void		{			super.stopRender();						_manualStop = true;		}		/**		 * @private		 */		override protected function onAddedToStageInternal(e:Event = null):void		{			if(!_manualStop) startRender();						super.onAddedToStageInternal(e);		}		/**		 * @private		 */		override protected function onRemovedFromStageInternal(e:Event = null):void		{			stopRender();						super.onRemovedFromStageInternal(e);		}		private function get resolveBounceFrictionMultiplier():Number		{			return (bounceOffBounds) ? bounceFrictionMultiplier : 0;		}	}}