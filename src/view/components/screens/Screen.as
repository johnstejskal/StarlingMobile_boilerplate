package view.components.screens
{

	import com.greensock.TweenLite;
	import com.thirdsense.animation.TexturePack;
	import com.thirdsense.LaunchPad;
	import flash.display.MovieClip;
	import interfaces.iScreen;
	import singleton.Core;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	import staticData.AppFonts;
	import staticData.Constants;
	import staticData.Data;
	import staticData.DynamicAtlasValues;
	import staticData.HexColours;
	import staticData.settings.PublicSettings;
	import view.components.ui.CustomTextField;
	import view.components.ui.MenuIcon;
	import view.components.ui.SubTitleBar;
	import view.components.ui.TitleBar;


	
	/**
	 * @author John Stejskal
	 * "Why walk when you can ride"
	 */
	
	public class Screen extends Sprite implements iScreen
	{
		public var core:Core = Core.getInstance();
		private var _imgBG:Image;
		private var _imgTitleLogo:Image;
		private var _imgButton:Image;
		private var _quFill:Quad;
		private var _quBGFill:Quad;
		private var _bgHexColour:uint = HexColours.NAVY_BLUE;
		private var _qtitleBarBacking:Quad;
		public var oMenuIcon:MenuIcon;
		public var showMenuIcon:Boolean;
		public var showTitleBar:Boolean;
		public var subTitleBarState:Boolean;
		private var _displayName:String = "";

		public var spTitleText:Sprite;
		
		public var manualRemoveDim:Boolean = false;


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
			init()
			
			
			
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

			
			core.controlBus.appUIController.removeFillOverlay();
		}

		//----------------------------------------o
		//------ dispose/kill/terminate/
		//----------------------------------------o	
		public function trash():void
		{
			TexturePack.deleteTexturePack(DynamicAtlasValues.TITLE_BAR)

		}
		
		//----------------------------------------o
		//------ activate
		//----------------------------------------o	
		public function activate():void
		{
			
		}	
		
		//----------------------------------------o
		//------ de-activate
		//----------------------------------------o	
		public function deactivate():void
		{
			trace(this + "deactivate()");

			this.touchable = false;
		}
		
		
		//========================================o
		//--- set a header text
		//========================================o
		public function setHeaderText(title:String, subText:String, adjustForSubHeader:Boolean = false):void 
		{
			//text header
			spTitleText = new Sprite();
			var textFieldTitle:TextField = new TextField(Data.deviceResX, 100, title, AppFonts.FONT_OSTRICH, 65, HexColours.WHITE);
			textFieldTitle.hAlign = HAlign.CENTER; 
			textFieldTitle.vAlign = VAlign.TOP;
			textFieldTitle.border = false;
			textFieldTitle.x = Math.floor(Data.deviceScaleX *20);
			textFieldTitle.autoSize = TextFieldAutoSize.VERTICAL;
			textFieldTitle.y = Math.floor(0);
			
			spTitleText.addChild(textFieldTitle);
			
			//sub text
			var textFieldSub:TextField = new TextField(Data.deviceResX, 100, subText, AppFonts.FONT_OSTRICH_BLACK, 34, HexColours.WHITE);
			textFieldSub.hAlign = HAlign.CENTER; 
			textFieldSub.vAlign = VAlign.TOP;
			textFieldSub.border = false;
			textFieldSub.x =  Math.floor(Data.deviceScaleX *20);
			textFieldSub.y = Math.floor(textFieldTitle.y + (textFieldTitle.height + 10));
			textFieldSub.autoSize = TextFieldAutoSize.VERTICAL;
			spTitleText.addChild(textFieldSub);
			
			
			var titleBarHeight:int = core.controlBus.appUIController.oTitleBar.height;
		
			if (adjustForSubHeader)
			{
			var subBarHeight:int = core.controlBus.appUIController.oSubTitleBar.height;	
			spTitleText.y = titleBarHeight + subBarHeight + (titleBarHeight/2);	
			//Math.floor(Data.deviceScaleX*210);
			}else
			{
			spTitleText.y = titleBarHeight + (titleBarHeight/2);
			//Math.floor(Data.deviceScaleX * 140);
			}
			this.addChild(spTitleText);
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
		public function setBG(hexColour:uint):void 
		{
			if (_quBGFill)
			return;
			
			_quBGFill = new Quad(Data.deviceResX, Data.deviceResY, hexColour);
			this.addChild(_quBGFill);
		}
		
		
		//========================================o
		//--- set bg size
		// used for updating post init for clipped screens
		//========================================o		
		public function setBGSize(w:int, h:Number):void 
		{
			if (!_quBGFill)
			return;
			
			_quBGFill.width = w;
			_quBGFill.height = h;
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