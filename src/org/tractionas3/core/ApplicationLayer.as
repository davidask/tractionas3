package org.tractionas3.core 
{
	import org.tractionas3.display.DrawableSprite;

	internal class ApplicationLayer extends DrawableSprite 
	{
		private var _layerName:String;
		
		public function ApplicationLayer(layerName:String)
		{
			super();
			
			_layerName = layerName;
		}
		
		public function get layerName():String
		{
			return _layerName;
		}
	}
}
