/** * @version 1.0 * @author David Dahlstroem | daviddahlstroem.com *  *  * Copyright (c) 2009 David Dahlstroem | daviddahlstroem.com *  * Permission is hereby granted, free of charge, to any person obtaining a copy * of this software and associated documentation files (the "Software"), to deal * in the Software without restriction, including without limitation the rights * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell * copies of the Software, and to permit persons to whom the Software is * furnished to do so, subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in * all copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN * THE SOFTWARE. * */package org.tractionas3.graphics.fill{	import org.tractionas3.core.interfaces.ICoreInterface;	import org.tractionas3.geom.Dimension;	import org.tractionas3.graphics.Solid;	import flash.display.Graphics;	/**	 * SolidFill fills a Graphics object with a solid color fill.	 */	public class SolidFill extends Solid implements ICoreInterface, IFill 	{			/**		 * Creates a new SolidFill object.		 * 		 * @param fillColor Color of the fill.		 * @param fillAlpha Alpha of the fill.		 */		public function SolidFill(fillColor:uint, fillAlpha:Number = 1)		{			color = fillColor;						alpha = fillAlpha;		}		/**		 * @inheritDoc		 */		public function begin(graphics:Graphics, gradientDimension:Dimension = null, clearGraphics:Boolean = false):void		{			if(clearGraphics) graphics.clear();						graphics.beginFill(color, alpha);		}		/**		 * @inheritDoc		 */		public function end(graphics:Graphics):void		{			graphics.endFill();		}	}}