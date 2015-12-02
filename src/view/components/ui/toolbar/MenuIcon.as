package view.components.ui.toolbar 
{
	import com.greensock.easing.Back;
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;
	import com.johnstejskal.Delegate;
	import com.thirdsense.animation.TexturePack;
	import com.thirdsense.LaunchPad;
	import data.AppData;
	import data.constants.LaunchPadLibrary;
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
	import starling.utils.deg2rad;

	
	/**
	 * ...
	 * @author John Stejskal
	 * johnstejskal@gmail.com
	 * "Why walk when you can ride"
	 */
	public class MenuIcon extends Sprite
	{
		private const DYNAMIC_TA_REF:String = "MenuIcon";
		
		static public const STATE_DEFAULT:String = "stateDefault";
		static public const STATE_RED_TRANS:String = "stateRedTrans";
		static public const STATE_WHITE_TRANS:String = "stateWhiteTrans";
		static public const STATE_NO_LABEL:String = "stateNoLabel";
		public var h:int;

		private var _core:Core;
		
		private var _collisionArea:Image;
		
		//images
		private var _imgBacking:Image;
		private var _quFill:Quad;
		
		//mc's
		private var _simMenuIcon:Image;
		private var _isTransparent:Boolean;
		private var _state:String;
		private var _smcMenuIcon:starling.display.MovieClip;
		

		//=======================================o
		//-- Constructor
		//=======================================o
		public function MenuIcon(state:String) 
		{
			trace(this + "Constructed");
			_core = Core.getInstance();
			_state = state;
			
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

			var mc:MovieClip = new TA_menuIcon();
			
			if(DeviceType.current == DeviceType.IPAD)
			mc.scaleX = mc.scaleY = 1;
			else if (DeviceType.current == DeviceType.IPHONE_5)
			mc.scaleX = mc.scaleY = 1.35;
			else if (DeviceType.current == DeviceType.IPHONE_4)
			mc.scaleX = mc.scaleY = 1.35;
			else
			{

			mc.height = AppData.deviceScaleX * 82
			mc.width = AppData.deviceScaleX * 82
			mc.width += 1 * (AppData.deviceScaleX *82)
			
			}
			
			mc.scaleX = mc.scaleY = AppData.deviceScale;
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_menuIcon", null, 1, 3, null, 0);
			_smcMenuIcon = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_menuIcon").getMovieClip();
			_smcMenuIcon.x = this.width;
			this.addChild(_smcMenuIcon);
				
			h = this.height;
			changeState(_state);
				
			mc = null;
			
			this.addEventListener(TouchEvent.TOUCH, onTouch);
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
					EventBus.getInstance().sigSlideMenuAction.dispatch(null);
                }

            }
		}
		
		//=======================================o
		//-- tChange State
		//=======================================o
		public function changeState(newState:String):void 
		{
			return;
			switch(newState)
			{
				case STATE_DEFAULT:
				_smcMenuIcon.currentFrame = 0;
				break;
					
				case STATE_RED_TRANS:
				_smcMenuIcon.currentFrame = 1;
				break;
					
				case STATE_WHITE_TRANS:
				_smcMenuIcon.currentFrame = 2;
				break;
			}
		}
		
		//=======================================o
		//-- trash/dispose/kill
		//=======================================o
		public function trash():void
		{
			trace(this + " trash()")
			TexturePack.deleteTexturePack(DYNAMIC_TA_REF);
			this.removeFromParent();
			this.removeEventListeners();
		}

		
		public function get isTransparent():Boolean 
		{
			return _isTransparent;
		}
		
		public function set isTransparent(value:Boolean):void 
		{
			_isTransparent = value;
		}
		
	}

}