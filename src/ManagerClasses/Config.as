package ManagerClasses 
{
	import air.net.URLMonitor;
	import data.AppData;
	import data.constants.BaseResolution;
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.ProgressEvent;
	import flash.events.StatusEvent;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import singleton.Core;
	import starling.animation.Juggler;
	import starling.display.Image;
	import starling.textures.Texture;
	import data.settings.DeviceSettings;
	import data.settings.PublicSettings;
	import data.constants.SpriteSheets;


	/**
	 * ...
	 * @author john stejskal
	 * www.johnstejskal.com
	 * johnstejskal@gmail.com
	 * "Why walk when you can ride"
	 */
	
	public class Config 
	{
		private var _core:Core;
		private var _stage:Stage;


		//========================================o
		//------ Constructor
		//========================================o			
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
		
		
		//========================================o
		//------ Setup
		//-- establish device settings
		//========================================o		
		private function setup():void
		{
			trace(this + "setup()");
			//setup global animation juggler
			_core.animationJuggler = new Juggler();

			
			if (PublicSettings.DEBUG_RELEASE)
			PublicSettings.DEVICE_RELEASE = true;
			
			if (PublicSettings.DEVICE_RELEASE)
			{
				if(DeviceSettings.KEEP_DEVICE_AWAKE)
				NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
				
				Multitouch.inputMode = DeviceSettings.TOUCH_INPUT_MODE;
				
				AppData.deviceResX = _stage.fullScreenWidth;
				AppData.deviceResY = _stage.fullScreenHeight;
			}
			else 
			{
				AppData.deviceResX = _stage.stageWidth;
				AppData.deviceResY = _stage.stageHeight;
			}
			
			if (PublicSettings.DEBUG_RELEASE)
			{
				AppData.deviceResX = _stage.stageWidth;
				AppData.deviceResY = _stage.stageHeight;
			}
			
			AppData.baseResX = BaseResolution.BASE_RES_X;
			AppData.baseResY = BaseResolution.BASE_RES_Y;			

			AppData.deviceScaleX = AppData.deviceResX / AppData.baseResX;
			AppData.deviceScaleY = AppData.deviceResY / AppData.baseResY;
			
			
			trace(Config+" device size established baseX:"+BaseResolution.BASE_RES_X +" baseY:"+BaseResolution.BASE_RES_Y +" DeviceResX:"+AppData.deviceResX+" DeviceResY:"+AppData.deviceResY)

		}	
		
		
	
		

		
		
		
		
	

	}
		
		


		

		
	

}