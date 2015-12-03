package view.components.ui.toolbar 
{

	import com.greensock.easing.Back;
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;
	import com.johnstejskal.Delegate;
	import com.thirdsense.animation.TexturePack;
	import com.thirdsense.LaunchPad;
	import data.AppData;
	import data.constants.AppFonts;
	import data.constants.LaunchPadLibrary;
	import data.constants.HexColours;
	import data.settings.UISettings;
	import flash.geom.Rectangle;
	import ManagerClasses.utility.AssetsManager;
	import ManagerClasses.utility.DeviceType;
	import singleton.Core;
	import singleton.EventBus;
	import starling.core.Starling;
	import starling.display.Image;
	import flash.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.utils.deg2rad;
	import starling.utils.HAlign;
	import starling.utils.VAlign;

	
	/**
	 * ...
	 * @author John Stejskal
	 * johnstejskal@gmail.com
	 * "Why walk when you can ride"
	 */
	public class TitleBar extends Sprite
	{
		private const DYNAMIC_TA_REF:String = "TitleBar";

		private var _core:Core;
		private var _qBacking:Quad;
		private var _hexColour:uint;// = UISettings.ENABLE_TITLE_BAR_COLOUR;
		private var _label:String = "test";
		private var _enableMenuIcon:Boolean;
		private var _enableBackButton:Boolean;
		private var _isTransparent:Boolean;
		private var _simBackButton:Image;
		private var _spJaggedSlider:Sprite;
		private var _showSubBar:Boolean;
		private var _tfLabel:TextField;
		private var _simLogo:Image;
		private var _simDivider:Image;
		private var _imgBG:Image;
		private var _h:int;
		
		

		//=======================================o
		//-- Constructor
		//=======================================o
		public function TitleBar(showSubBar:Boolean = false) 
		{
			trace(this + "Constructed");
			_core = Core.getInstance();
			_showSubBar = showSubBar;
			
			if (stage) init(null);
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
		}
		
		//=======================================o
		//-- init
		//=======================================o
		private function init(e:Event):void 
		{
			trace(this + "inited");
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
		   var mc:MovieClip;
		  
		   if (UISettings.ENABLE_TITLE_BAR_IMAGE)
		   {
			   mc = new TA_titleBarBG();
			   mc.scaleX = mc.scaleY = AppData.offsetScaleX;
			   TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_titleBarBG", null, 1, 1, null, 0)
			   _imgBG = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_titleBarBG").getImage();
			   this.addChild(_imgBG);
			   _h = _imgBG.height;
		   }
		   else
		   {
				_qBacking = new Quad(AppData.deviceResX, AppData.offsetScaleX*100, UISettings.TITLE_BAR_COLOUR);	
				
				this.addChild(_qBacking);
				_h = _qBacking.height;
			
		   }

			//Add optional menu icon
			if (this.enableBackButton)
			{
				showBackButton();
			}
			
			var fs:int;
				if(DeviceType.current == DeviceType.IPAD)
				fs = 34;
				else if (DeviceType.current == DeviceType.IPHONE_5)
				fs = 44;
				else if (DeviceType.current == DeviceType.IPHONE_4)
				fs = 44;
				else
				{
				fs = AppData.deviceScaleX * 44;
				}
			
			if (UISettings.ENABLE_TITLE_HEADING)
			{
				_tfLabel = new TextField(AppData.deviceResX, _h, _label, AppFonts.FONT_ARIAL, fs, HexColours.WHITE);
				_tfLabel.hAlign = HAlign.CENTER; 
				_tfLabel.vAlign = VAlign.CENTER;
				_tfLabel.border = false;
				_tfLabel.autoSize = TextFieldAutoSize.NONE;
				_tfLabel.touchable = false
				addChild(_tfLabel);
			}
			
			if (UISettings.ENABLE_TITLE_BAR_TRANSPARENCY)
			{
				if(_qBacking)
				_qBacking.visible = false;
				
				if (_imgBG)
				_imgBG.visible = false;
			}
			
			if (UISettings.ENABLE_TITLE_BAR_LOGO)
			{
				mc = new TA_titleBarLogo();
				mc.scaleX = mc.scaleY = 1;
				TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_titleBarLogo", null, 1, 1, null, 0);
				_simLogo = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_titleBarLogo").getImage();
				_simLogo.x = AppData.deviceResX/2;
				_simLogo.y = _qBacking.height/2 + 3;
				this.addChild(_simLogo);
			}
		
			
			//=================================
			//-- 
/*			if (_showSubBar)
			{
				mc = LaunchPad.getAsset(LaunchPadLibrary.UI, "TA_titleBarJagged") as MovieClip;
				mc.scaleX = mc.scaleY = AppData.deviceScaleX;
				TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_titleBarJagged", null, 1, 1, null, 0);
				var simJaggedBar:Image = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_titleBarJagged").getImage();
				
				simJaggedBar.x = 0;
				simJaggedBar.y = _qBacking.y+ _qBacking.height;
				
				_spJaggedSlider = new Sprite();
				_spJaggedSlider.addChild(simJaggedBar);
				this.addChildAt(_spJaggedSlider, 0);
				mc = null;	
			}*/

			

			//this.clipRect = new Rectangle(0, 0, AppData.deviceResX, _simDivider.y+_simDivider.height);
		}
		
		public function showBackButton():void 
		{
			
			if (!UISettings.ENABLE_BACK_BUTTON)
			return;
			
			var mc:* = new TA_titleBar_backButton();
			mc.scaleX = mc.scaleY = AppData.deviceScale;
			
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_titleBar_backButton", null, 1, 1, null, 0);
			_simBackButton = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_titleBar_backButton").getImage();
			_simBackButton.x = 0;
			_simBackButton.y = 0;
			this.addChild(_simBackButton);
			_simBackButton.addEventListener(TouchEvent.TOUCH, onTouch);
			_simBackButton.touchable = false;
			_simBackButton.alpha = .3;
		}
		
		//=================================o
		//-- update label
		//=================================o
		public function updateLabel(displayName:String):void 
		{
			_tfLabel.text = displayName;
		}
		
		//=======================================o
		//-- On Touch Event handler
		//=======================================o
		private function onTouch(e:TouchEvent):void 
		{
			var touch:Touch = e.getTouch(stage);
            if(touch)
            {
                if(touch.phase == TouchPhase.BEGAN)
                {	
					
					switch(e.target)
					{					
						case _simBackButton:
						//EventBus.getInstance().sigBackButtonClicked.dispatch();
						break;
						
					}
				 
                }
            }
		}
		
		//=======================================o
		//-- trash/dispose/kill
		//=======================================o
		public  function trash():void
		{
			trace(this + " trash()")
			TexturePack.deleteTexturePack(DYNAMIC_TA_REF)
			this.removeFromParent();
			this.removeEventListeners();
			
		}
		
		public function activateBackButton():void 
		{
			if (_simBackButton != null)
			{
				_simBackButton.touchable = true;
				_simBackButton.alpha = 1;
			}
		}

		
		public function set hexColour(value:uint):void 
		{
			_hexColour = value;
		}
		
		public function get label():String 
		{
			return _label;
		}
		
		public function set label(value:String):void 
		{
			_label = value;
		}
		
		
		public function get enableBackButton():Boolean 
		{
			return _enableBackButton;
		}
		
		public function set enableBackButton(value:Boolean):void 
		{
			_enableBackButton = value;
		}
		
		public function get isTransparent():Boolean 
		{
			return _isTransparent;
		}
		
		public function set isTransparent(value:Boolean):void 
		{
			_isTransparent = value;
		}
		
		public function get simBackButton():Image 
		{
			return _simBackButton;
		}
		
		
	}

}