package 
{
	public function toBoolean(value:*):Boolean
		{
			if(value == "true" || value == "1" || value == "yes" || value == "on") return true;
			
			if(value == "false" || value == "0" || value == "no" || value == "off" || value == null || value == undefined || value == "null" || value == "undefined" || value == "nil") return false;
			
			return false;
		}
}
