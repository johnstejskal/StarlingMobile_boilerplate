package ManagerClasses 
{

	import adobe.utils.CustomActions;
	import com.bumpslide.util.Delegate;
	import com.johnstejskal.FaceBook;
	import flash.display.Loader;
	import flash.external.ExternalInterface;
	import ManagerClasses.CustomEvents.ScreenReadyEvent;
	import ManagerClasses.CustomEvents.StateCleanUpEvent;
	import org.osflash.signals.Signal;
	import singleton.EventBus;
	import starling.core.Starling;

	import view.components.screens.SplashScreen;

	import view.components.screens.PlayScreen;
	import view.components.screens.TitleScreen;
	import vo.Constants;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	import singleton.Core;




	/**
	 * ...
	 * @author John Stejskal
	 * johnstejskal@gmail.com
	 * 
	 */
	public class StateMachine 
	{
		
		public static const STATE_TITLE:String = "title";
		public static const STATE_INTRO:String = "intro";		
		public static const STATE_PLAY:String = "play";		
		public static const STATE_GAME_OVER:String = "gameOver";
		public static const STATE_WIN:String = "win";
		public static const STATE_SCORES:String = "scores"
		public static const STATE_SETUP:String = "setup"
		
		public static const STATE_DEACTIVATE:String = "deactivate"		

		public static var currentGameState:String;
		
		public static var _oTitleScreen:TitleScreen;
		public static var _oPlayScreen:PlayScreen;
		public static var _oSplashScreen:SplashScreen;
		public static var _levelToLoad:String = "level1";

		public function StateMachine() 
		{
			/* This state machine should remail losely coupled to other manager classes
			 * The only should only be aware of the EventBus and Core Singletons
			 */
			
		}
		
		public static function init():void
		{
			trace(StateMachine + "init()");
			_oSplashScreen = new SplashScreen();
			_oSplashScreen.x = 0;
			_oSplashScreen.y = 0;
			Core.getInstance().main.addChild(_oSplashScreen);
			
			changeState(STATE_SETUP);					
		}
		
		
		//this fires when the setup state manager reeives an iscompleted callbak from the playscreen
		static public function setup_callBack():void
		{
			changeState(STATE_TITLE);
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
		
		
		public static function changeState(state:String):void
		{
			trace("StateMachine requested changeState(" + state + ")");
			
			switch(state)
			{
				//------------------------------------------------------------------------------------o
				case STATE_SETUP:
				//----------------------o
				//-- Map Signals
				//----------------------o
				EventBus.getInstance().defineSignal(EventBus.sigOnDeactivate, changeState, STATE_DEACTIVATE)
					
				
				if (!Core.getInstance().starling.isStarted)
				Core.getInstance().starling.start();
					break;	
					
				//------------------------------------------------------------------------------------o
				
				case STATE_INTRO:
					currentGameState = STATE_INTRO;
				break;	
				
				//------------------------------------------------------------------------------------o
			    case STATE_TITLE:
				
					_oTitleScreen = new TitleScreen();
					_oTitleScreen.x = _oTitleScreen.y = 0;
					currentGameState = STATE_TITLE;
					EventBus.getInstance().defineSignal(EventBus.sigOnStartClicked, changeState, String)
					
					//EventBus.getInstance().sigOnStartClicked = new Signal(String);
					//EventBus.getInstance().sigOnStartClicked.add(onSignal_startGame) 
					
				break;

				//------------------------------------------------------------------------------------o
				case STATE_PLAY:

					currentGameState = STATE_PLAY;	
					
					if (_oTitleScreen)
					_oTitleScreen.trash();	
					
					if (_oSplashScreen)
					_oSplashScreen.trash();
					
					if (!Core.getInstance().starling.isStarted)
					Core.getInstance().starling.start();
					
					//_oPlayScreen = new PlayScreen();
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
			trace("StateMachine completed changeState(" + state + ")");
		}
		

		

		

		

		

		

		






		


		
		
	}

}