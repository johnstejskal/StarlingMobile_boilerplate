package view.components.screens
{

	import com.greensock.TweenLite;
	import com.johnstejskal.StarlingUtil;
	import com.johnstejskal.TrueTouch;
	import com.thirdsense.animation.TexturePack;
	import com.thirdsense.LaunchPad;
	import data.AppData;
	import data.constants.LaunchPadLibrary;
	import data.constants.HexColours;
	import data.valueObjects.ValueObject;
	import ManagerClasses.StateMachine;
	import starling.display.MovieClip;
	import flash.text.StageText;
	import interfaces.iScreen;
	import singleton.Core;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.utils.HAlign;
	import starling.utils.VAlign;

	import view.components.EntityObject;
	import view.components.ui.Background;

	import view.components.ui.toolbar.MenuIcon;




	
	/**
	 * @author John Stejskal
	 * "Why walk when you can ride"
	 */
	
	public class Screen extends EntityObject implements iScreen
	{
		static public const TRANSITION_TYPE_RIGHT:String = "transitionRight";
		static public const TRANSITION_TYPE_LEFT:String = "transitionLeft";
		static public const TRANSITION_TYPE_NONE:String = "transitionNone";
			
		private var _imgBG:Image;
		private var _imgTitleLogo:Image;
		private var _imgButton:Image;
		private var _quFill:Quad;
		private var _quBGFill:Quad;
		private var _bgHexColour:uint = HexColours.NAVY_BLUE;
		private var _qtitleBarBacking:Quad;
		public var oMenuIcon:MenuIcon;
		public var valueObject:ValueObject;
		
		public var showMenuIcon:Boolean = true;
		public var showTitleBar:Boolean = true;
		public var showBackButton:Boolean = true;
		public var showLoadingScreen:Boolean = false;
		
		public var isTransParentTitle:Boolean = false;
		
		public var subTitleBarState:Boolean;
		private var _displayName:String = "";
		private var _oBG:Background;

		public var spTitleText:Sprite;
		
		public var manualRemoveDim:Boolean = false;
		public var isTransitioning:Boolean = false;
		public var enableTimeOutPopup:Boolean = false;
		
		public var trueTouch:TrueTouch;
		
		public var currMenuLevel:int = 1;
		public var prevSubScreenState:String;
		public var currSubScreenState:String;
		public var arrScreenStates:Array = [];
		public var breadCrumbLevel:int = 1;
		//public var oPanel:SuperPanel;

		//----------------------------------------o
		//------ Constructor 
		//----------------------------------------o
		public function Screen():void 
		{
			// No addedToStage Events are used here as there is a loading sequence 
			// Init is called after the loaded method executes
		}
		
		//-----------------------------------------------------------------------o
		//------ Assets loaded callback 
		//-----------------------------------------------------------------------o
		public function loaded():void 
		{
			init();
			
		}
		
		//----------------------------------------------------------------------o
		//------ init 
		//----------------------------------------------------------------------o		
		public function init():void 
		{
			core.controlBus.appUIController.removeLoadingScreen();
			
		}
		
		public function initComplete():void 
		{
			//this is used to handle optionally handle the
			// delays that are created with intensive GPU load
			// based on large object creation ie objectPool polulation
			StarlingUtil.floorAllPositions();	
			StateMachine.stateReady();
			//core.controlBus.appUIController.removeFillOverlay();
			activate();
		}

		//----------------------------------------o
		//------ dispose/kill/terminate/
		//----------------------------------------o	
		public function trash():void
		{
			TexturePack.deleteTexturePack(LaunchPadLibrary.TITLE_BAR)

		}
		
		//----------------------------------------o
		//------ activate
		//----------------------------------------o	
		public function activate():void
		{
			this.touchable = true;

			
		}	
		
		//----------------------------------------o
		//------ de-activate
		//----------------------------------------o	
		public function deactivate():void
		{
			trace(this + "deactivate()");
			
			this.touchable = false;
			core.controlBus.appUIController.deactivateTitleBar();
		}
		
		//========================================o
		//--- Animate Screen components in
		//========================================o
		public function animateIn(onComplete:Function = null):void 
		{

		}
		
		//========================================o
		//--- Animate Screen components Out
		//========================================o	
		public function animateOut(onComplete:Function = null):void 
		{

		}
		
		//========================================o
		//--- set a header text
		//========================================o
		public function setHeaderText(title:String):void 
		{
			//text header
/*			spTitleText = new Sprite();
			var textFieldTitle:TextField = new TextField(AppData.deviceResX, AppData.deviceScale*100, title, AppFonts.AVERIN_OBLIQUE, Math.floor(AppData.deviceScale * 50), HexColours.WHITE);
			textFieldTitle.hAlign = HAlign.CENTER; 
			textFieldTitle.vAlign = VAlign.TOP;
			textFieldTitle.border = false;
			textFieldTitle.x = 0//Math.floor(Data.deviceScaleX *0);
			textFieldTitle.autoSize = TextFieldAutoSize.VERTICAL;
			textFieldTitle.y = 0;
			spTitleText.addChild(textFieldTitle);
			spTitleText.y = 5;// core.controlBus.appUIController.oTitleBar.height;

			this.addChild(spTitleText);*/
		}
		
		//========================================o
		//--- remove  header text
		//========================================o
		public function removeHeaderText():void
		{
			if(spTitleText != null)
			spTitleText.removeFromParent();
		}
		
		
		//========================================o
		//--- set a screen BG colour
		//========================================o
		public function setBG():void 
		{
			core.controlBus.appUIController.setBG();

		}
		
		
		//========================================o
		//--- set bg size
		// used for updating post init for clipped screens
		//========================================o		
		public function setBGSize(w:int, h:Number):void 
		{
/*			if (!_quBGFill)
			return;
			
			_quBGFill.width = w;
			_quBGFill.height = h;
			*/
		}
		
		public function getStartingYPos():int 
		{
			var pos:int = 0;
			if(spTitleText != null)
			pos = spTitleText.y + spTitleText.height + (AppData.deviceScale * 20);
			else if (showTitleBar)
			pos = core.controlBus.appUIController.oTitleBar.height + (AppData.deviceScale * 20);
			else
			pos = (AppData.deviceScale * 20);
			
			return pos;
		}
		
		
		public function get displayName():String 
		{
			return _displayName;
		}
		
		public function set displayName(value:String):void 
		{
			_displayName = value;
		}
		
		public function get bgHexColour():uint 
		{
			return _bgHexColour;
		}
		
		public function set bgHexColour(value:uint):void 
		{
			_bgHexColour = value;
		}
		
		
	}
	
}