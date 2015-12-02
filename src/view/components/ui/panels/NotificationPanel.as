package view.components.ui.panels
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
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.utils.deg2rad;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	import view.components.EntityObject;
	import view.components.ui.buttons.ButtonType1;

	import view.components.ui.buttons.SuperButton;
	
	/**
	 * ...
	 * @author John Stejskal
	 * johnstejskal@gmail.com
	 * "Why walk when you can ride"
	 */
	public class NotificationPanel extends EntityObject
	{
		public var delayBeforeCallback:Number;
		private const DYNAMIC_TA_REF:String = "NotificationPanel";

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
		private var _orangeButton2:ButtonType1;
		private var _orangeButton1:ButtonType1;
		
		//=======================================o
		//-- Constructor
		//=======================================o
		public function NotificationPanel()
		{
			trace(this + "Constructed");
			
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
			var mc:MovieClip = new TA_notificationPanel()
			mc.scaleX = mc.scaleY = AppData.deviceScale;
			mc.$txTitle.text = _titleText;
			mc.$txSubTitle.text = _subText;
			mc.$txCopy.text = _copyText;
			
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_notificationPanel", null, 1, 1, null, 0)
			var simPanel:Image = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_notificationPanel").getImage();
			this.addChild(simPanel);
			
			
			if (_buttonCount > 0)
			{
				_orangeButton1 = new ButtonType1(_btn1Text, function():void
					{
						core.controlBus.appUIController.removeNotification();
						
						
						if (_fnBtn1Callback != null)
						{
							TweenLite.delayedCall(delayBeforeCallback, function():void{	
							_fnBtn1Callback();
							})
						}
							
							
					}, DYNAMIC_TA_REF + "_orangeButton1");
				_orangeButton1.y = AppData.deviceScale * 240;
				this.addChild(_orangeButton1);
				
					//----------------o				
			}
			
			if (_buttonCount == 2)
			{
				_orangeButton2 = new ButtonType1(_btn2Text, function():void
					{
						core.controlBus.appUIController.removeNotification();
						
						if (_fnBtn2Callback != null)
						{
							TweenLite.delayedCall(delayBeforeCallback, function():void{	
							_fnBtn2Callback();
							})
						}
					
					}, DYNAMIC_TA_REF + "_orangeButton2");
				_orangeButton2.y = AppData.deviceScale * 240
				this.addChild(_orangeButton2);
				
				//shift button 1 to top
				_orangeButton1.y = AppData.deviceScale * 150;
			}
			
			//----------------o			
			mc = null;
			
			//-----------------------------------------------o
			//responsive scaling
			if (DeviceType.current == DeviceType.IPAD)
			{
				
			}
			else if (DeviceType.current == DeviceType.IPHONE_5)
			{
				
			}
			else if (DeviceType.current == DeviceType.IPHONE_4)
			{
				
			}
			//unknown device
			else
			{
				//if smaller then 640
				if (AppData.offsetScaleX < 1)
				{
					//this.scaleX = this.scaleY = AppData.offsetScaleX;
				}
				else
				{
					
				}
			}
			//-----------------------------------------------o
		
		}
		
		//=======================================o
		//-- On Touch Event handler
		//=======================================o
		private function onTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(stage);
			if (touch)
			{
				if (touch.phase == TouchPhase.BEGAN)
				{
					switch (e.target)
					{
						case _simBtn1: 
							trace(this + "_simBtn1 pressed");
							core.controlBus.appUIController.removeNotification();
							
							TweenLite.delayedCall(delayBeforeCallback, function():void{
								if (_fnBtn1Callback != null)
								_fnBtn1Callback();
							})
								
							break;
						
						case _simBtn2: 
							trace(this + "_simBtn2 pressed");
							core.controlBus.appUIController.removeNotification();
							
							if (_fnBtn2Callback != null)
							_fnBtn2Callback();
							
							break;
					}
					
				}
				
			}
		
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