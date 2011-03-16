/**
 * @version 1.0
 * @author David A
 * 
 * 
 * Copyright (c) 2011 David A
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
package 
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.geom.Point;
	public function getCenter(target:DisplayObject, snapToPixels:Boolean = false):Point 
	{
		var p:Point;
		
		switch(true)
		{
			case target is Stage:
				
				p = new Point(Stage(target).stageWidth * 0.5, Stage(target).stageHeight * 0.5);
				
				break;
			
			default:
			
				p = new Point(target.width * 0.5, target.height * 0.5);
			
				break;
		}
		
		if(snapToPixels)
		{
			p.x = Math.round(p.x);
					
			p.y = Math.round(p.y);
		}
		
		return p;
	}
}
