package ManagerClasses 
{
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import singleton.Core;
	import singleton.EventBus;
	/**
	 * @author John Stejskal
	 * "Why walk when you can ride"
	 */
	public class MobileSoftKeys 
	{
		
		private var _core:Core;
		private const _stage:Main = Core.getInstance().main;
		
		
		//----------------------------------------o
		//------ Constructor
		//----------------------------------------o				
		public function MobileSoftKeys() 
		{
			_core = Core.getInstance();
			
			
		}
		//----------------------------------------o
		//------ init
		//----------------------------------------o				
		public static function init():void
		{
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
			NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, onDeactivate);
			NativeApplication.nativeApplication.addEventListener(Event.EXITING, onDeactivate); //iphone specific for home button
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		static private function onDeactivate(e:Event):void 
		{
			EventBus.sigOnDeactivate.dispatch();
		}
		


		//----------------------------------------o
		//------ Private Methods 
		//----------------------------------------o		
		//----------------------------------------o
		//------ Public Methods 
		//----------------------------------------o	
		//----------------------------------------o
		//------ Event Handlers
		//----------------------------------------o		
		
	}

}