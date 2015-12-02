package view.components.ui.form
{
	
	import com.greensock.easing.Back;
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;
	import com.johnstejskal.Delegate;
	import com.thirdsense.animation.TexturePack;
	import com.thirdsense.LaunchPad;
	import data.AppData;
	import data.constants.LaunchPadLibrary;
	import ManagerClasses.utility.AssetsManager;
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
	import starling.filters.BlurFilter;
	import starling.text.TextField;
	import starling.utils.deg2rad;
	import starling.utils.HAlign;
	import starling.utils.VAlign;

	
	/**
	 * ...
	 * @author John Stejskal
	 * johnstejskal@gmail.com
	 * "Why walk when you can ride"
	 */
	public class FormFieldDropDown extends Sprite
	{
		private const DYNAMIC_TA_REF:String = "FormFieldDropDown";
		private var _value:String;
		private var _dynamicVariant:int;
		private var _label:String;
		private var _optionsList:Array;
		private var _defaultState:String;
		private var _defaultLabel:String;
		private var _simFormField:Image;
		private var _core:Core;
		private var _isRequired:Boolean;
		public var isValid:Boolean;
		public var dataClass:Class;
		public var dataProperty:String;
		
		static public const STATE_OFF:String = "stateOff";
		static public const STATE_ON:String = "stateOn";
		static public const STATE_ERROR:String = "stateError";
		public var taRef:String;
		
		//=======================================o
		//-- Constructor
		//=======================================o
		public function FormFieldDropDown(dynamicVariant:int, defaultLabel:String)
		{
			_core = Core.getInstance();
			_defaultLabel = defaultLabel;
			_dynamicVariant = dynamicVariant;
			taRef = "TA_checkBox" + _dynamicVariant;
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
			this.alpha = 0;
			taRef = "TA_checkBox" + _dynamicVariant;
			if (_defaultState == null)
				_defaultState = STATE_OFF;
			
			if (_label == null)
				_label = _defaultLabel;
			
			if (dataClass != null)
			{
				
				if (dataClass[dataProperty] != null && dataProperty != "password")
					_label = dataClass[dataProperty];
				
			}
			
			changeState(_defaultState, _label);
		}
		
		public function changeState(newState:String, label:String):void
		{
			_label = label;
			trace(this + "====changeState(" + newState + "," + _label + ")");
			TexturePack.deleteTexturePack(DYNAMIC_TA_REF, taRef);
			
			var mcField:MovieClip = LaunchPad.getAsset(LaunchPadLibrary.UI, "TA_formField") as MovieClip;
			mcField.$mcText.$txLabel.text = label;
			
			var statusBar:MovieClip = LaunchPad.getAsset(LaunchPadLibrary.UI, "TA_fieldStatusBar") as MovieClip;
			mcField.addChild(statusBar);
			
			mcField.$mcArrow.visible = true;
			if (newState == STATE_OFF)
			{
				statusBar.gotoAndStop("off");
				_value = label;
				
			}
			else if (newState == STATE_ON)
			{
				statusBar.gotoAndStop("on");
				_value = label;
			}
			else if (newState == STATE_ERROR)
			{
				statusBar.gotoAndStop("error");
				_value = label;
				
			}
			
			TexturePack.createFromMovieClip(mcField, DYNAMIC_TA_REF, taRef, null, 1, 1, null, 0)
			_simFormField = TexturePack.getTexturePack(DYNAMIC_TA_REF, taRef).getImage();
			this.addChild(_simFormField);
			_simFormField.scaleX = _simFormField.scaleY = AppData.offsetScaleX;
			
			mcField = null;
			statusBar = null;
			
			_simFormField.addEventListener(TouchEvent.TOUCH, onTouch)
		
		}
		
		//===========================================o
		//-- Confirmation event of Modal UI or Option List
		//===========================================o
		public function callBack_confirm(text:String = null):void
		{
			var isDefault:Boolean = false;
			isValid = false;
			var errorMsg:String;
			
			if (text == "null" || text == null)
				return;
			
			if (text == _defaultLabel)
				isDefault = true;
			
			trace("+++text :" + text);
			trace("+++_defaultLabel :" + _defaultLabel);
			trace("+++_isRequired :" + _isRequired);
			//not required
			if (!_isRequired && text == _defaultLabel)
			{
				isValid = true;
				changeState(STATE_ON, _defaultLabel);
				return;
			}
			
			if (_isRequired && isDefault)
				changeState(STATE_ERROR, _defaultLabel);
			else if (_isRequired && !isDefault)
			{
				isValid = true;
			}
			
			if (isValid)
				changeState(STATE_ON, text);
		
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
					//_tt.mapTouch(touch);
					trace("touch");
					_core.controlBus.appUIController.showOptionList(optionsList, this);
				}
				
				else if (touch.phase == TouchPhase.ENDED)
				{
					//if (!_tt.checkTouch(touch))
					//return;
					
				}
				
				else if (touch.phase == TouchPhase.MOVED)
				{
					
				}
			}
		}
		
		public function show(time:Number = .1, delay:Number = 0):void
		{
			TweenLite.to(this, time, {delay: delay, alpha: 1, onComplete: function():void
				{
				
				}})
		}
		
		public function hide(time:Number = .1, delay:Number = 0):void
		{
			TweenLite.to(this, time, {delay: delay, alpha: 0})
		}
		
		//=======================================o
		//-- trash/dispose/kill
		//=======================================o
		public function trash():void
		{
			trace(this + " trash()")
			this.removeFromParent();
		
		}
		
		public function get value():String
		{
			return _value;
		}
		
		public function set value(value:String):void
		{
			_value = value;
		}
		
		public function get optionsList():Array
		{
			return _optionsList;
		}
		
		public function set optionsList(value:Array):void
		{
			_optionsList = value;
		}
		
		public function get defaultState():String
		{
			return _defaultState;
		}
		
		public function set defaultState(value:String):void
		{
			_defaultState = value;
		}
		
		public function get isRequired():Boolean
		{
			return _isRequired;
		}
		
		public function set isRequired(value:Boolean):void
		{
			_isRequired = value;
		}
		
		public function get label():String 
		{
			return _label;
		}
		
		public function set label(value:String):void 
		{
			_label = value;
		}
	
	}

}