package ManagerClasses.utility 
{
	import data.constants.Platform;
	import data.settings.DeviceSettings;
	import data.settings.PublicSettings;
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import ManagerClasses.StateMachine;
	import singleton.Core;
	import singleton.EventBus;
	/**
	 * @author John Stejskal
	 * "Why walk when you can ride"
	 */
	public class NativeDeviceSupport 
	{
		private static var core:Core;
		private const _stage:Main = Core.getInstance().main;
		
		//========================================o
		//------ Constructor
		//========================================o		
		public function NativeDeviceSupport() 
		{
			
			
			
		}
		//========================================o
		//------ init
		//========================================o			
		public static function init():void
		{
			core = Core.getInstance();
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
			NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, onDeactivate);
			NativeApplication.nativeApplication.addEventListener(Event.EXITING, onDeactivate); //iphone specific for home button
			
			if(PublicSettings.DEPLOYMENT_PLATFORM == Platform.ANDROID)
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		//========================================o
		//------ Soft key press handler
		//========================================o		
		static private function onKeyDown(e:KeyboardEvent):void 
		{
			e.preventDefault();
			if(e.keyCode == Keyboard.BACK)
			{
				
				if (!StateMachine.currentScreenObject.showBackButton)
				return;
				
				core.controlBus.appUIController.backButtonPressed(true);
              
			}
			else if(e.keyCode == Keyboard.HOME)
			{
				trace(NativeDeviceSupport+"pressed Keyboard.HOME")
				
				NativeApplication.nativeApplication.exit();
			}
			else if(e.keyCode == Keyboard.MENU)
			{
				NativeApplication.nativeApplication.exit();
			}

		}
		
		//========================================o
		//------ Device Activate Handler
		//========================================o			
		static private function onActivate(e:Event):void 
		{
			if(!PublicSettings.DEBUG_RELEASE && DeviceSettings.ENABLE_DEVICE_ACTIVATE)
			EventBus.getInstance().sigOnActivate.dispatch();
		}
		
		//========================================o
		//------ Device Deactivate Handler
		//========================================o			
		static private function onDeactivate(e:Event):void 
		{
			if(!PublicSettings.DEBUG_RELEASE && DeviceSettings.ENABLE_DEVICE_DEACTIVATE)
			EventBus.getInstance().sigOnDeactivate.dispatch();
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