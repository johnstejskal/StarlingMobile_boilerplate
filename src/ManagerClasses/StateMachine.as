package ManagerClasses 
{

	import adobe.utils.CustomActions;
	import com.johnstejskal.FaceBook;
	import com.johnstejskal.StringFunctions;
	import com.thirdsense.animation.TexturePack;
	import data.constants.AppStates;
	import data.constants.HexColours;
	import data.constants.Platform;
	import data.PlayerData;
	import data.settings.PublicSettings;
	import flash.desktop.NativeApplication;
	import flash.display.Loader;
	import flash.external.ExternalInterface;
	import flash.security.SignatureStatus;
	import flash.system.System;
	import flash.utils.getDefinitionByName;
	import mx.utils.StringUtil;
	import org.osflash.signals.Signal;
	import singleton.EventBus;
	import starling.core.Starling;
	import starling.display.Sprite;
	import data.constants.SpriteSheets;
	import view.components.screens.*;
	import view.components.screens.Screen;
	import view.components.ui.slideOutMenu.SlideOutMenu;
	import view.StarlingStage;

	
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
		//list screen names here for workaround to getDefinitionByName 
		HomeScreen; 


		
		//Device States
		public static const STATE_DEACTIVATE:String = "deactivate"		

		
		public static var currentScreenState:String;
		public static var prevScreenState:String;
		static public var currentScreenObject:Screen;
		
		public static var oStarlingStage:StarlingStage;
		
		//Screen Components
/*		public static var _oTitleScreen:TitleScreen;
		public static var _oPlayScreen:PlayScreen;
		public static var _oSplashScreen:SplashScreen;*/
		

		static private var core:Core;
		static private var _backButtonCrumbCount:int = 0;


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
			
			//----------------------o
			//-- Device And Core Signals
			//----------------------o
			EventBus.getInstance().sigStarlingStageReady = new Signal();
			EventBus.getInstance().sigStarlingStageReady.addOnce(evtStarlingStageReady);
			
			EventBus.getInstance().sigOnDeactivate = new Signal();
			EventBus.getInstance().sigOnDeactivate.add(evtOnDeactivate);
						
			EventBus.getInstance().sigOnActivate = new Signal();
			EventBus.getInstance().sigOnActivate.add(evtOnDeactivate);
			
			EventBus.getInstance().sigSlideMenuAction = new Signal(String);
			EventBus.getInstance().sigSlideMenuAction.add(evtSlideMenuAction);
			
			EventBus.getInstance().sigScreenChangeRequested = new Signal(String);
			EventBus.getInstance().sigScreenChangeRequested.add(evtScreenChangeRequested);
						
			EventBus.getInstance().sigBackButtonPressed = new Signal(Boolean);
			EventBus.getInstance().sigBackButtonPressed.add(evtBackButtonPressed);
			
			//setup is complete, set screenState
			changeScreenState(AppStates.STATE_HOME);
			
		}
		
		//=======================================================================================o
		//=======================================================================================o
		//-- Custom Signal Event Callbacks
		//=======================================================================================o
		//=======================================================================================o

		//==========================================================o
		//-- Custom Event :  Screen Change request
		//==========================================================o
		static public function evtScreenChangeRequested(newState:String, trashLastScreen:Boolean = true, transitionType:String = "standard", valueObject:* = null):void
		{
			trace(StateMachine + "evtStateChangeRequested()" + newState+"valueObject:"+valueObject)
			
			if (newState == AppStates.STATE_LOG_OUT)
			{
				Core.getInstance().controlBus.appUIController.showNotification("LOG OUT","", "Are you sure want to log out?", "YES", null, onLogoutConfirm);
				function onLogoutConfirm():void
				{
					//Services.logout.execute();
					changeScreenState(AppStates.STATE_HOME);
				}
			}
			else
			{
				changeScreenState(newState, trashLastScreen, transitionType, valueObject);
			}
		}
		//==========================================================o
		//-- Custom Event :  Back Button Pressed
		//==========================================================o
		static private function evtBackButtonPressed(softKey:Boolean = false):void 
		{
			 trace(StateMachine + "evtBackButtonClicked()")
			
			if (currentScreenObject != null)
			{
				if (!currentScreenObject.showBackButton)
				return;
			}
			
			if (core.controlBus.appUIController.isNotificationActive)
			return;
			
			if (softKey && currentScreenState == AppStates.STATE_HOME && PublicSettings.DEPLOYMENT_PLATFORM == Platform.ANDROID)
			{
				NativeApplication.nativeApplication.exit();
				return;
			}
			
			//send player back to home screens when back button is pressed more than ones concecutively 	
			if (_backButtonCrumbCount >= 1)
			{
				if (PlayerData.isLoggedIn)
				{
					changeScreenState(AppStates.STATE_HOME);
				}
				if (!PlayerData.isLoggedIn)
				{
					changeScreenState(AppStates.STATE_SPLASH);
				}
					
				_backButtonCrumbCount = 0;
			}
			else
			{
				changeScreenState(prevScreenState);
			}
				
			_backButtonCrumbCount++;

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

		//==========================================================o
		//-- Custom Event :  Menu Button Clicked
		//==========================================================o
		static private function evtSlideMenuAction(newState:String):void 
		{

			//if slide menu is closed
			if (core.controlBus.appUIController.currSlideMenuState == SlideOutMenu.STATE_CLOSE)
			{
				currentScreenObject.deactivate();
			}
			//if slide menu is open
			else
			{

			}
			
			core.controlBus.appUIController.changeSlideMenuState(newState);
			
		}
		//=======================================================================================o
		
		
		
		//===============================================o
		//--- Change Screen State
		//===============================================o
		protected static function changeScreenState(newState:String, trashLastScreen:Boolean = true, transitionType:String = "standard", valueObject:* = null, force:Boolean = false):void
		{
	
			trace(StateMachine+" changeScreenState(" + newState + ")");
			if (newState == currentScreenState && !force)
			{
				trace(StateMachine+"New state is same as current state, ending...");
				return;
			}
			
			_backButtonCrumbCount = 0;
			if (trashLastScreen && currentScreenObject != null)
			{
				core.controlBus.appUIController.deactivateTitleBar();
				
				if (transitionType == "standard")
				{
					currentScreenObject.animateOut(function():void {
				    trashCurrentScreen();
					finaliseScreenChange(newState, valueObject);
					});
				}
				else
				{
					trashCurrentScreen();
					finaliseScreenChange(newState, valueObject);
				}
			}
			else
			{
				finaliseScreenChange(newState, valueObject);
			}
		}
		
		
		//===============================================o
		//--- Trash Existing / Previous Screen 
		//===============================================o
		static private function trashCurrentScreen():void 
		{
			trace(StateMachine+"trashCurrentScreen()");
			
			currentScreenObject.trash();
			currentScreenObject = null;

			core.controlBus.appUIController.removeBG();
		
			Starling.juggler.purge();
			core.animationJuggler.purge();
			TexturePack.deleteAllTexturePacks();
			System.gc();
		}
		
		//===============================================o
		//--- Change Screen State
		//===============================================o
		static private function finaliseScreenChange(newState:String, valueObject:* = null ):void 
		{
			trace(StateMachine + "finaliseScreenChange(" + newState + ")");
		
			if(currentScreenState != null)
			prevScreenState = currentScreenState;
			else
			prevScreenState = newState;
	
            var ClassReference:Class = getDefinitionByName("view.components.screens."+StringFunctions.upperCaseFirst(newState) + "Screen") as Class;
		    currentScreenObject = new ClassReference();
			
			if (valueObject != null)
			currentScreenObject.valueObject = valueObject;
			switch(newState)
			{
				
				//------------------------------------------------------------------------------------o
				case AppStates.STATE_INTRO:
					
				break;	
				//------------------------------------------------------------------------------------o
		    	case AppStates.STATE_HOME:
				currentScreenObject.displayName = "HOME";
				currentScreenObject.showTitleBar = true;
				currentScreenObject.showBackButton = true;
				currentScreenObject.showMenuIcon = true;
				break;					
				//------------------------------------------------------------------------------------o
				case AppStates.STATE_TITLE:
				
				break;

				//------------------------------------------------------------------------------------o
				case AppStates.STATE_PLAY:
					
				break;
				
				//------------------------------------------------------------------------------------o
				
				case AppStates.STATE_GAME_OVER:

				break;	
				
				//------------------------------------------------------------------------------------o
				
				case AppStates.STATE_WIN:

				break;		
				
				//------------------------------------------------------------------------------------o					
				
				case AppStates.STATE_SCORES:

				break;	
				//------------------------------------------------------------------------------------o					
				
				default:
				//no state found, revert to default home
				currentScreenState = null;
				currentScreenObject = null;
				changeScreenState(AppStates.STATE_TITLE);
				return;
				break;					
				
			}
			
			currentScreenState = newState;
			initializeNewState();
		}
		
		//==========================================================o
		//- Asset Loaded Callback From AssetStateMachine
		//==========================================================o
		static public function initializeNewState():void 
		{
			if (currentScreenObject.showLoadingScreen)
			core.controlBus.appUIController.showLoadingScreen("LOADING", true, HexColours.NAVY_BLUE);
			
			if (currentScreenObject.showTitleBar)
			core.controlBus.appUIController.showTitleBar(currentScreenObject.displayName, currentScreenObject.showBackButton);

			//always remove first
			core.controlBus.appUIController.removeMenuButton()
		
			if (currentScreenObject.showMenuIcon)
			core.controlBus.appUIController.showMenuButton(false);

			
			if (currentScreenObject)
			{
				oStarlingStage.addChildAt(currentScreenObject, 0);
				currentScreenObject.init();
			}
		}
		
		//==========================================================o
		//- State Loaded Callback From AssetStateMachine
		//==========================================================o
		static public function stateReady():void 
		{
			trace(StateMachine + "stateReady():" + currentScreenState + " is stateReady");
		
			if (currentScreenObject.showMenuIcon)
			core.controlBus.appUIController.activateMenuButton();
				
			if (currentScreenObject.showBackButton)
			core.controlBus.appUIController.activateBackButton(); 

			
			
		}	

		

		

		

		

		

		






		


		
		
	}

}