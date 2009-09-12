/** * @version 1.0 * @author David Dahlstroem | daviddahlstroem.com *  *  * Copyright (c) 2009 David Dahlstroem | daviddahlstroem.com *  * Permission is hereby granted, free of charge, to any person obtaining a copy * of this software and associated documentation files (the "Software"), to deal * in the Software without restriction, including without limitation the rights * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell * copies of the Software, and to permit persons to whom the Software is * furnished to do so, subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in * all copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN * THE SOFTWARE. * */package org.tractionas3.utils {	import flash.display.DisplayObject;	import flash.display.Sprite;	import flash.display.Stage;	public class StageUtil 	{		public static function getDocument(stage:Stage):Sprite		{			var child:DisplayObject;						for(var i:int = 0;i < stage.numChildren; ++i)			{				child = stage.getChildAt(i);								if(child.root == child) return child as Sprite;			}			return null;		}
		public static function centerX(stage:Stage, snapToPixels:Boolean = false):Number		{			var c:Number = stage.stageWidth;						return (snapToPixels) ? Math.round(c) : c;		}
		public static function centerY(stage:Stage, snapToPixels:Boolean = false):Number		{			var c:Number = stage.stageHeight;						return (snapToPixels) ? Math.round(c) : c;		}	}}