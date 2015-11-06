package view.components.screens.mvcScreen
{


	import com.bumpslide.util.Delegate;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Linear;
	import com.greensock.TweenLite;
	import com.johnstejskal.StarlingUtil;
	import flash.sampler.NewObjectSample;
	import flash.security.SignatureStatus;
	import interfaces.iScreen;
	import ManagerClasses.AssetsManager;
	import ManagerClasses.StateMachine;
	import org.gestouch.events.GestureEvent;
	import org.gestouch.gestures.SwipeGesture;
	import org.osflash.signals.Signal;
	import singleton.Core;
	import singleton.EventBus;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import data.Data;
	import data.settings.DeviceSettings;
	import data.constants.SpriteSheets;
	import view.components.screens.mvcScreen.controller.MvcScreenController;
	import view.components.screens.mvcScreen.model.MvcScreenModel;
	import view.components.screens.mvcScreen.view.MvcScreenView;


	import data.constants.Constants;


	
	/**
	 * @author John Stejskal
	 * "Why walk when you can ride"
	 */
	


	 
	public class MvcScreen extends Sprite
	{


		private var _mvcScreenModel:MvcScreenModel;
		private var _mvcScreenView:MvcScreenView;
		private var _mvcScreenController:MvcScreenController;
		
		//----------------------------------------o
		//------ Constructor 
		//----------------------------------------o
		public function MvcScreen():void 
		{

			_mvcScreenModel = new MvcScreenModel();
			_mvcScreenController = new MvcScreenController();
			_mvcScreenView = new MvcScreenView(_mvcScreenModel, _mvcScreenController);
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
			_mvcScreenModel.sig_gameOver = new Signal();
			_mvcScreenModel.sig_gameOver.add(evt_gameOver);
			
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			AssetsManager.loadTextureFromFile(SpriteSheets.TA_PATH_GAME_BG, SpriteSheets.SPRITE_ATLAS_GAME_BG,  this.loaded);
			AssetsManager.loadTextureFromFile(SpriteSheets.TA_PATH_TITLE_SCREEN, SpriteSheets.SPRITE_ATLAS_TITLE_SCREEN, this.loaded );
			
		}
		
		private function evt_gameOver():void 
		{
			_mvcScreenView.trash()
		}

		//----------------------------------------o
		//------ Assets loaded callback 
		//----------------------------------------o
		private function loaded():void 
		{
			trace(this + "loaded()");
			_mvcScreenView.init()
			
		}
		
	
}