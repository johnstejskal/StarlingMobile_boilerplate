package view.components.ui.panels
{
	
	import com.greensock.easing.Back;
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;
	import com.johnstejskal.Delegate;
	import com.johnstejskal.Maths;
	import com.thirdsense.animation.TexturePack;
	import com.thirdsense.LaunchPad;
	import ManagerClasses.utility.AssetsManager;
	import ManagerClasses.StateMachine;
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
	import staticData.AppFonts;
	import staticData.DeviceType;
	import staticData.HexColours;
	import staticData.settings.PublicSettings;
	import staticData.AppData;
	import staticData.SoundData;
	import staticData.SpriteSheets;
	import treefortress.sound.SoundAS;
	import view.components.ui.buttons.OrangeButton;
	
	/**
	 * ...
	 * @author John Stejskal
	 * johnstejskal@gmail.com
	 * "Why walk when you can ride"
	 */
	public class PausePanel extends Sprite
	{
		public var delayBeforeCallback:Number;
		private const DYNAMIC_TA_REF:String = "PausePanel";
		
		private var _core:Core;
		private var _titleText:String = "";
		private var _subText:String = "";
		private var _copyText:String = "";
		private var _btn1Text:String = "";
		private var _btn2Text:String = "";
		private var _buttonCount:int = 2;
		private var _simBtn1:Image;
		private var _simBtn2:Image;
		
		private var _fnBtn1Callback:Function;
		private var _fnBtn2Callback:Function;
		private var _orangeButton2:OrangeButton;
		private var _orangeButton1:OrangeButton;
		private var _orangeButton3:OrangeButton;
		private var _onUnpause:Function;
		
		//=======================================o
		//-- Constructor
		//=======================================o
		public function PausePanel(onUnpause:Function)
		{
			trace(this + "Constructed");
			_onUnpause = onUnpause;
			_core = Core.getInstance();
			
			if (stage)
				init(null);
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		
		}
		
		//=======================================o
		//-- init
		//=======================================o
		private function init(e:Event):void
		{
			trace(this + "inited");
			
			removeEventListener(Event.ADDED_TO_STAGE, init);

			//content area
			var mc:MovieClip = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "MC_miniNotificationPanel") as MovieClip;
			mc.scaleX = mc.scaleY = AppData.deviceScale;
			mc.$txTitle.text = "PAUSED";
			mc.$txCopy.text = "";
			
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "MC_miniNotificationPanel", null, 1, 1, null, 0)
			var simPanel:Image = TexturePack.getTexturePack(DYNAMIC_TA_REF, "MC_miniNotificationPanel").getImage();
			this.addChild(simPanel);
			
			mc = null;
			
			drawButtons();
		}
		
		private function drawButtons():void 
		{

			_orangeButton1 = new OrangeButton("Back to Game", function():void
			{
				_core.controlBus.appUIController.removePauseScreen();
				if (_onUnpause != null)
				_onUnpause();
	
			}, DYNAMIC_TA_REF + "_orangeButton1")
				
			_orangeButton1.y = Math.floor(-AppData.deviceScale * 70);
			this.addChild(_orangeButton1);
				
			//----------------o	
					
			_orangeButton2 = new OrangeButton("Main Menu", function():void
			{
				_core.controlBus.appUIController.removePauseScreen();
				_core.refPlayScreen.endGame(StateMachine.STATE_HOME);
				
							
			}, DYNAMIC_TA_REF + "_orangeButton2")
				
			_orangeButton2.y = Math.floor(_orangeButton1.y + (AppData.deviceScale * 100));
			this.addChild(_orangeButton2);
			
			//----------------o		
			
			var label:String = "Mute Sound"
			if (SoundData.isSFXMuted)
			label = "Unmute Sound";
			
			_orangeButton3 = new OrangeButton(label, function():void {
				_core.controlBus.soundController.toggleSoundFX();
				_orangeButton1.trash();
				_orangeButton2.trash();
				_orangeButton3.trash();
				drawButtons();
				}, DYNAMIC_TA_REF + "_orangeButton3")
				
			_orangeButton3.y = Math.floor(_orangeButton2.y + (AppData.deviceScale * 100));
			this.addChild(_orangeButton3);
			


		}
		

		
		//=======================================o
		//-- trash/dispose/kill
		//=======================================o
		public function trash():void
		{
			trace(this + " trash()")
			TexturePack.deleteTexturePack(DYNAMIC_TA_REF)
			this.removeFromParent();
			this.removeEventListeners();
		
		}
		
		public function get titleText():String
		{
			return _titleText;
		}
		
		public function set titleText(value:String):void
		{
			_titleText = value;
		}
		
		public function get subText():String
		{
			return _subText;
		}
		
		public function set subText(value:String):void
		{
			_subText = value;
		}
		
		public function get buttonCount():int
		{
			return _buttonCount;
		}
		
		public function set buttonCount(value:int):void
		{
			_buttonCount = value;
		}
		
		public function get btn1Text():String
		{
			return _btn1Text;
		}
		
		public function set btn1Text(value:String):void
		{
			_btn1Text = value;
		}
		
		public function get btn2Text():String
		{
			return _btn2Text;
		}
		
		public function set btn2Text(value:String):void
		{
			_btn2Text = value;
		}
		
		public function get fnBtn1Callback():Function
		{
			return _fnBtn1Callback;
		}
		
		public function set fnBtn1Callback(value:Function):void
		{
			_fnBtn1Callback = value;
		}
		
		public function get fnBtn2Callback():Function
		{
			return _fnBtn2Callback;
		}
		
		public function set fnBtn2Callback(value:Function):void
		{
			_fnBtn2Callback = value;
		}
		
		public function get copyText():String 
		{
			return _copyText;
		}
		
		public function set copyText(value:String):void 
		{
			_copyText = value;
		}
	
	}

}