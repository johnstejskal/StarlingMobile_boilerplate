package ManagerClasses 
{
	import air.net.URLMonitor;
	import com.johnstejskal.SharedObjects;
	import com.milkmangames.nativeextensions.CoreMobile;
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
	import ManagerClasses.utility.NativeDeviceSupport;
	import ManagerClasses.utility.AssetsManager;
	import ManagerClasses.utility.DeviceType;
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
					

			AppData.deviceScaleX = AppData.deviceResX / BaseResolution.BASE_RES_X;
			AppData.deviceScaleY = AppData.deviceResY / BaseResolution.BASE_RES_Y;
			AppData.deviceScale = AppData.deviceScaleX; 
			AppData.offsetScaleX = AppData.deviceResX / BaseResolution.LAYOUT_RES_X;
			AppData.offsetScaleY = AppData.deviceResY / BaseResolution.LAYOUT_RES_Y;
			
			AppData.deviceScaleX = AppData.deviceResX / BaseResolution.BASE_RES_X;
			AppData.deviceScaleY = AppData.deviceResY / BaseResolution.BASE_RES_Y;
			
			DeviceType.setDeviceType(AppData.deviceResX, AppData.deviceResY);
			
			
			if(CoreMobile.isSupported())
			{
				// call this once at app start up, then CoreMobile will be available for use from then on.
				AppData.isCoreMobileSupported = true;
				CoreMobile.create();
				//NativeApplicationRaterUtil.init();
			}
			else {
				trace("Core Mobile only works on iOS or Android.");
			}
			trace(Config + " device size established baseX:" + BaseResolution.BASE_RES_X +" baseY:" + BaseResolution.BASE_RES_Y +" DeviceResX:" + AppData.deviceResX + " DeviceResY:" + AppData.deviceResY)
			
			
			//======================================o
			//--configure soft keys and native functionality
			NativeDeviceSupport.init();

			//======================================o
			//-- start remote services for launchpad
			//RemoteServices.init();
			
			//======================================o
			//-- Retreive Local Saved Data	
			//SharedObjects.init();
			//if(!DeviceSettings.ENABLE_LOCAL_STORAGE)	
			//SharedObjects.deleteAll();
			
			//SharedObjects.registerData();
			
			//======================================o
			//-- Configure Dynamic Game / App Base Properties
/*			PublicSettings.BASE_GAME_SPEED = AppData.deviceScale * PublicSettings.BASE_GAME_SPEED;
			PublicSettings.MIN_LANE_CHANGE_SPEED = PublicSettings.BASE_GAME_SPEED;
			PublicSettings.NITRO_SPEED = AppData.deviceScale * PublicSettings.NITRO_SPEED;
			PublicSettings.SKID_SHOW_SPEED = AppData.deviceScale * PublicSettings.SKID_SHOW_SPEED;
			PublicSettings.MAX_SPEED = AppData.deviceScale * PublicSettings.MAX_SPEED;*/
			
			
			
		}	
		
		
	
		

		
		
		
		
	

	}
		
		


		

		
	

}