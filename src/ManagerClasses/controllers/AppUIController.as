package ManagerClasses.controllers
{


	import com.greensock.easing.Cubic;
	import com.greensock.easing.Power1;
	import com.greensock.TweenLite;
	import com.johnstejskal.Position;
	import data.AppData;
	import data.constants.HexColours;
	import data.constants.Sounds;
	import data.controllerData.AppUIData;
	import data.settings.PublicSettings;
	import data.settings.UISettings;
	import data.valueObjects.AchievementVO;
	import flash.system.System;
	import ManagerClasses.StateMachine;
	import singleton.EventBus;
	import starling.core.Starling;
	import starling.display.Quad;
	import treefortress.sound.SoundAS;
	import view.components.screens.LoadingScreen;
	import view.components.ui.Background;
	import view.components.ui.form.FormField;
	import view.components.ui.form.FormFieldDropDown;
	import view.components.ui.panels.NotificationPanel;
	import view.components.ui.panels.OptionListPanel;
	import view.components.ui.slideOutMenu.SlideOutMenu;
	import view.components.ui.toolbar.MenuIcon;
	import view.components.ui.toolbar.TitleBar;
	import view.StarlingStage;
	
	//==============================================o
	/**
	 * @author John Stejskal
	 * "Why walk when you can ride"
	 */
	//==============================================o
	public class AppUIController extends SuperController
	{
		
		private var _oMenuIcon:MenuIcon; 
		private var _root:StarlingStage;
		private var _quDimScreen:Quad;
		private var _oSlideOutMenu:SlideOutMenu;
		private var _currSlideMenuState:String = SlideOutMenu.STATE_CLOSE;
		static private var _oloadingScreen:LoadingScreen;
		private var _oNotificationPanel:NotificationPanel;
		private var _currPanelObject:*;
		private var _oTitleBar:TitleBar;
		private var _isNavSliding:Boolean = false;
		private var _isNotificationActive:Boolean = false;
		private var _arrInfoPopups:Array;
		private var _arrInfoPopupIds:Array;
		private var _prevInfoPanelIndex:int = 0;
		private var _isInfoPanelActive:Boolean = false;

		private var _oOptionListPanel:OptionListPanel;
		private var _isLoading:Boolean = false;
		private var _oBG:Background;
		private var _currentNotificationPanel:*;
		
		//==============================================o
		//------ Constructor
		//==============================================o			
		public function AppUIController(root:StarlingStage)
		{
			_root = root;
		}

		//=======================================o
		//-- add a Title bar to a screen 
		//-- this is added in the controller so it doesnt trash with screens
		//=======================================o
		
		public function showTitleBar(label:String, enableBackButton:Boolean = true, isTransparent:Boolean = false, hexColour:uint = HexColours.RED):void
		{
			trace(this + "addTitlebar()");
			if (_oTitleBar != null)
			_oTitleBar.trash();
			
			_oTitleBar = new TitleBar();
			_oTitleBar.label = label;
			_oTitleBar.hexColour = hexColour
			_oTitleBar.enableBackButton = enableBackButton;
			_oTitleBar.y = 0;
			_root.addChild(_oTitleBar);
			
			if (_oMenuIcon != null)
			_root.setChildIndex(_oMenuIcon, _root.numChildren - 1);
						
			if (_quDimScreen != null)
			_root.setChildIndex(_quDimScreen, _root.numChildren - 1);
			
			if (_isNotificationActive)
			{
				if (_oNotificationPanel != null)
				{
					_root.setChildIndex(_oNotificationPanel, _root.numChildren - 1)
				}
			}
			
			trace("enableBackButton :" + enableBackButton);
		}
		
		//=======================================o
		//-- remove the Title bar to a screen 
		//=======================================o
		public function removeTitleBar():void
		{
			trace(this+"removeTitleBar()");
			
			if (_oTitleBar)
			_oTitleBar.trash();
			
			_oTitleBar = null;
		}
				
		//=======================================o
		//-- remove the Title bar to a screen 
		//=======================================o
		public function hideTitleBar():void
		{
			trace(this + "hideTitleBar()");
			
			if (_oTitleBar)
			{
				_oTitleBar.visible = false;
				_oTitleBar.touchable = false;
			}
			
		}
		
		//=======================================o
		//-- Show Menu Button
		//=======================================o			
		public function showBackButton():void
		{
			trace(this + "showBackButton()");
			
			if(_oTitleBar != null)
			_oTitleBar.showBackButton();
		}
		
		//==============================================o
		//------ Add Fill to darken screen
		//==============================================o		
		public function addFillOverlay(fadeSpeed:Number = .3, opacity:Number = .5, callback:Function = null, aboveMenuBar:Boolean = true, hexColour:uint = HexColours.BLACK, touchCallback:Function = null):void
		{

		}
		
		//==============================================o
		//------ remove Fill
		//==============================================o		
		public function removeFillOverlay(duration:Number = 0):void
		{
		
		}
			

		
		//==============================================o
		//------ Add Slide Out menu
		//==============================================o		
		public function addSlideOutMenu():void
		{
			if (!UISettings.ENABLE_SLIDE_MENU)
			return;
			
			_oSlideOutMenu = new SlideOutMenu();
			_root.addChild(_oSlideOutMenu);
			
			if (UISettings.SLIDE_MENU_POSITION == Position.LEFT)
			_oSlideOutMenu.x = -_oSlideOutMenu.width;
			else
			_oSlideOutMenu.x = AppData.deviceResX;
			
		}
		
		//==============================================o
		//------ Remove Slide Out menu
		//==============================================o		
		public function removeSlideOutMenu():void
		{
			_oSlideOutMenu.trash();
			_oSlideOutMenu = null;
			System.gc();
		}
		
		
		//==============================================o
		//------ Show a inter-state loading screen
		//==============================================o
		public function showLoadingScreen(label:String = null, showProgress:Boolean = false, showBG:Boolean = true):void
		{
			
			trace(this + "showLoadingScreen()"+ _root);
			hideStageText();
		
			if (_oloadingScreen != null)
			{
				_oloadingScreen.trash()
				_oloadingScreen = null;
			}
			
			
			hideMenuButton();
			
			_oloadingScreen = new LoadingScreen(label, showProgress, showBG);
			
			_root.addChild(_oloadingScreen)
			
			_isLoading = true;
		}
		
		//==============================================o
		//------ hide the inter-state loading screen
		//==============================================o
		public function removeLoadingScreen(fadeTime:Number = 0):void
		{
		
			_isLoading = false;
			if (_oloadingScreen != null)
			_oloadingScreen.trash();
			
			if (StateMachine.currentScreenObject != null)
			{
				if (StateMachine.currentScreenObject.showMenuIcon)
				showMenuButton();
			}
			
			_oloadingScreen = null;
		
		}
		
		
		//=======================================o
		//-- Show Pause Screen
		//=======================================o	
		public function showPauseScreen(unpause:Function):void
		{
			trace(this + "showPauseScreen()");
	/*		_isPauseActive = true;
			
			addFillOverlay(0, .5, null, true, HexColours.BLACK);
			
			if (_oPausePanel != null)
			{
				_oPausePanel.trash();
				_oPausePanel = null;
			}
			
			_oPausePanel = new PausePanel(unpause);
			_oPausePanel.y = AppData.deviceResY / 2
			_oPausePanel.x = AppData.deviceResX / 2;
			_root.addChild(_oPausePanel);*/

		}
		
		//=======================================o
		//-- Remove Pause Screen
		//=======================================o	
		public function removePauseScreen():void
		{
			trace(this + "removePauseScreen()");

/*			if (_oPausePanel)
			{
				_oPausePanel.trash();
				_oPausePanel = null;	
				_isPauseActive = false;
				removeFillOverlay();
			}
			*/

		}
		
		
		//==============================================o
		//------ show a generic notification panel
		//==============================================o
		public function showNotification(title:String, subTitle:String, copyText:String, btn1label:String = "YES", btn2label:String = "NO", btn1Callback:Function = null, btn2Callback:Function = null, delayBeforeCallback:Number = 0):void
		{
			
			trace(this + "showNotification()" + subTitle);
			var buttonCount:int = 0;
			
			if (btn1label != null)
			buttonCount ++;
			if (btn2label != null)
			buttonCount ++;
			
			
			addFillOverlay(.3, .5, null, true, HexColours.BLACK);
			
			_isNotificationActive = true;
			hideStageText();
			
			if (_oNotificationPanel != null)
			{
				_oNotificationPanel.trash();
				_oNotificationPanel = null;
			}
			
			TweenLite.delayedCall(.2, function():void
			{
				hideStageText();	
				//SoundAS.playFx(Sounds.SFX_TRANS_WHOOSH_1);	
				_oNotificationPanel = new NotificationPanel();
				_currentNotificationPanel = _oNotificationPanel;
				
				_oNotificationPanel.delayBeforeCallback = delayBeforeCallback;
				_oNotificationPanel.titleText = title;
				_oNotificationPanel.subText = subTitle;
				_oNotificationPanel.copyText = copyText;
				_oNotificationPanel.btn1Text = btn1label;
				_oNotificationPanel.fnBtn1Callback = btn1Callback;
				_oNotificationPanel.btn2Text = btn2label;
				_oNotificationPanel.fnBtn2Callback = btn2Callback;
				
				_oNotificationPanel.buttonCount = buttonCount;
				//_root.setChildIndex(_oNotificationPanel, _root.numChildren - 1);
				_oNotificationPanel.y = AppData.deviceResY + 500;
				_root.addChild(_oNotificationPanel);
				_oNotificationPanel.x = AppData.deviceResX / 2;
				TweenLite.to(_oNotificationPanel, 15, { useFrames:true, y:AppData.deviceResY / 2, ease:Power1.easeInOut, useFrames:false, onComplete:function():void {
					hideStageText();
					} } )
			}, null, true)	
			
		}

		
				
		//==============================================o
		//------ remove notification
		//==============================================o
		public function removeNotification(callBack:Function = null):void
		{
			trace(this + "removeNotification()");

			
			if (_currentNotificationPanel)
			{
				//SoundAS.playFx(Sounds.SFX_TRANS_WHOOSH_5);
				TweenLite.to(_currentNotificationPanel, 15, {useFrames:true, y:-AppData.deviceResY, ease:Power1.easeInOut, useFrames:false, onComplete:function():void{
				_isNotificationActive = false;	
				_currentNotificationPanel["trash"]();
				_currentNotificationPanel = null;	
				_oNotificationPanel = null;
				
				TweenLite.delayedCall(.2, showStageText)
				removeFillOverlay();
				
					if (callBack)
					callBack();
					
				}})
			}
			
		}

		//=======================================o
		//-- show the achievement panel
		//=======================================o		
		public function showAchievementPanel(vo:AchievementVO):void 
		{


		}
		
		//=======================================o
		//-- hide the achievement panel 
		//=======================================o		
		public function hideAchievementPanel(nextVO:AchievementVO = null):void 
		{
			trace(this+"hideAchievementPanel()");
		}
		
		public function hideMenuButton():void 
		{
			trace(this+"hideMenuButton()");
			if (_oMenuIcon != null)
			{
				_oMenuIcon.visible = false;
			}
		}
		
		public function removeMenuButton():void 
		{
			trace(this+"removeMenuButton()");
			if (_oMenuIcon != null)
			{
				_oMenuIcon.trash();
				_oMenuIcon = null;
			}
		}
		
		public function lockApp():void 
		{
			addFillOverlay(0, 1, null, true);
			if (_oNotificationPanel.parent != null)
			_oNotificationPanel.trash();
		
		}
		
		//=======================================o
		//-- Show Menu Button
		//=======================================o			
		public function showMenuButton(active:Boolean = true, force:Boolean = false):void
		{
			
			if((!StateMachine.currentScreenObject.showMenuIcon && !force) || !UISettings.ENABLE_SLIDE_MENU)
			return;
			
			trace(this + " showMenuButton()");
			
			if (_oMenuIcon != null)
			{
				_oMenuIcon.changeState("default");
				_oMenuIcon.visible = true;
			}
			else
			{ 
				_oMenuIcon = new MenuIcon("default");
				_oMenuIcon.x = AppData.deviceResX;
				_oMenuIcon.y = 0;
				_root.addChild(_oMenuIcon);
				_oMenuIcon.visible = true;
				_oMenuIcon.setPosition();
			
			}
			
			if (!active)
			{
				_oMenuIcon.touchable = false;
				_oMenuIcon.alpha = .3;
			}
			
			
			_root.setChildIndex(_oMenuIcon, _root.numChildren - 1);
			
			
			
			if (_isNotificationActive)
			{
				_root.setChildIndex(_quDimScreen, _root.numChildren - 1);
			
				if(_oNotificationPanel != null)
				_root.setChildIndex(_oNotificationPanel, _root.numChildren - 1);
			}
			
			
		}
		
		//=======================================o
		//-- Show all Stage Text
		//=======================================o			
		public function showStageText():void
		{
			trace(this+"--showStageText()")
			for (var i:int = 0; i < AppUIData.arrStageTextInstanes.length; i++) 
			{
				var ff:FormField = FormField(AppUIData.arrStageTextInstanes[i]);
				
				if (!ff.stageText.stage)
				{
					ff.stageText.stage = Starling.current.nativeStage;
					ff.stageText.visible = true;
				}
				else
				{
					ff.stageText.visible = true;
					ff.active = true;
				}

			}
			
		}

		//=======================================o
		//-- Hide all Stage Text
		//=======================================o	
		public function hideStageText():void
		{
			trace(this+"--hideStageText()")
			for (var i:int = 0; i < AppUIData.arrStageTextInstanes.length; i++) 
			{
				var ff:FormField = FormField(AppUIData.arrStageTextInstanes[i]);
				ff.stageText.visible = false;	
				ff.active = false;
			}
		}	
		
		//=======================================o
		//-- Kill aa Stage Text
		//=======================================o	
		public function removeStageText():void
		{
			trace(this+"removeStageText()")
			for (var i:int = 0; i < AppUIData.arrStageTextInstanes.length; i++) 
			{
				var ff:FormField = FormField(AppUIData.arrStageTextInstanes[i]);
				ff.stageText.stage = null;
				ff.stageText.dispose();
			}
			
			AppUIData.arrStageTextInstanes.length = 0;
			AppUIData.arrStageTextInstanes = [];
			trace(this+"removeStageText(), Data.arrStageTextInstanes.length is:"+AppUIData.arrStageTextInstanes.length)
		
		}
		
		
		//=======================================o
		//-- Change Screen State
		//=======================================o	
		public function changeScreen(state:String, removePrevState:Boolean = true, transitionType:String = "standard", vo:* = null):void 
		{
			EventBus.getInstance().sigScreenChangeRequested.dispatch(state, removePrevState, transitionType, vo);
		}
		
		public function setBG():void 
		{
			if (_oBG != null)
			{
				if (_oBG.parent != null)
			    StateMachine.oStarlingStage.setChildIndex(_oBG, 0);
				
				return;
			}
			
			_oBG = new Background();
			_oBG.x = AppData.deviceResX / 2;
			_oBG.y = AppData.deviceResY / 2;
			StateMachine.oStarlingStage.addChildAt(_oBG, 0);
		}
		

		public function removeBG():void
		{
			if (_oBG)
			_oBG.trash();
			
			_oBG = null;
		}
			
		
		public function showOptionList(optionsList:Array, targetField:FormFieldDropDown):void 
		{
			
			hideStageText();
			addFillOverlay();
			
			_isNotificationActive = true;
			hideStageText();
			
			if (_oOptionListPanel != null)
			{
			_oOptionListPanel.trash();
			_oOptionListPanel = null;
			}
			
			_oOptionListPanel = new OptionListPanel(optionsList, targetField);
			_oOptionListPanel.x = AppData.deviceResX / 2;
			_root.addChild(_oOptionListPanel);
			_currentNotificationPanel = _oOptionListPanel;
			_oOptionListPanel.y = AppData.deviceResY + 500;
			TweenLite.to(_oOptionListPanel, .3, {y:AppData.deviceResY/2, ease:Power1.easeInOut})	
		}
		
		//==============================================o
		//------ Change Slide Out menu Open/Close Status
		//==============================================o	
		public function changeSlideMenuState(newState:String):void
		{
			if (_isNavSliding)
			return;
			
			trace(this + "changeSlideMenuState");
			var speed:Number = UISettings.SLIDE_MENU_IN_SPEED;
			
			if (!_oSlideOutMenu)
			addSlideOutMenu();
			
			var menuIconPress:Boolean = false;
			
			if (newState == null)
			menuIconPress = true;
			
			var xPos:int;
			if (newState == SlideOutMenu.STATE_CLOSE)
			{

				xPos = 0;
				
				speed = UISettings.SLIDE_MENU_OUT_SPEED;
			}
			else if (newState == SlideOutMenu.STATE_OPEN)
			{

				if (UISettings.SLIDE_MENU_POSITION == Position.RIGHT)
					xPos = -_oSlideOutMenu.width;
				else
					xPos = _oSlideOutMenu.width;
				
			}
			else
			//No state Specified,Call has come from the menuIcon,  toggle based on current state
			{
				if (_currSlideMenuState == SlideOutMenu.STATE_CLOSE)
				{
					newState = SlideOutMenu.STATE_OPEN;
					
					if (UISettings.SLIDE_MENU_POSITION == Position.RIGHT)
						xPos = -_oSlideOutMenu.width;
					else
						xPos = _oSlideOutMenu.width;
					
					addFillOverlay(1, .5, null, true, HexColours.BLACK, touchCallback);
					
					if(StateMachine.currentScreenObject != null)
					StateMachine.currentScreenObject.deactivate();
					
					hideStageText();
					//SoundAS.play(Sounds.SFX_MENU_OPEN);
				}
				else if (_currSlideMenuState == SlideOutMenu.STATE_OPEN)
				{
					speed = UISettings.SLIDE_MENU_OUT_SPEED;
					newState = SlideOutMenu.STATE_CLOSE;
					
					xPos = 0;

				}

			}
			
			_isNavSliding = true;
			
			TweenLite.to(_root, speed, {x:xPos, ease: Cubic.easeInOut, onComplete: function():void
			{
				_currSlideMenuState = newState;
					
				if (_currSlideMenuState == SlideOutMenu.STATE_CLOSE)
				{
					removeFillOverlay();
					removeSlideOutMenu();
						
					if(StateMachine.currentScreenObject != null)
					StateMachine.currentScreenObject.activate();
					
					showStageText();
					StateMachine.stateReady();
				}
				else
				{
					activateMenuButton()
				}
					
				_isNavSliding = false;
				
			}})
			
			function touchCallback():void
			{
				EventBus.getInstance().sigSlideMenuAction.dispatch(SlideOutMenu.STATE_CLOSE);
			}
			
		}
			
		public function activateMenuButton():void 
		{
			if (_oMenuIcon != null)
			{
				_oMenuIcon.touchable = true;
				_oMenuIcon.alpha = 1;
			}
			
		}
		
		public function activateBackButton():void 
		{
			if (_oTitleBar != null)
			{
				_oTitleBar.activateBackButton();
			}	
		}
		
		public function removeTitleBarButtons():void 
		{
			if(_oMenuIcon != null)
			{
				_oMenuIcon.trash();
				_oMenuIcon = null;
			}
		}
		
		public function removeBackButton():void 
		{
			if (_oTitleBar != null)
			{
				//_oTitleBar.
			}
		}
		
		public function deactivateTitleBar():void 
		{
			if (_oMenuIcon != null)
			{
				_oMenuIcon.alpha = .3;
				_oMenuIcon.touchable = false;
			}
			
			if (_oTitleBar != null)
			{
				if (_oTitleBar.simBackButton != null)
				{
					_oTitleBar.simBackButton.touchable = false;
					_oTitleBar.simBackButton.alpha = .3;
					
				}
			}
		}
		

		//=======================================================o
		// -- Back Button Handler
		//=======================================================o
		public function backButtonPressed(softKey:Boolean = false):void 
		{
			EventBus.getInstance().sigBackButtonPressed.dispatch(softKey);
		}

		
		public function get oTitleBar():TitleBar 
		{
			return _oTitleBar;
		}
		
		public function get currSlideMenuState():String 
		{
			return _currSlideMenuState;
		}
		
		public function set currSlideMenuState(value:String):void 
		{
			_currSlideMenuState = value;
		}
		
		public function get oMenuIcon():MenuIcon 
		{
			return _oMenuIcon;
		}
		

		
		public function get isNotificationActive():Boolean 
		{
			return _isNotificationActive;
		}
		
		//=======================================o
		//-- Getters and Setters
		//=======================================o				
		

	
	}

}