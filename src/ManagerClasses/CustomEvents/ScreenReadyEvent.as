package ManagerClasses.CustomEvents 
{
	import starling.events.Event;
	/**
	 * ...
	 * @author John Stejskal
	 */
	public class ScreenReadyEvent extends Event
	{
		public static const ON_READY:String = "onReady";
		public var customMessage:String = "";
		
		public function ScreenReadyEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false):void
        {	
			//we call the super class Event
			super(type, bubbles, cancelable);
		}
		
	}

}



