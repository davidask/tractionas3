package org.tractionas3.load
{
	import org.tractionas3.load.loaders.LoaderCore;
	import org.tractionas3.net.MimeType;
	import org.tractionas3.net.getFileExtension;
	public function createQualifiedLoader(url:String):LoaderCore 
	{
		
		var mimeType:MimeType = MimeType.getMimeTypeByExtension(getFileExtension(url));
		
		if(!mimeType)
		{
			return null;
		}
		
		if(!mimeType.hasLoadSupport)
		{
			return null;
		}
		
		var loaderClass:Class = mimeType.loaderClass;
		
		var loader:LoaderCore = new loaderClass() as LoaderCore;
		
		loader.url = url;
		
		return loader;
	}
}
