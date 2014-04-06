package ManagerClasses 
{

	import adobe.utils.CustomActions;
	import com.bumpslide.util.Delegate;
	import com.johnstejskal.FaceBook;
	import flash.display.Loader;
	import flash.external.ExternalInterface;
	import flash.security.SignatureStatus;
	import ManagerClasses.CustomEvents.ScreenReadyEvent;
	import ManagerClasses.CustomEvents.StateCleanUpEvent;
	import org.osflash.signals.Signal;
	import singleton.EventBus;
	import starling.core.Starling;
	import starling.display.Sprite;
	import staticData.SpriteSheets;
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
	 // and dispatching state changes, 
	 // the only components it should be aware of are the core screen states, 
	 //
	 // TODO Add a param into the state changer which allows for substates, in the sens it does not 
	 // dispose of the previous state, case scenario: a pop-up game over panel on a gameplay screen
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
		public static var currentState:String;
		public static var prevState:String;
		static private var currentStateObject:Sprite;
		
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
			changeState(STATE_DEACTIVATE);
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
			if (newState == currentState)
			return;
			
			if (currentState != null)
			prevState = currentState;
			
			
			if (currentScreenObject != null)
			{
			currentScreenObject.trash();
			currentScreenObject = null;
			}
			
			while (_currStateAssets.length > 0)
			{
			AssetsManager.disposeTexture(_currStateAssets.pop())
			}
			

			switch(newState)
			{
				//------------------------------------------------------------------------------------o
				case STATE_INTRO:
					currentState = STATE_INTRO;
				break;	
				
				//------------------------------------------------------------------------------------o
			    case STATE_TITLE:
					_oTitleScreen = new TitleScreen();
					currentState = STATE_TITLE;
					currentStateObject = _oTitleScreen;
					
					_currStateAssets.push(SpriteSheets.TA_PATH_GAME_BG, SpriteSheets.TA_PATH_TITLE_SCREEN);
					AssetsManager.loadTextureFromFile(SpriteSheets.TA_PATH_GAME_BG, SpriteSheets.SPRITE_ATLAS_GAME_BG,  this.loaded);
					AssetsManager.loadTextureFromFile(SpriteSheets.TA_PATH_TITLE_SCREEN, SpriteSheets.SPRITE_ATLAS_TITLE_SCREEN, this.loaded );
				break;

				//------------------------------------------------------------------------------------o
				case STATE_PLAY:
					_oPlayScreen = new TitleScreen();
					currentState = STATE_PLAY;
					currentStateObject = _oPlayScreen;
					
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
				
				default:
				//no state found, revert to default home
				changeState(STATE_TITLE)
				break;					
	
				
			}
			
		}
		
		//==========================================================o
		//- State Loaded Callback From AssetStateMachine
		//==========================================================o
		static public function stateLoaded():void 
		{
			trace(StateMachine + "stateLoaded():" + currentAppState + " has loaded");
			
			if (currentScreenObject)
			{
				currentScreenObject["loaded"]();
				oStarlingStage.addChildAt(currentScreenObject, 0);

				if (!currentScreenObject.manualRemoveDim)
				_core.controlBus.appUIController.removeFillOverlay();
			}
		}		

		

		

		

		

		

		






		


		
		
	}

}