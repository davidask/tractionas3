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

package org.tractionas3.graphics.fill
{	import org.tractionas3.core.interfaces.ICoreInterface;
	import org.tractionas3.data.convertion.degreesToRadians;
	import org.tractionas3.geom.Dimension;
	import org.tractionas3.graphics.Gradient;

	import flash.display.Graphics;
	import flash.geom.Matrix;
	/**
	 * GradientFill fills a Graphics object with a gradient fill.
	 */

	public class GradientFill extends Gradient implements ICoreInterface, IFill 
	{	

		/**
		 * Specifies the type of the gradient fill.
		 */
		public var type:String;

		/**
		 * Specifies the angle of the gradient fill.
		 */

		public var angle:int;

		/**
		 * Specifies the focal point ratio of the gradient fill.
		 */
		public var focalPointRatio:Number;

		/**
		 * Specifies the spread method of the gradient fill.
		 */

		public var spreadMethod:String;

		/**
		 * Specifies the interpolation method of the gradient fill.
		 */

		public var interPolationMethod:String;

		private var _matrix:Matrix;

		
		/**
		 * Creates a new GradientFill object.
		 */

		public function GradientFill(gradientType:String = "linear")
		{
			type = gradientType;
			
			focalPointRatio = 0;
			
			angle = 0;
			
			spreadMethod = "pad";
			
			interPolationMethod = "rgb";
		}

		/**
		 * @inheritDoc
		 */

		public function begin(graphics:Graphics, gradientDimension:Dimension = null, clearGraphics:Boolean = false):void
		{
			_matrix = new Matrix();
			
			if(clearGraphics) graphics.clear();
			
			if(gradientDimension)
			{
				_matrix.createGradientBox(gradientDimension.width, gradientDimension.height, degreesToRadians(angle));
			}
				
			graphics.beginGradientFill(type, colors, alphas, ratios, _matrix, spreadMethod, interPolationMethod, focalPointRatio);
		}

		/**
		 * @inheritDoc
		 */

		public function end(graphics:Graphics):void
		{
			graphics.endFill();
		}
	}}