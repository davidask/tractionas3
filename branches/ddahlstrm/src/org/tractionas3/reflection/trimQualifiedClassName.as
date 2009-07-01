package org.tractionas3.reflection 
{
	public function trimQualifiedClassName(className:String):String
	{
		return (className.indexOf("::") > 0) ? className.split("::")[1] : className;
	}
}
