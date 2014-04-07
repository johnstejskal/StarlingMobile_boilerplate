package ManagerClasses 
{

	import adobe.utils.CustomActions;
	import com.johnstejskal.FaceBook;
	import flash.display.Loader;
	import flash.external.ExternalInterface;
	import flash.security.SignatureStatus;
	import org.osflash.signals.Signal;
	import singleton.EventBus;
	import starling.core.Starling;
	import starling.display.Sprite;
	import staticData.SpriteSheets;
	import view.components.screens.Screen;
	import view.StarlingStage;

	import view.components.screens.SplashScreen;

	import view.components.screens.PlayScreen;
	import view.components.screens.TitleScreen;
	import staticData.Constants;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	import singleton.Core;

	//===============================================o
	/**
	 * @author John Stejskal
	 * johnstejskal@gmail.com
	 * "Why walk when you can ride"
	 */
	//===============================================o
	
	 //---------------------------o
	 // This state machine is in charge of listeneing to events from the EventBus
	 // and executing state changes, 

	public class StateMachine 
	{
		
		//Screen STATES
		public static const STATE_TITLE:String = "title";
		public static const STATE_INTRO:String = "intro";		
		public static const STATE_PLAY:String = "play";		
		public static const STATE_GAME_OVER:String = "gameOver";
		public static const STATE_WIN:String = "win";
		public static const STATE_SCORES:String = "scores"
		public static const STATE_SETUP:String = "setup"
		
		
		//Device States
		public static const STATE_DEACTIVATE:String = "deactivate"		

		//
		public static var currentScreenState:String;
		public static var prevScreenState:String;
		static private var currentScreenObject:Screen;
		
		public static var oStarlingStage:StarlingStage;
		
		//Screen Components
		public static var _oTitleScreen:TitleScreen;
		public static var _oPlayScreen:PlayScreen;
		public static var _oSplashScreen:SplashScreen;
		

		static private var core:Core;
		static private var _currStateAssets:Array;




		public function StateMachine() 
		{

			
		}
		

		
		//===============================================o
		//--- Setup
		//===============================================o
		static public function setup():void
		{
			
			core = Core.getInstance();
			core.controlBus = new ControlBus(oStarlingStage);
			
			_currStateAssets = new Array();
			//----------------------o
			//-- Device And Core Signals
			//----------------------o
			EventBus.getInstance().sigOnDeactivate = new Signal();
			EventBus.getInstance().sigOnDeactivate.add(evtOnDeactivate);
			
			EventBus.getInstance().sigStarlingStageReady = new Signal();
			EventBus.getInstance().sigStarlingStageReady.addOnce(evtStarlingStageReady);
			
			EventBus.getInstance().sigScreenChangeRequested = new Signal(String);
			EventBus.getInstance().sigScreenChangeRequested.add(evtScreenChangeRequested);
			
			//setup is complete, set screenState
			changeScreenState(STATE_TITLE);
			
		}
		
		//=======================================================================================o
		//=======================================================================================o
		//-- Custom Signal Event Callbacks
		//=======================================================================================o
		//=======================================================================================o
		
		//==========================================================o
		//-- Custom Event :  Screen Change request
		//==========================================================o
		static public function evtScreenChangeRequested(newState:String):void
		{
			trace(StateMachine + "evtStateChangeRequested()" + newState)
			changeScreenState(newState);
		}		
		//===============================================o
		//-- Device has been deactivated
		//===============================================o		
		static private function evtOnDeactivate():void 
		{
			//changeState(STATE_DEACTIVATE);
		}
		
		//===============================================o
		//-- Startling Stage is ready
		//===============================================o
		static public function evtStarlingStageReady():void
		{
			setup();
			
		}
		
		//=======================================================================================o
		
		
		
		//===============================================o
		//--- Change Screen State
		//===============================================o
		protected static function changeScreenState(newState:String):void
		{
	
			trace(StateMachine+" changeScreenState(" + newState + ")");
			if (newState == currentScreenState)
			return;
			
			if (currentScreenState != null)
			prevScreenState = currentScreenState;
			
			
			if (currentScreenObject != null)
			{
			currentScreenObject.trash();
			currentScreenObject = null;
			}
			

			AssetsManager.disposeAll();
			
			
			
			switch(newState)
			{
				//------------------------------------------------------------------------------------o
				case STATE_INTRO:
					currentScreenState = STATE_INTRO;
				break;	
				
				//------------------------------------------------------------------------------------o
				case STATE_TITLE:
				
					_oTitleScreen = new TitleScreen();
					currentScreenState = STATE_TITLE;
					currentScreenObject = _oTitleScreen;
					

					AssetsManager.loadTextureFromFile(SpriteSheets.TA_PATH_GAME_BG, SpriteSheets.SPRITE_ATLAS_GAME_BG,  stateLoaded);
					AssetsManager.loadTextureFromFile(SpriteSheets.TA_PATH_TITLE_SCREEN, SpriteSheets.SPRITE_ATLAS_TITLE_SCREEN, stateLoaded );
				
				break;

				//------------------------------------------------------------------------------------o
				case STATE_PLAY:
					
					_oPlayScreen = new PlayScreen();
					currentScreenState = STATE_PLAY;
					currentScreenObject = _oPlayScreen;
					
					AssetsManager.loadTextureFromFile(SpriteSheets.TA_PATH_ACTION_ASSETS, SpriteSheets.SPRITE_ATLAS_ACTION_ASSETS,  stateLoaded);
					AssetsManager.loadTextureFromFile(SpriteSheets.TA_PATH_GAME_BG, SpriteSheets.SPRITE_ATLAS_GAME_BG,  stateLoaded);
				
				break;
				
				//------------------------------------------------------------------------------------o
				
				case STATE_GAME_OVER:


				break;	
				
				//------------------------------------------------------------------------------------o
				
				case STATE_WIN:


				break;		
				
				//------------------------------------------------------------------------------------o					
				
				case STATE_SCORES:

				break;	
				//------------------------------------------------------------------------------------o					
				
				default:
				//no state found, revert to default home
				changeScreenState(STATE_TITLE)
				break;					
	
				
			}
			
		}
		
		//==========================================================o
		//- State Loaded Callback From AssetStateMachine
		//==========================================================o
		static public function stateLoaded():void 
		{
			trace(StateMachine + "stateLoaded():" + currentScreenState + " has loaded");
			
			if (currentScreenObject)
			{
				currentScreenObject["loaded"]();
				oStarlingStage.addChildAt(currentScreenObject, 0);

				if (!currentScreenObject.manualRemoveDim)
				core.controlBus.controller_appUI.removeFillOverlay();
			}
		}		

		

		

		

		

		

		






		


		
		
	}

}