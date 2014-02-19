package singleton  {
	

	import flash.display.MovieClip;
	import flash.display.Stage;
	import org.osflash.signals.DeluxeSignal;
	import org.osflash.signals.Signal;


	import flash.events.EventDispatcher;
	



	public class EventBus extends EventDispatcher{
		
		private static var instance: EventBus;
		private static var _privateNumber:Number = Math.random();
		private static var _arrSignals:Array;
		
		

		//----------------------------------------o
		//------ Declare Events 
		//----------------------------------------o		
		
		
		public static var sig_timeOver:Signal;
		public static var sig_playerDied:Signal;
		public static var sigOnStartClicked:Signal;
		public static var sigOnDeactivate:Signal;
		
		
		public static var sigStarlingReady:Signal;
		

		public function defineSignal(signal:Signal, callback:Function, params:* = null):void
		{
			signal = new Signal(params);
			signal.add(callback)
			_arrSignals.push(signal);
		}
	
		

		public static function removeAllSignals():void
		{
			while (_arrSignals.length > 1)
			{
				Signal(_arrSignals[0]).removeAll();
			}
		}

		
		//----------------------------------------o
		//------ public functions 
		//----------------------------------------o		
		public function EventBus(num:Number=NaN) {
			if(num !== _privateNumber){
				throw new Error("An instance of Singleton already exists. Try EventBus.getInstance()");
			}
			
			_arrSignals = new Array();
			
		}
		
		public static function getInstance() : EventBus {
			if ( instance == null ) instance = new EventBus(_privateNumber);
			return instance as EventBus;
		} 

	}	
}
