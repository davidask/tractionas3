/** * @version 1.0 * @author David Dahlstroem | daviddahlstroem.com *  *  * Copyright (c) 2009 David Dahlstroem | daviddahlstroem.com *  * Permission is hereby granted, free of charge, to any person obtaining a copy * of this software and associated documentation files (the "Software"), to deal * in the Software without restriction, including without limitation the rights * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell * copies of the Software, and to permit persons to whom the Software is * furnished to do so, subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in * all copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN * THE SOFTWARE. * */package org.tractionas3.geom {	import org.tractionas3.core.CoreObject;	import org.tractionas3.core.interfaces.Cloneable;	import org.tractionas3.core.interfaces.CoreInterface;	import org.tractionas3.core.interfaces.Resetable;	/**	 * Dimension represents a width and height object.	 */	public class Dimension extends CoreObject implements CoreInterface, Cloneable, Resetable	{		/**		 * Specifies the width of the dimension.		 */		public var width:Number;		/**		 * Specifies the height of the dimension.		 */		public var height:Number;				/**		 * Creates a new Dimension object.		 * 		 * @param dimensionWidth Dimension width		 * @param dimensionHeight Dimension height		 */		public function Dimension(dimensionWidth:Number = 0, dimensionHeight:Number = 0)		{			width = dimensionWidth;						height = dimensionHeight;		}		/**		 * Indicates whether the dimension contains specified dimension.		 */		public function contains(dimension:Dimension):Boolean		{			return width >= dimension.width && height >= dimension.height;		}		/**		 * Indicates whether the dimension strictly contains specified dimension.		 */		public function containsStrict(dimension:Dimension):Boolean		{			return width > dimension.width && height > dimension.height;		}		/**		 * Indicates the area of the dimension		 */		public function get area():Number		{			return width * height;		}		/**		 * Expands the dimension.		 * 		 * @param expandWidth width expansion		 * @param expandHeight height expansion		 */		public function expand(expandWidth:Number, expandHeight:Number):Dimension		{			width += expandWidth;						height += expandHeight;						return this;		}		/**		 * Shrinks the dimension.		 * 		 * @param shrinkWidth Width shrinkage		 * @param shrinkHeight Height shrinkage 		 */		public function shrink(shrinkWidth:Number, shrinkHeight:Number):Dimension		{			width -= shrinkWidth;						height -= shrinkHeight;						return this;		}		/**		 * Scales the dimension.		 * 		 * @param scaleX Scale along the x-axis.		 * @param scaleY Scale along the y-axis.		 */		public function scale(scaleX:Number, scaleY:Number):Dimension		{			width *= scaleX;						height *= scaleY;						return this;		}		/**		 * Clones the dimension.		 */		public function clone():Object		{			return new Dimension(width, height);		}		/**		 * Resets the dimension, setting its width and height to zero.		 */		public function reset():void		{			width = height = 0;		}		/**		 * @inheritDoc		 */		override public function toString():String		{			return super.toString() + "[width=" + width + ", height=" + height + "]";		}	}}