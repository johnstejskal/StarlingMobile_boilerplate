package view.components.ui.form 
{


	import com.greensock.easing.Back;
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;
	import com.johnstejskal.Delegate;
	import com.johnstejskal.TrueTouch;
	import com.thirdsense.animation.TexturePack;
	import com.thirdsense.LaunchPad;
	import data.AppData;
	import data.constants.LaunchPadLibrary;
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
	import starling.utils.deg2rad;
	import starling.utils.HAlign;


	import staticData.SpriteSheets;

	import view.components.screens.SuperScreen;
	
	/**
	 * ...
	 * @author John Stejskal
	 * johnstejskal@gmail.com
	 * "Why walk when you can ride"
	 */
	public class CustomCheckBox extends Sprite
	{
		private const DYNAMIC_TA_REF:String = "CustomCheckBox";
		public static const STATE_ON:String = "stateOn";
		public static const STATE_OFF:String = "stateOff";
		static public const STATE_ERROR:String = "stateError";
		public var dataClass:Class;
		public var dataProperty:String;
		
		private var taRef:String;
		private var _core:Core;
		
		private var _currentState:String;
		
		private var _smcCheckBox:starling.display.MovieClip;
		
		private var _isToggleOn:Boolean;
		private var _isRequired:Boolean;
		private var _defaultState:String;
		private var _callBack:Function;
		private var _value:Boolean;
		private var _tt:TrueTouch;
		private var _isValid:Boolean;


		//=======================================o
		//-- Constructor
		//=======================================o
		public function CustomCheckBox(dynamicVariant:int, callback:Function, defaultState:String = "stateOff") 
		{
			
			trace(this + "Constructed");
			_core = Core.getInstance();
			_callBack = callback;
			
			if (defaultState != null)
			{
			_defaultState = defaultState;
			}
		
			taRef = "TA_checkBox" + dynamicVariant;
			if (stage) init(null);
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
		}

		//=======================================o
		//-- init
		//=======================================o
		private function init(e:Event):void 
		{
			
			trace(this + "inited");
			_tt = new TrueTouch();
			
			
			if (dataClass != null)
			{
				if(_value == true)
				_defaultState = STATE_ON;
				
			}

				if (_defaultState == STATE_ON)
				{
				_isToggleOn = true;
				_value = true;
				}
				else
				{
				_isToggleOn = false;
				_value = false;
				}
			
			
			var mc:MovieClip = LaunchPad.getAsset(LaunchPadLibrary.DYNAMIC_LIBRARY_UI, "TA_checkBox") as MovieClip;
			mc.scaleX = mc.scaleY = AppData.deviceScale;
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, taRef, null, 1, 3, null, 0)
			_smcCheckBox = TexturePack.getTexturePack(DYNAMIC_TA_REF, taRef).getMovieClip();
			_smcCheckBox.pause();
			
			if (_defaultState == STATE_ON)
			changeState(STATE_ON);
			else if (_defaultState == STATE_OFF)
			changeState(STATE_OFF);
			else if (_defaultState == STATE_ERROR)
			changeState(STATE_ERROR);
			
			this.addChild(_smcCheckBox);
			mc = null;
			
			this.addEventListener(TouchEvent.TOUCH, onTouch)
			
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
					_tt.mapTouch(touch);
                }
 
                else if(touch.phase == TouchPhase.ENDED)
                {
					if (!_tt.checkTouch(touch))
					return;
					
					if(_callBack != null)
					_callBack();
					
					if (_currentState == STATE_ON)
					{
						changeState(STATE_OFF)
					}
					else if (_currentState == STATE_OFF)
					{
						changeState(STATE_ON)
					}
					else if (_currentState == STATE_ERROR)
					{
						changeState(STATE_ON)
					}
                }
 
                else if(touch.phase == TouchPhase.MOVED)
                {
                            
                }
            }
		}
		
		public function changeState(newState:String):void 
		{
			switch(newState)
			{
				
				case STATE_OFF:
				_smcCheckBox.currentFrame = 0;
				_value = false;
				_isToggleOn = false;
				break;
				
				//----------------------O	
				
				case STATE_ON:
				_smcCheckBox.currentFrame = 1;
				_isToggleOn = true;
				_value = true;
				break;
					
				//----------------------O
				
				case STATE_ERROR:
				_smcCheckBox.currentFrame = 2;
				_isToggleOn = false;
				_value = false;
				break;
				
			}
			
			if(dataClass != null)
			dataClass[dataProperty] = _value;
			
			_currentState = newState
		}
		
		
		public function check():void
		{
			_isValid = false;
			if (_isRequired && !_isToggleOn)
			{
				changeState(STATE_ERROR);
				_isValid = false;
				_value = false;
			}
			else if (_isRequired && _isToggleOn)
			{
				_isValid = true;
				_value = true;
			}
			else if (!_isRequired && !_isToggleOn)
			{
				_isValid = true;
				_value = false;
			}
			else if (!_isRequired && _isToggleOn)
			{
				_isValid = true;
				_value = true;
			}
			
		}
			
		//=========================================o
		//------ dispose/kill/terminate/
		//=========================================o
		public function trash():void
		{
			trace(this + "trash()");
			_tt.trash();
			this.removeEventListeners();
			TexturePack.deleteTexturePack(DYNAMIC_TA_REF)
			this.removeFromParent();
			
		}
		
		public function get currentState():String 
		{
			return _currentState;
		}
		
		public function set currentState(value:String):void 
		{
			_currentState = value;
		}
		
		public function get isRequired():Boolean 
		{
			return _isRequired;
		}
		
		public function set isRequired(value:Boolean):void 
		{
			_isRequired = value;
		}
		
		public function get value():Boolean 
		{
			return _value;
		}
		
		public function set value(value:Boolean):void 
		{
			_value = value;
		}
		
		public function get isValid():Boolean 
		{
			return _isValid;
		}
		
		public function set isValid(value:Boolean):void 
		{
			_isValid = value;
		}
		
		
	}

}