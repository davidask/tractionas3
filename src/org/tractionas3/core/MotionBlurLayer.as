package org.tractionas3.core 
{
	import flash.display.BlendMode;
	import org.tractionas3.core.interfaces.IRenderable;
	import org.tractionas3.data.collection.ArrayCollection;
	import org.tractionas3.display.CoreSprite;
	import org.tractionas3.events.EnterFrame;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;

	public class MotionBlurLayer extends ApplicationLayer implements IRenderable
	{
		public static const NAME:String = "MotionBlurLayer";

		private static var _instance:MotionBlurLayer;

		public static function getInstance():MotionBlurLayer
		{
			return _instance ? _instance : _instance = new MotionBlurLayer(new SingletonEnforcer());
		}

		private var _referencePositionMap:ArrayCollection;

		private var _referenceMap:ArrayCollection;
		
		private var _referenceBitmapMap:ArrayCollection;

		public function MotionBlurLayer(singletonEnforcer:SingletonEnforcer)
		{
			super(NAME);
			
			if(!singletonEnforcer)
			{
				throw new ArgumentError("MotionBlurLayer is a singleton class and may only be accessed via its accessor method getInstance()."); 
			}
			
			_referencePositionMap = new ArrayCollection();
			
			_referenceMap = new ArrayCollection();
			
			_referenceBitmapMap = new ArrayCollection();
			
			mouseEnabled = false;
			
			mouseChildren = false;
		}

		public function addInstance(instance:CoreSprite):void
		{
			instance.alpha = 0; //TODO Hide original object
			
			_referenceMap.addItem(instance);
			
			_referencePositionMap.addItem(instance.localToGlobal(new Point()));
			
			var bitmap:Bitmap = new Bitmap();
			
			bitmap.smoothing = true;
			
			_referenceBitmapMap.addItem(bitmap);
			
			addChild(bitmap);
		}

		public function removeInstance(instance:CoreSprite):void
		{
			var index:int = _referenceMap.getItemIndex(instance);
			
			_referencePositionMap.removeItemAt(index);
			
			var bitmap:Bitmap = _referenceBitmapMap.getItemAt(index);
			
			if(bitmap)
			{
				_referenceBitmapMap.removeItemAt(index);
				
				if(contains(bitmap))
				{
					removeChild(bitmap);
				}
			}
			
			_referenceMap.removeItem(instance);
		}

		public function startRender():void
		{
			EnterFrame.addEnterFrameHandler(render);
		}

		public function stopRender():void
		{
			EnterFrame.removeEnterFrameHandler(render);
		}

		public function get rendering():Boolean
		{
			return EnterFrame.hasEnterFrameHandler(render);
		}

		public function render():void
		{
			var instance:CoreSprite, i:int, lastPosition:Point, currentPostition:Point, bitmap:Bitmap;
			
			var angle:Number, positionDifference:Point, positionDifference2D:Number;
			
			var bmd:BitmapData, bmdSize:Number, tmpBmd:BitmapData, blurFilter:BlurFilter, sqrtSize:Number;
			
			var transMat:Matrix, widthDifference:Number, heightDifference:Number;
			
			for(i = 0;i < _referenceMap.count;i++)
			{
				instance = _referenceMap.getItemAt(i) as CoreSprite;
				
				bitmap = _referenceBitmapMap.getItemAt(i);
				
				lastPosition = _referencePositionMap.getItemAt(i) as Point;
				
				currentPostition = instance.localToGlobal(new Point());
				
				
				positionDifference = currentPostition.subtract(lastPosition);
				
				positionDifference2D = Math.sqrt(Math.pow(positionDifference.x, 2) + Math.pow(positionDifference.y, 2));
				
				
				//TODO Implement properly
				if(Math.abs(positionDifference.x + positionDifference.y) < 1)
				{
					instance.alpha = 1;
					bitmap.alpha = 0;
					continue;
				}
				else
				{
					bitmap.alpha = 1;
					instance.alpha = 0;
				}
				
				angle = Math.atan2(positionDifference.y, positionDifference.x);
				
				angle = radiansToDegrees(angle);
				
				
				sqrtSize = Math.sqrt(Math.pow(instance.width, 2) + Math.pow(instance.height, 2));
				
				bmdSize = sqrtSize + Math.min(positionDifference2D, 500);
				
			
				bmd = new BitmapData(bmdSize, bmdSize, true, 0x00888888);
				
				widthDifference = bmdSize - instance.width;
				heightDifference = bmdSize - instance.height;
				
				transMat = new Matrix();
				transMat.translate(bmdSize * 0.5 - instance.width * 0.5, bmdSize * 0.5 - instance.height * 0.5);
				
				bmd.draw(instance, transMat);
				
				
				transMat.identity();
				transMat.translate(-bmd.width * 0.5, -bmd.height * 0.5);
				transMat.rotate(degreesToRadians(-angle));
				transMat.translate(bmd.width * 0.5, bmd.height * 0.5);
				
				
				tmpBmd = bmd.clone();
				bmd.fillRect(bmd.rect, 0x00FF0000);
				bmd.draw(tmpBmd, transMat);
				
				blurFilter = new BlurFilter(Math.min(100, positionDifference2D), 0, 3);
				
				tmpBmd = new BitmapData(bmdSize, bmdSize, true, 0x0000FF00);
				tmpBmd.applyFilter(bmd, bmd.rect, new Point(), blurFilter); 
				
				transMat.identity();
				transMat.translate(-tmpBmd.width * 0.5, -tmpBmd.height * 0.5);
				transMat.rotate(degreesToRadians(angle));
				transMat.translate(tmpBmd.width * 0.5, tmpBmd.height * 0.5);
				
				bmd = new BitmapData(tmpBmd.width, tmpBmd.height, true, 0x00FF0000);
				bmd.draw(tmpBmd, transMat);
			
				
				bitmap.bitmapData = bmd;
				
				bitmap.x = instance.x - widthDifference * 0.5;
				
				bitmap.y = instance.y - heightDifference * 0.5;
				
				lastPosition.x = currentPostition.x;
				
				lastPosition.y = currentPostition.y;
			}
		}
	}
}

internal class SingletonEnforcer 
{
}
