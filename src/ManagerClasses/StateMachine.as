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


	/**
	 * ...
	 * @author John Stejskal
	 * johnstejskal@gmail.com
	 * "Why walk when you can ride"
	 */
	
	 //---------------------------o
	 // This state machine is in charge of listeneing to events from the EventBus
	 // and dispatching state changes, 
	 // the only components it should be aware of are the core screen states, 
	 //
	 // TODO Add a param into the state changer which allows for substates, in the sens it does not 
	 // dispose of the previous state, case scenario: a pop-up game over panel on a gameplay screen
	public class StateMachine 
	{
		
		//STATES
		public static const STATE_TITLE:String = "title";
		public static const STATE_INTRO:String = "intro";		
		public static const STATE_PLAY:String = "play";		
		public static const STATE_GAME_OVER:String = "gameOver";
		public static const STATE_WIN:String = "win";
		public static const STATE_SCORES:String = "scores"
		public static const STATE_SETUP:String = "setup"
		
		public static const STATE_DEACTIVATE:String = "deactivate"		

		public static var currentGameState:String;
		
		public static var oStarlingStage:StarlingStage;
		
		//Screen Components
		public static var _oTitleScreen:TitleScreen;
		public static var _oPlayScreen:PlayScreen;
		public static var _oSplashScreen:SplashScreen;
		
		public static var _levelToLoad:String = "level1";

		public function StateMachine() 
		{

			
		}
		
		public static function init():void
		{
			trace(StateMachine + "init()");
			//_oSplashScreen = new SplashScreen();
			//_oSplashScreen.x = 0;
			//_oSplashScreen.y = 0;
			//Core.getInstance().main.addChild(_oSplashScreen);
			
							
		}
		

		//call this before any state changes to bind 
		static public function setup():void
		{
			//----------------------o
			//-- Map Signals
			//----------------------o
			
			EventBus.getInstance().sigOnDeactivate = new Signal();
			EventBus.getInstance().sigOnDeactivate.add(evtOnDeactivate);
			
			EventBus.getInstance().sigStarlingStageReady = new Signal();
			EventBus.getInstance().sigStarlingStageReady.addOnce(evtStarlingStageReady);
			
		}
		
		static private function evtOnDeactivate():void 
		{
			changeState(STATE_DEACTIVATE);
		}
		
		//this fires when the setup state manager reeives an iscompleted callbak from the StarlingStage
		static public function evtStarlingStageReady():void
		{
			changeState(STATE_TITLE);
		}
		static private function evtOnStartClicked():void 
		{
			trace(StateMachine + "evtOnStartClicked()")
			
			//EventBus.getInstance().sigOnStartClicked.removeAll();
			changeState(STATE_PLAY);
		}
	   /* 
		*------------------------------------------o
		*
		*    ***Finite State Machine Switch***
		* As3 Signals are used for dispatching 
		* state altering events 
		* 
		*------------------------------------------o
		*/
		
		
		protected static function changeState(state:String):void
		{
			trace("-- StateMachine requested changeState(" + state + ")");
			
			switch(state)
			{
				//------------------------------------------------------------------------------------o
				case STATE_INTRO:
					currentGameState = STATE_INTRO;
				break;	
				
				//------------------------------------------------------------------------------------o
			    case STATE_TITLE:
					StateMachine.setup();
					_oTitleScreen = new TitleScreen();
					_oTitleScreen.x = _oTitleScreen.y = 0;
					oStarlingStage.addChild(_oTitleScreen);
					
					currentGameState = STATE_TITLE;
					
					EventBus.getInstance().sigOnStartClicked = new Signal();
					EventBus.getInstance().sigOnStartClicked.addOnce(evtOnStartClicked)
				
					
				break;

				//------------------------------------------------------------------------------------o
				case STATE_PLAY:

					currentGameState = STATE_PLAY;	
					
					_oPlayScreen = new PlayScreen();
					
					if (_oTitleScreen)
					_oTitleScreen.trash();	
					
					if (_oSplashScreen)
					_oSplashScreen.trash();
					
					if (!Core.getInstance().starling.isStarted)
					Core.getInstance().starling.start();
					
					oStarlingStage.addChild(_oPlayScreen);
					
					
					//_oStarlingStage = new PlayScreen();
					_oPlayScreen.init(_levelToLoad);
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
				
	
				
			}
			trace("-- StateMachine completed changeState(" + state + ")");
		}
		

		

		

		

		

		

		

		






		


		
		
	}

}