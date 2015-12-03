package view.components.ui.form 
{

	import com.greensock.easing.Back;
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;
	import com.johnstejskal.Delegate;
	import com.johnstejskal.StringFunctions;
	import com.johnstejskal.TrueTouch;
	import com.johnstejskal.Validation;
	import com.thirdsense.animation.TexturePack;
	import com.thirdsense.LaunchPad;
	import com.thirdsense.utils.StringTools;
	import data.AppData;
	import data.constants.Platform;
	import data.constants.LaunchPadLibrary;
	import data.constants.HexColours;
	import data.controllerData.AppUIData;
	import data.settings.PublicSettings;
	import flash.display.Bitmap;
	import flash.events.FocusEvent;
	import flash.events.SoftKeyboardEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.AutoCapitalize;
	import flash.text.ReturnKeyLabel;
	import flash.text.SoftKeyboardType;
	import flash.text.StageText;
	import flash.text.TextFormatAlign;
	import ManagerClasses.utility.AssetsManager;
	import ManagerClasses.StateMachine;
	import singleton.Core;
	import singleton.EventBus;
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
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


	/**
	 * ...
	 * @author John Stejskal
	 * johnstejskal@gmail.com
	 * "Why walk when you can ride"
	 */
	public class FormField extends Sprite
	{
		private const DYNAMIC_TA_REF:String = "FormField";
		
		public static const STATE_ON:String = "stateOn";
		public static const STATE_OFF:String = "stateOff";
		static public const STATE_ERROR:String = "stateError";
		
		static public const TYPE_MIXED_TEXT:String = "mixedText";
		static public const TYPE_NAME:String = "name";
		static public const TYPE_FIRST_NAME:String = "firstName";
		static public const TYPE_LAST_NAME:String = "lastName";
		static public const TYPE_EMAIL:String = "email";
		static public const TYPE_PHONE:String = "phone";
		static public const TYPE_POSTCODE:String = "postcode";
		static public const TYPE_CONFIRMATION:String = "confirmation";
		static public const TYPE_OPTION_LIST:String = "optionList";
		static public const TYPE_PASSWORD:String = "password";
		static public const TYPE_NONE:String = "none";
		
		private var taRef:String;
		private var _core:Core;

		private var _smcFormField:starling.display.MovieClip;
		
		private var _isToggleOn:Boolean;
		private var _isRequired:Boolean;
		private var _defaultState:String;
		
		
		private var _callBack:Function;
		private var _label:String;
		private var _navGroup:Object;
		private var _tt:TrueTouch;
		private var _value:String;
		private var _simFormField:Image;
		private var _isOptionList:Boolean;
		private var _type:String;
		private var _mirrorField:FormField;
		private var _defaulLabel:String;
		private var isDefault:Boolean = false;
		private var _st:CustomStageText;
		private var _keyBoardType:String;
		private var _stageText:StageText;
		private var viewPort:Rectangle;
		private var _globalContext:Sprite;
		private var _showOnActivate:Boolean;
		private var _xOffset:int;
		private var _yOffset:Number;
		private var _w:Number;
		private var _h:Number;
		private var _swearCheck:Boolean;
		private var _lastErrorMsg:String;
		public var isValid:Boolean;
		public var active:Boolean = true;
		
		public var dataClass:Class;
		public var dataProperty:*;
		public var scale:Number;
		public var errorMsgOverride:String;
		public var optionsList:Array;

		//=======================================o
		//-- Constructor
		//=======================================o
		public function FormField(dynamicVariant:int, defaultLabel:String, keyBoardType:String = SoftKeyboardType.CONTACT, type:String = TYPE_MIXED_TEXT, mirrorField:FormField = null, dataReference:* = null, swearCheck:Boolean = false ) 
		{
			scale = AppData.offsetScaleX;
			trace(this + "Constructed");
			_core = Core.getInstance();
			
			_swearCheck = swearCheck

			_defaulLabel = defaultLabel;

			_value = label;
			_keyBoardType = keyBoardType;
			
			_type = type;
			_mirrorField = mirrorField;
			
			_xOffset = 40;
			_yOffset = 40;
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
			
			_stageText = new StageText();
			_tt = new TrueTouch();
			

			if (_defaultState == null)
			_defaultState = STATE_OFF;
			
			if (_label == null)
			_label = _defaulLabel;
			
			
			if (dataClass != null)
			{
				if (dataClass[dataProperty] != null && dataProperty != "password")
				_label = dataClass[dataProperty];
			}
			
			changeState(_defaultState, _label)
			addStageText();
			

		}

		public function changeState(newState:String, label:String):void 
		{
			trace(this + "changeState(" + newState + "," + label + ")");
			TexturePack.deleteTexturePack(DYNAMIC_TA_REF, taRef);
			
			var mcField:MovieClip = new TA_formField();
	
			
			var statusBar:MovieClip = new TA_fieldStatusBar();
			mcField.addChild(statusBar);
			
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
				_stageText.color = HexColours.RED;
				statusBar.gotoAndStop("error");
				_value = label;
			}	
			

			mcField.$mcArrow.visible = false;
			
			if (label == null)
			label = defaulLabel;

			_stageText.text = label;
			
			TexturePack.createFromMovieClip(mcField, DYNAMIC_TA_REF, taRef, null, 1, 1, null, 0)
			_simFormField = TexturePack.getTexturePack(DYNAMIC_TA_REF, taRef).getImage();
			this.addChild(_simFormField);
			_simFormField.scaleX = _simFormField.scaleY = AppData.offsetScaleX;

			mcField = null;
			statusBar = null;
			
			if (_type == TYPE_OPTION_LIST && !_stageText.hasEventListener(FocusEvent.FOCUS_IN))
			{
				_stageText.addEventListener(FocusEvent.FOCUS_IN, onFocusIn, false, 0, true)
			}
			

		}
		
		private function addStageText():void 
		{
			_stageText.color = 0x7E7E7E;
			_stageText.autoCorrect = false;
			_stageText.editable = true;
			_stageText.fontFamily = "Futura Std Medium";
			_stageText.fontSize = AppData.deviceScale * 34;
			
			if (PublicSettings.DEPLOYMENT_PLATFORM == Platform.ANDROID)
			_stageText.fontSize = AppData.offsetScaleX * 28;
			
			if(dataClass != null)
			_stageText.text = _label;
			else
			_stageText.text = _defaulLabel;
			
			_stageText.textAlign = TextFormatAlign.LEFT;
			_stageText.returnKeyLabel = ReturnKeyLabel.DEFAULT;
			_stageText.softKeyboardType = _keyBoardType;
			
			if(_globalContext == null)
			_globalContext = Sprite(this.parent);

			setViewPort();
									
		    _stageText.viewPort = viewPort;	
			
			
			AppUIData.arrStageTextInstanes.push(this);
			
			if (_showOnActivate == false)
			_stageText.stage = Starling.current.nativeStage;
			

			this.addEventListener(Event.ENTER_FRAME, onUpdate)
			
			if (_type == TYPE_NAME || _type == TYPE_FIRST_NAME || _type == TYPE_LAST_NAME)
			_stageText.autoCapitalize = AutoCapitalize.WORD;
			


			_stageText.addEventListener(FocusEvent.FOCUS_IN, onFocusIn, false, 0, true)
			_stageText.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut, false, 0, true)
			
			
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoved)
		}
		
		
		private function setViewPort():void 
		{	
			if(AppData.offsetScaleX < 1)
			viewPort = new Rectangle((AppData.offsetScaleX * this.x) + _globalContext.x + (AppData.offsetScaleX * 40), (this.y) + _globalContext.y + (AppData.offsetScaleX * 28), this.width - (AppData.offsetScaleX * 0), AppData.offsetScaleX * 50)
			else if (AppData.offsetScaleX > 1)
			viewPort = new Rectangle((AppData.deviceScaleX * this.x) + _globalContext.x + (AppData.deviceScaleX * 40), (this.y) + _globalContext.y + (AppData.deviceScaleX * 28), (AppData.deviceScaleX * 570) - (AppData.deviceScaleX * 0) , AppData.deviceScaleX *50)
			else
			viewPort = new Rectangle(this.x + _globalContext.x + 40, this.y + _globalContext.y + 20, this.width - 0, 50)
		}
		
		private function onRemoved(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			
			if(_stageText.hasEventListener(FocusEvent.FOCUS_IN))
			_stageText.removeEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			
			if(_stageText.hasEventListener(FocusEvent.FOCUS_OUT))
			_stageText.removeEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			
		}
		
		private function onFocusOut(e:FocusEvent):void 
		{
			_stageText.color = 0x7E7E7E;
			if (_stageText.text == "")
			{
			_stageText.text = _defaulLabel;
				if (_type == TYPE_PASSWORD)
				_stageText.displayAsPassword = false;
			}
			
			_value = _stageText.text;
			
			if(dataClass != null)
			dataClass[dataProperty] = _value;
			
		}
		
		private function onFocusIn(e:FocusEvent):void 
		{
			//if (!active)
			//return;
			
			if(_type == TYPE_OPTION_LIST)
			{
			e.preventDefault();	
			_stageText.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATING, preventSoftKey)
			_stageText.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE, preventSoftKey)
			}
			else if (_type == TYPE_PASSWORD)
			_stageText.displayAsPassword = true;
			
			
			
			_stageText.color = HexColours.GREY;
			
			if (_stageText.text == _defaulLabel || (_lastErrorMsg != null && _stageText.text == _lastErrorMsg))
			_stageText.text = "";
			
			
		}
		
		private function preventSoftKey(e:SoftKeyboardEvent):void 
		{
		    e.preventDefault(); 
			_core.nativeStage.focus = null;
		}

		private function onUpdate(e:Event):void 
		{
			this.removeEventListener(Event.ENTER_FRAME, onUpdate)
			setViewPort();
			_stageText.viewPort = viewPort;	
			
		}
		

		//===========================================o
		//-- Confirmation event of Modal UI or Option List
		//===========================================o
		public function validate():Boolean
		{
			var text:String = _value;
			isValid = false;
			var errorMsg:String;
			
			if (text == "null" || text == null)
			return false;
			
			
			trace("_defaulLabel :" + _defaulLabel);
			if (!_isRequired && text == _defaulLabel)
			{
				isValid = true;
				changeState(STATE_OFF, defaulLabel);
				return true;
			}
			
				errorMsg = errorMsgOverride;
				
				switch(_type)
				{
					
					//---------------------------o	
					
					case TYPE_NONE:
					case TYPE_OPTION_LIST:
					if (text != _defaulLabel)	
					isValid = true;	
					else 
					errorMsg = _defaulLabel;						
					
					break;
					
					//---------------------------o	
					
					case TYPE_MIXED_TEXT:
					break;
					
					//---------------------------o		
					
					case TYPE_NAME:
					if (Validation.isValidName(text) && text != _defaulLabel)	
					isValid = true;	
					else if(_defaulLabel == text)
					errorMsg = "*Please enter your name.";
					else
					errorMsg = "*Please enter a valid name."

					break;
					
					//---------------------------o		
					
					case TYPE_FIRST_NAME:
					if (Validation.isValidName(text) && text != _defaulLabel)	
					isValid = true;	
					else if(_defaulLabel == text || text == _lastErrorMsg)
					errorMsg = "*Please enter your first name.";
					else
					{
						errorMsg = "*Please enter a valid first name."
					}
					

					break;
										
					//---------------------------o		
					
					case TYPE_LAST_NAME:
					if (Validation.isValidName(text) && text != _defaulLabel)	
					isValid = true;	
					else if(_defaulLabel == text || text == _lastErrorMsg)
					errorMsg = "*Please enter your last name.";
					else
					errorMsg = "*Please enter a valid last name.";

					break;
					
					//---------------------------o	
					
					case TYPE_EMAIL:
					if (_mirrorField != null)
					{
						if (text == _mirrorField.value) 
						{
							isValid = true;
						}
						else if(_mirrorField.value == _mirrorField.defaulLabel || _mirrorField.value == _mirrorField.label)
						{
							if (text == defaulLabel)
							{
							isValid = true;
							isDefault = true;
							}
							else
							{
								isValid = false;
								errorMsg = "*Emails do not match";
							}
							
						}
						else
						{
							errorMsg = "*Please enter a valid email.";
						}
						
						
						
					}
					else
					{
						if (Validation.isValidEmail(text))
						isValid = true;
						else
						errorMsg = "*Please enter a valid email.";
					}
					break;
					
					//---------------------------o	
					
					case TYPE_PHONE:
					if (Validation.isValidPhoneNumber(text) && text != _defaulLabel)	
					isValid = true;
					else if(_defaulLabel == text)
					errorMsg = "*Please enter a phone number";
					else
					errorMsg = "*Please enter a valid phone number"
					

					break;
					
					//---------------------------o		
					
					case TYPE_POSTCODE:

						if (Validation.isValidPostCode(text) && text != _defaulLabel)	
						isValid = true;
						else if(_defaulLabel == text)
						errorMsg = "*Please enter a postcode";
						else
						errorMsg = "Please enter a valid postcode";
					
					break;
					
					//---------------------------o	
					
					case TYPE_PASSWORD:
					if (_mirrorField != null)
					{
						if (text == _mirrorField.value) 
						{
						isValid = true;
						}
						else if(_mirrorField.value == _mirrorField.defaulLabel)
						{
						isValid = true;
						isDefault = true;
						}
						else
						{
						errorMsg = "Passwords do not match.";
						}
					}
					else
					{
					
						trace("password errorMsg :"+errorMsg)
						if (StringFunctions.validatePassword(text) && text != _defaulLabel)		
						isValid = true;	
						else if(_defaulLabel == text)
						errorMsg = "*Please enter a password.";
						else
						errorMsg = "*Use letters and numbers only";
						
						trace("password isValid :"+isValid)
					}
					break;
					
					//---------------------------o	
	
					
				}
					
					var arrWordsInText:Array = text.toLowerCase().split(" ");
				
					if (_swearCheck)
					{
						for (var i:int = 0; i < arrWordsInText.length; i++) 
						{
/*							if (AppData.badWords.indexOf(arrWordsInText[i]) != -1)
							{
								isValid = false;
								errorMsg = "No profanity please.";
							}*/
						}
	
					}
			

				if (errorMsgOverride != null)
				errorMsg = errorMsgOverride;
			
			trace("=================FORM VALIDATION COMPLETE on:"+_type)
			trace("-----------------_defaulLabel :"+_defaulLabel)
			trace("-----------------text :"+text)
			trace("-----------------errorMsg :" + errorMsg)
			trace("=========================================");
			
			if (text == errorMsg)
			isValid = false
			
			_lastErrorMsg = errorMsg;
			
			if (isDefault)
			changeState(STATE_OFF, defaulLabel);
			else if(isValid)
			changeState(STATE_ON, text);
			else
			changeState(STATE_ERROR, errorMsg);
			
			return isValid;
			
		}
		
		public function reset():void {
		_defaulLabel	
		}
		
		//===========================================o
		//-- Cancel event of Modal UI or Option List
		//===========================================o		
		private function callBack_cancel():void
		{
			
		}
		

		//=========================================o
		//------ dispose/kill/terminate/
		//=========================================o
		public function trash():void
		{
			trace(this + "trash()");
			this.removeEventListeners();
			TexturePack.deleteTexturePack(DYNAMIC_TA_REF)
			
			_stageText.removeEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			_stageText.removeEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			
			_tt.trash();
			this.removeFromParent();
		}
		
		public function hide(time:Number = 0, delay:Number = 0):void 
		{
			_stageText.visible = false;
		
			if(delay > 0)
			TweenLite.to(this, time, { delay:delay, alpha:0 } )
			else
			this.alpha = 0;
			
		}
				
		public function show(time:Number = .1, delay:Number = 0):void 
		{
			TweenLite.to(this, time, {delay:delay,alpha:1, onComplete:function():void {
			_stageText.visible = true;	
			}})
		}
		
		public function get value():String 
		{
			return _value;
		}
		
		public function get defaulLabel():String 
		{
			return _defaulLabel;
		}
		
		public function get isRequired():Boolean 
		{
			return _isRequired;
		}
		
		public function set isRequired(value:Boolean):void 
		{
			_isRequired = value;
		}
		
		public function get defaultState():String 
		{
			return _defaultState;
		}
		
		public function set defaultState(value:String):void 
		{
			_defaultState = value;
		}
		
		public function get st():CustomStageText 
		{
			return _st;
		}
		
		public function set st(value:CustomStageText):void 
		{
			_st = value;
		}
		
		public function get stageText():StageText 
		{
			return _stageText;
		}
		
		public function set stageText(value:StageText):void 
		{
			_stageText = value;
		}
		
		public function get showOnActivate():Boolean 
		{
			return _showOnActivate;
		}
		
		public function set showOnActivate(value:Boolean):void 
		{
			_showOnActivate = value;
		}
		
		public function get globalContext():Sprite 
		{
			return _globalContext;
		}
		
		public function set globalContext(value:Sprite):void 
		{
			_globalContext = value;
		}
		
		public function get label():String 
		{
			return _label;
		}
		
		public function set label(value:String):void 
		{
			_label = value;
		}
		
		public function set value(value:String):void 
		{
			_value = value;
		}
		
		
		
	}

}