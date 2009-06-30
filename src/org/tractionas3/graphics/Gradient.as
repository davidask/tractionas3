/** * @version 1.0 * @author David Dahlstroem | daviddahlstroem.com *  *  * Copyright (c) 2009 David Dahlstroem | daviddahlstroem.com *  * Permission is hereby granted, free of charge, to any person obtaining a copy * of this software and associated documentation files (the "Software"), to deal * in the Software without restriction, including without limitation the rights * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell * copies of the Software, and to permit persons to whom the Software is * furnished to do so, subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in * all copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN * THE SOFTWARE. * */package org.tractionas3.graphics {	import org.tractionas3.core.CoreObject;	import org.tractionas3.core.interfaces.CoreInterface;	/**	 * Solid represents a gradient type graphic.	 */	public class Gradient extends CoreObject implements CoreInterface	{		/**		 * @private		 */		protected var gradientColors:Array = [];
				/**		 * Adds a color to the gradient.		 */		public function addGradientColor(gradientColor:GradientColor):GradientColor		{			gradientColors.push(gradientColor);						return gradientColor;		}
		/**		 * Removes a color from the gradient.		 */		public function removeGradientColor(gradientColor:GradientColor):void		{			for(var i:int = 0;i < gradientColors.length; ++i)			{				if(gradientColors[i] === gradientColor)				{					gradientColors.splice(i, 1);				}			}		}
		/**		 * Returns an array containing the colors of the gradient. 		 */		public function get colors():Array		{			var a:Array = [];						for(var i:int = 0;i < gradientColors.length; ++i)			{				a.push(GradientColor(gradientColors[i]).color);			}						return a;		}
		/**		 * Returns an array containing the alphas of the gradient. 		 */		public function get alphas():Array		{			var a:Array = [];						for(var i:int = 0;i < gradientColors.length; ++i)			{				a.push(GradientColor(gradientColors[i]).alpha);			}						return a;		}		/**		 * Returns an array containing the ratios of the gradient. 		 */
		public function get ratios():Array		{			var a:Array = [];						for(var i:int = 0;i < gradientColors.length; ++i)			{				a.push(GradientColor(gradientColors[i]).ratio);			}						return a;		}
		/**		 * @inheritDoc		 */
		override public function destruct(deepDestruct:Boolean = false):void		{			super.destruct(deepDestruct);		}	}}