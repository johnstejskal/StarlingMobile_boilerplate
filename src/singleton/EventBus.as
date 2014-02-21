﻿package singleton  {
	

	import flash.display.MovieClip;
	import flash.display.Stage;
	import org.osflash.signals.DeluxeSignal;
	import org.osflash.signals.Signal;


	import flash.events.EventDispatcher;
	



	public class EventBus extends EventDispatcher{
		
		private static var instance: EventBus;
		private static var _privateNumber:Number = Math.random();
		
		private  var _arrSignals:Array = [];
		
		

		//----------------------------------------o
		//------ Declare Events 
		//----------------------------------------o		
		
		
		public var sig_timeOver:Signal;
		public var sig_playerDied:Signal;
		public var sigOnStartClicked:Signal;
		public var sigOnDeactivate:Signal;
		public var sigStarlingStageReady:Signal;
		

		public function defineSignal(signal:Signal, callback:Function):void
		{
			//signal = new Signal();
			//signal.add(callback)
			//_arrSignals.push(signal);
			//trace(EventBus+"New Signal Defined:"+signal)
			//trace(EventBus+"sigOnStartClicked:"+sigOnStartClicked)
		}
	
		

		public  function removeAllSignals():void
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
