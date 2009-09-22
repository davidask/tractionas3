/**
 * @version 1.0
 * @author David Dahlstroem | daviddahlstroem.com
 * 
 * 
 * Copyright (c) 2009 David Dahlstroem | daviddahlstroem.com
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
 
package org.tractionas3.display.effects 
{
	import org.tractionas3.reflection.stringify;
	import org.tractionas3.core.Destructor;
	import org.tractionas3.core.interfaces.ICoreInterface;
	import org.tractionas3.core.interfaces.IDrawable;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * DisplayObjectReflection creates a reflection of a DisplayObject
	 */
	public class Reflection extends Bitmap implements IDrawable, ICoreInterface
	{

		/**
		 * Specifies the target to be reflected.
		 */
		public var target:DisplayObject;

		/**
		 * Specifies the falloff of the reflection gradient. 
		 */
		public var fallOff:Number;

		private var _sourceBitmapData:BitmapData;

		private var _alphaGradientBitap:BitmapData;

		
		/**
		 * Creates a new DisplayObjectReflection
		 */
		public function Reflection(drawTarget:DisplayObject)
		{
			super();
			
			target = drawTarget;
			
			createBitmaps();
			
			fallOff = 1;
		}

		/**
		 * Draws the reflection.
		 */
		public function draw():void
		{
			var rect:Rectangle = new Rectangle(0, 0, target.width, target.height);
			
			_sourceBitmapData.fillRect(rect, 0x00000000);
			
			drawAlphaGradientBitmap();
			
			var
			transform:Matrix = new Matrix();
			transform.scale(target.scaleX, -target.scaleY);
			transform.translate(0, target.height);
			
			_sourceBitmapData.draw(target, transform);
			
			
			bitmapData.fillRect(rect, 0x00000000);
			bitmapData.copyPixels(_sourceBitmapData, _sourceBitmapData.rect, new Point(), _alphaGradientBitap);
		}

		/**
		 * Redraws the reflection.
		 */
		public function redraw():void
		{
			clear();
			
			draw();
		}

		/**
		 * Clears the reflection.
		 */
		public function clear():void
		{
			bitmapData.fillRect(bitmapData.rect, 0x00000000);
			
			_sourceBitmapData.fillRect(_sourceBitmapData.rect, 0x00000000);
			
			_alphaGradientBitap.fillRect(_alphaGradientBitap.rect, 0x00000000);
		}

		/**
		 * Clears the bitmap data caches.
		 */
		public function clearBitmapDataCache():void
		{
			_sourceBitmapData.dispose();
			
			_sourceBitmapData = null;
			
			bitmapData.dispose();
			
			bitmapData = null;
			
			_alphaGradientBitap.dispose();
			
			_alphaGradientBitap = null;
			
			createBitmaps();
		}
		
		public function destruct(deeepDestruct:Boolean = false):void
		{
			clearBitmapDataCache();
			
			_sourceBitmapData = null;
			
			bitmapData = null;
			
			_alphaGradientBitap = null;
			
			Destructor.destruct(this, deeepDestruct);
		}
		
		public function listDestructableProperties():Array
		{
			return ["bitmapData"];
		}
		
		override public function toString():String
		{
			return stringify(this);
		}

		private function createBitmaps():void
		{
			_sourceBitmapData = new BitmapData(target.width, target.height, true, 0x000000);
				
			bitmapData = new BitmapData(target.width, target.height, true, 0x000000);
			
			_alphaGradientBitap = new BitmapData(target.width, target.height, true, 0x000000);
		}

		private function drawAlphaGradientBitmap():void
		{
			var gradientMatrix:Matrix = new Matrix();
			
			var gradientSprite:Sprite = new Sprite();
			
			gradientMatrix.createGradientBox(target.width, target.height * fallOff, Math.PI / 2, 0, target.height * (1.0 - fallOff));
			
			gradientSprite.graphics.beginGradientFill(GradientType.LINEAR, [0xFFFFFF, 0xFFFFFF], [0, 1], [0, 255], gradientMatrix);
			
			gradientSprite.graphics.drawRect(0, target.height * (1.0 - fallOff), target.width, target.height * fallOff);
			
			gradientSprite.graphics.endFill();
			
			var
			invertMatrix:Matrix = new Matrix();
			invertMatrix.scale(1, -1);
			invertMatrix.translate(0, target.height);
			
			_alphaGradientBitap.draw(gradientSprite, invertMatrix);
			
			
			gradientMatrix = null;
			
			gradientSprite = null;
		}
	}
}
