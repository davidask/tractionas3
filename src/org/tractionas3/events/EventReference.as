package org.tractionas3.events 
{
	import org.tractionas3.core.CoreObject;
	import org.tractionas3.core.interfaces.ICoreInterface;
	public class EventReference extends CoreObject implements ICoreInterface 
	{

		private var _type:String;

		private var _listener:Function;

		private var _useCapture:Boolean;

		
		public function EventReference(type:String,listener:Function, useCapture:Boolean)
		{
			super();
			
			_type = type;
			
			_listener = listener;
			
			_useCapture = useCapture;
		}

		public function get type():String
		{
			return _type;
		}

		public function get listener():Function
		{
			return _listener;
		}

		public function get useCapture():Boolean
		{
			return _useCapture;
		}

		override public function destruct(deepDestruct:Boolean = false):void
		{
			_type = null;
			
			_listener = null;
			
			super.destruct(deepDestruct);
		}
	}
}
