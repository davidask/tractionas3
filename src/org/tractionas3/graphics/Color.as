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

package org.tractionas3.graphics 
{
	import org.tractionas3.core.CoreObject;
	/*
	 * TODO: Extend functionality of Color class.
	 */
	
	/**
	 * The Color class represents a color.
	 */
	public class Color extends CoreObject
	{
		/**
		 * Parses and returns hex color in string format (e.g. "0xFF0000" or "#000000").
		 */
		public static function parseColor(colorStr:String):uint
		{
			if (colorStr.substr(0, 2) == "0x") colorStr = colorStr.substr(2);
			
			else if (colorStr.substr(0, 1) == "#") colorStr = colorStr.substr(1);

			return parseInt(colorStr, 16);
		}

		private var _red:uint;

		private var _green:uint;

		private var _blue:uint;

		private var _alpha:uint;

		/**
		 * Creates a new Color object with specified color in hexadecimal format.
		 */
		public function Color(color:uint = 0)
		{
			super();
			
			hexColor = color;
		}

		/**
		 * Randomizes each channel in the color.
		 */
		public function randomize():void
		{
			alpha = Math.random() * 255;
			
			red = Math.random() * 255;
			
			green = Math.random() * 255;
			
			blue = Math.random() * 255; 
		}

		/**
		 * Specifies the color of the Color object in hexadecimal format.
		 */
		public function get hexColor():uint
		{
			return (alpha << 24 | red << 16 | green << 8 | blue);
		}

		public function set hexColor(value:uint):void
		{
			alpha = (value >> 24) & 0xFF;
			
			red = (value >> 16) & 0xFF;
			
			green = (value >> 8) & 0xFF;
			
			blue = value & 0xFF;
		}

		/**
		 * Specifies the amount of red in the Color object, randing between 0 and 255.
		 */
		public function get red():uint
		{
			return _red;
		}

		public function set red(value:uint):void
		{
			_red = value;
		}

		/**
		 * Specifies the amount of green in the Color object, randing between 0 and 255.
		 */
		public function get green():uint
		{
			return _green;
		}

		public function set green(value:uint):void
		{
			_green = value;
		}

		/**
		 * Specifies the amount of blue in the Color object, randing between 0 and 255.
		 */
		public function get blue():uint
		{
			return _blue;
		}

		public function set blue(value:uint):void
		{
			_blue = value;
		}

		/**
		 * Specifies the alpha in the Color object, randing between 0 and 255.
		 */
		public function get alpha():uint
		{
			return _alpha;
		}

		public function set alpha(value:uint):void
		{
			_alpha = value;
		}
	}
}
