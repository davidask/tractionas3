package org.tractionas3.net
{
	public function getFileExtension(value:String):String 
	{
		value =  value.indexOf('?') == -1 ? value : value.substring(0, value.indexOf('?'));
		
		return value.substr(value.lastIndexOf('.') + 1).toLowerCase();
	}
}
