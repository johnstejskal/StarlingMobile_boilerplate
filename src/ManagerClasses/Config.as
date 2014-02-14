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
	import singleton.Core;
	import starling.animation.Juggler;
	import starling.display.Image;
	import starling.textures.Texture;
	import vo.Constants;
	import vo.Data;
	import vo.Settings;
	import vo.SpriteSheets;


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
			



		}	
	

	}
		
		


		

		
	

}