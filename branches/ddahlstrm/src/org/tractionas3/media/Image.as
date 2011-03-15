/**
 * @version 1.0
 * @author David A
 * 
 * 
 * Copyright (c) 2009 David A
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

package org.tractionas3.media 
{
	import org.tractionas3.display.DrawableSprite;
	import org.tractionas3.events.LoaderEvent;
	import org.tractionas3.geom.Align;
	import org.tractionas3.geom.Dimension;
	import org.tractionas3.graphics.fill.IFill;
	import org.tractionas3.graphics.fill.SolidFill;
	import org.tractionas3.load.loaders.BitmapDataLoader;
	import org.tractionas3.load.loaders.BitmapLoader;
	import org.tractionas3.load.loaders.DisplayLoader;
	import org.tractionas3.utils.DisplayObjectUtil;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;

	public class Image extends DrawableSprite 
	{
		
		/** @private */
		protected var imageLoader:DisplayLoader;

		/** @private */
		protected var imageData:DisplayObject;

		/** @private */
		protected var imageDataContainer:Sprite;

		/** @private */
		protected var imageSize:Dimension;

		private var _loadMethod:uint;

		private var _smoothing:Boolean;

		private var _scaleImage:Boolean;

		private var _scaleAlign:String;

		private var _scaleFill:Boolean;

		private var _lazyLoadInterval:uint;

		private var _backgroundFill:IFill;

		private var _progress:Number;

		/**
		 * Image Constructor.
		 * 
		 * @param source The source of the image.
		 * Can be of the following types: String, URLRequest, DisplayLoader, BitmapLoader or BitmapDataLoader.
		 * If the type is either String or URLRequest a BitmapDataLoader will be created.
		 * 
		 * @param imgWidth Image width
		 * 
		 * @param imgHeight Image height
		 * 
		 * @param loadMethod The load method of the image.
		 * @see org.tractionas3.media.ImageLoadMethod
		 */
		public function Image(source:*, loadMethod:uint = 3, imgWidth:Number = 0, imgHeight:Number = 0)
		{
			super();
			
			_progress = 0;
			
			imageSize = new Dimension(imgWidth, imgHeight);
			
			_loadMethod = loadMethod;
			
			imageLoader = getDisplayLoader(source);
			
			_scaleImage = false;
			
			_scaleAlign = Align.CENTER;
			
			_scaleFill = true;
			
			imageDataContainer = addChild(new Sprite()) as Sprite;
			
			if(_loadMethod == ImageLoadMethod.INSTANT)
			{
				load();
			}
		}

		/**
		 * Loads the image.
		 * Only required when using manual load method.
		 */
		public function load():void
		{
			if(!imageLoader) return;
			
			if(!imageLoader.loading || imageLoader.loaded)
			{
				imageLoader.addEventListener(LoaderEvent.START, handleLoaderEvent);
				
				imageLoader.addEventListener(LoaderEvent.PROGRESS, handleLoaderEvent);
				
				imageLoader.addEventListener(LoaderEvent.COMPLETE, handleLoaderEvent);
				
				imageLoader.addEventListener(LoaderEvent.IO_ERROR, handleLoaderEvent);
				
				_progress = 0;
				
				imageLoader.load();
			}
		}

		/**
		 * Indicates whether the image is loaded
		 */

		public function get loaded():Boolean
		{
			return progress == 1;
		}

		/*
		 * Indicates the progress of the image loading process
		 */

		public function get progress():Number
		{
			return _progress;
		}

		/**
		 * Specifies a background fill for the image that will be visible while the image is not yet loaded.
		 * Set to value <code>null</code> to remove.
		 */
		public function get backgroundFill():IFill
		{
			return _backgroundFill;
		}

		public function set backgroundFill(value:IFill):void
		{
			_backgroundFill = value;
			
			redraw();
		}

		/**
		 * Specifies whether the image is to be smoothed.
		 * Only works if the loader being used is BitmapLoader or BitmapDataLoader.
		 */
		public function get smoothing():Boolean
		{
			return _smoothing;
		}

		public function set smoothing(value:Boolean):void
		{
			_smoothing = value;
			
			if(!imageData) return;
			
			if(!(imageData is Bitmap))
			{
				throw new Error("Smoothing only available if either BitmapLoader or BitmapDataLoader is used.");
				
				_smoothing = false;
					
				return;
			}
			
			Bitmap(imageData).smoothing = value;
		}

		/*
		 * Specifies the image load method.
		 * @see org.tractionas3.media.ImageLoadMethod
		 */
		public function get loadMethod():uint
		{
			return _loadMethod;
		}

		/**
		 * Specifies whether the image is to be scaled to fit within the <code>imageWidth</code> and <code>imageHeight</code> dimension.
		 */
		public function get scaleImage():Boolean
		{
			return _scaleImage;
		}

		public function set scaleImage(value:Boolean):void
		{
			_scaleImage = value;
			
			redraw();
		}

		/**
		 * Specifies whether the image is to be scaled and forced to fill the <code>imageWidth</code> and <code>imageHeight</code> dimension.
		 */
		public function get scaleFill():Boolean
		{
			return _scaleFill;
		}

		public function set scaleFill(value:Boolean):void
		{
			_scaleFill = value;
			
			redraw();
		}

		/**
		 * Specifies the align of the image scale.
		 * 
		 * @see org.tractionas3.geom.Align
		 */
		public function get scaleAlign():String
		{
			return _scaleAlign;
		}

		public function set scaleAlign(value:String):void
		{
			_scaleAlign = value;
			
			redraw();
		}

		/**
		 * Specifies the image width
		 */
		public function get imageWidth():Number
		{
			return imageSize.width;
		}

		public function set imageWidth(value:Number):void
		{
			imageSize.width = value;
			
			redraw();
		}

		/**
		 * Specifies the image heignt
		 */
		public function get imageHeight():Number
		{
			return imageSize.height;
		}

		public function set imageHeight(value:Number):void
		{
			imageSize.height = value;
			
			redraw();
		}

		/**
		 * @private
		 */
		override public function draw():void
		{
			if(imageSize.width > 0 && imageSize.height > 0)
			{
				scrollRect = new Rectangle(0, 0, imageWidth, imageHeight);
			}
			else
			{
				scrollRect = null;
			}
			
			if(!stage) return;

			if(imageData)
			{
				if(imageData is Bitmap)
				{
					Bitmap(imageData).smoothing = smoothing;
				}
				else
				{
					_smoothing = false;
				}
				
				if(_scaleImage)
				{
					if(imageSize.width > 0 && imageSize.height > 0)
					{
						DisplayObjectUtil.fitWithinRectangle(imageData, new Rectangle(0, 0, imageWidth, imageHeight), _scaleFill, _scaleAlign);
					}
				}
			}
			
			if(_backgroundFill)
			{
				_backgroundFill.begin(graphics, new Dimension(imageWidth, imageHeight));
				
				graphics.drawRect(0, 0, imageWidth, imageHeight);
				
				_backgroundFill.end(graphics);
			}
		}

		/**
		 * @private
		 */
		override public function clear():void
		{
			graphics.clear();
		}

		/**
		 * @private
		 */
		final override protected function onAddedToStageInternal(e:Event = null):void
		{
			super.onAddedToStageInternal(e);
			
			if(!imageLoader) return;
			
			if(_loadMethod == ImageLoadMethod.ADDED_TO_STAGE)
			{
				load();
			}
			else if(_loadMethod == ImageLoadMethod.LAZY)
			{
				_lazyLoadInterval = setInterval(lazyLoad, 500);
			}
		}

		/**
		 * @private
		 */
		final override protected function onRemovedFromStageInternal(e:Event = null):void
		{
			super.onRemovedFromStageInternal(e);
			
			clearInterval(_lazyLoadInterval);
		}

		protected function onLoadComplete():void
		{
			return;
		}

		protected function onLoadProgress():void
		{
			return;
		}

		protected function onLoadStart():void
		{
			return;
		}

		protected function onLoadError():void
		{
			log("Image was not found, or a security error occured.");
			
			backgroundFill = new SolidFill(0xff0000);
		}

		private function lazyLoad():void 
		{
			if(!stage) return;
			
			if(imageLoader.loading || imageLoader.loaded)
			{
				clearInterval(_lazyLoadInterval);
				
				return;
			}
			
			var lp:Point = localToGlobal(new Point(0, 0));
			
			var lr:Rectangle = new Rectangle(lp.x, lp.y, imageWidth, imageHeight);
			
			var sr:Rectangle = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
			
			if(sr.intersects(lr) || sr.containsRect(lr))
			{
				clearInterval(_lazyLoadInterval);
				
				load();
			}
		}

		private function setImage(data:*):void 
		{
			if(data is BitmapData)
			{	
				imageData = new Bitmap(data as BitmapData);
			}
			else
			{
				imageData = data;
			}
			
			imageDataContainer.addChild(imageData);
			
			redraw();
		}

		private function getDisplayLoader(source:*):DisplayLoader
		{
			switch(true)
			{
				case source is DisplayLoader:
				case source is BitmapLoader:
				case source is BitmapDataLoader:
					
					return source as DisplayLoader;
					
					break;
				
				case source is String:
					
					return new BitmapLoader(source as String);
					
					break;
				
				case source is URLRequest:
				
					return new BitmapLoader(URLRequest(source).url);
					
					break;
				
				default:
					
					throw new ArgumentError("Image source parameter must be one of the following types: String, URLRequest, DisplayLoader, BitmapLoader or BitmapDataLoader");
					
					return null;
					
					break;
			}
		}

		private function handleLoaderEvent(e:LoaderEvent):void 
		{
			switch(e.type)
			{
				case LoaderEvent.START:
					
					onLoadStart();
					
					_progress = 0;
					
					break;
				
				case LoaderEvent.PROGRESS:
					
					onLoadProgress();
					
					_progress = imageLoader.progress;
					
					dispatchEvent(new LoaderEvent(LoaderEvent.PROGRESS));
					
					break;
				
				case LoaderEvent.IO_ERROR:
				case LoaderEvent.SECURITY_ERROR:
					
					onLoadError();
					
					_progress = 0;
					
					break;
								
				case LoaderEvent.COMPLETE:
					
					setImage(imageLoader.data);
					
					imageLoader.removeAllEventListeners();
					
					imageLoader = null;
					
					_progress = 1;
					
					onLoadComplete();
					
					dispatchEvent(new LoaderEvent(LoaderEvent.COMPLETE));
					
					break;
			}
		}
	}
}
