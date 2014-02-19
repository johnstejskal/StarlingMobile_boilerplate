package ManagerClasses 
{
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import singleton.Core;
	import starling.animation.Juggler;
	import starling.display.Image;
	import starling.textures.Texture;
	import staticData.Constants;
	import staticData.Data;
	import staticData.settings.DeviceSettings;
	import staticData.settings.PublicSettings;
	import staticData.SpriteSheets;


	/**
	 * ...
	 * @author john stejskal
	 * "Why walk when you can ride"
	 */
	
	public class Config 
	{
		private var _core:Core;
		private var _stage:Stage;
		private var loader:Loader;


		//----------------------------------------o
		//------ Constructor
		//----------------------------------------o				
		public function Config() 
		{
			trace(this + "constructed");
			_core = Core.getInstance();
			_stage = _core.main.stage;
			_core.nativeStage = _core.main.stage;
			
			//SET SPRITE SHEET CLASS LOCATION WITHIN AssetsManager
			AssetsManager.SPRITE_SHEET_CLASS = SpriteSheets;
			setup();
		}
		
		
		
		private function setup():void
		{
			trace(this + "setup()");
			_core.animationJuggler = new Juggler();
			
			if (PublicSettings.DEVICE_RELEASE)
			{
				NativeApplication.nativeApplication.systemIdleMode = DeviceSettings.SYSTEM_IDLE_MODE;
				Multitouch.inputMode = DeviceSettings.TOUCH_INPUT_MODE;
				
				Data.deviceResX = _stage.fullScreenWidth;
				Data.deviceResY = _stage.fullScreenHeight;
			}
			else 
			{
				Data.deviceResX = _stage.stageWidth;
				Data.deviceResY = _stage.stageHeight;
			}
			
			Data.baseResX = _stage.width;
			Data.baseResY = _stage.height;				

			Data.deviceScaleX = Data.deviceResX / Data.baseResX;
			Data.deviceScaleY = Data.deviceResY / Data.baseResY;

		}	
		
		
		
		
		
		
		
	

	}
		
		


		

		
	

}