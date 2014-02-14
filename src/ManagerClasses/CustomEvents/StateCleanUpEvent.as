package ManagerClasses.CustomEvents 
{
	import starling.events.Event;
	/**
	 * ...
	 * @author John Stejskal
	 */
	public class StateCleanUpEvent extends Event
	{
		public static const ON_COMPLETE:String = "onComplete";
		public var customMessage:String = "";
		
		public function StateCleanUpEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false):void
        {	
			//we call the super class Event
			super(type, bubbles, cancelable);
		}
		
	}

}



