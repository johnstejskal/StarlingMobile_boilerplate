package view.components.screens
{

	import com.greensock.easing.Back;
	import com.greensock.easing.Power1;
	import com.greensock.TweenLite;
	import com.LaunchPadUtil;
	import com.thirdsense.animation.SpriteSequence;
	import com.thirdsense.animation.TexturePack;
	import com.thirdsense.LaunchPad;
	import com.thirdsense.net.Analytics;
	import com.thirdsense.sound.SoundShape;
	import com.thirdsense.sound.SoundStream;
	import data.AppData;
	import data.constants.AppStates;
	import data.constants.LaunchPadLibrary;
	import data.formData.RegistrationFormData;
	import data.PlayerData;
	import data.valueObjects.ValueObject;
	import flash.geom.Rectangle;
	import flash.text.SoftKeyboardType;
	import flash.text.TextFieldAutoSize;
	import flash.utils.getQualifiedClassName;
	import interfaces.iScreen;
	import ManagerClasses.StateMachine;
	import singleton.EventBus;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import view.components.ui.buttons.*;
	import view.components.ui.buttons.SuperButton;
	import view.components.ui.form.FormField;



	//===============================================o
	/**
	 * @author John Stejskal
	 * "why walk when you can ride"
	 */
	//===============================================o
	
	public class RegisterScreen extends Screen implements iScreen
	{
		private const DYNAMIC_REF:String = getQualifiedClassName (this);

		
		private var _vo:ValueObject;
		
		//buttomns
		private var _button1:ButtonType1;
		private var _arrFormItems:Array;
		
		private var _gap:int = 5;
		private var _spFormHolder:Sprite;
		
		private var _ffFirstName:FormField;
		private var _ffLastName:FormField;
		private var _ffEmail:FormField;
		private var _ffPassword:FormField;
		
		//===============================================o
		//------ Constructor 
		//===============================================o
		public function RegisterScreen():void 
		{

		}
		
		//===============================================o
		//------  init call from state machine 
		//===============================================o
		public override function init():void 
		{		
			trace(this + "inited...");
			//load data, set properties
			
			//background
			super.setBG();
		
			 _arrFormItems = new Array();
			 _gap = AppData.deviceScale * _gap;
			 _spFormHolder = new Sprite();
			

			this.addChild(_spFormHolder);
			_spFormHolder.y = 200;
			_spFormHolder.x = AppData.offsetScaleX * 60;

			setFormFields();
			
			//start button
			_button1 = new ButtonType1("Submit", onClick_button1, "1");
			 this.addChild(_button1);
			_button1.x = AppData.deviceResX / 2;
			_button1.y = _spFormHolder.y + _spFormHolder.height + (100 * AppData.deviceScale);
			
			TweenLite.delayedCall(.1, loaded);
			
			
		}
		
		//==========================================o
		//------ loaded 
		//-- State is fully loaded
		//==========================================o
		public override function loaded():void 
		{
			_vo = super.valueObject;
			TweenLite.delayedCall(.3, animateIn, [initComplete]);
			
		}
		
		private function setFormFields():void 
		{
			var requiredFName:Boolean = true;
			
			if (PlayerData.firstName != null)
			{
				requiredFName = false;
				//RegistrationFormData.firstName = PlayerData.firstName;
			}
			_ffFirstName = new FormField(1, "*First Name", SoftKeyboardType.DEFAULT, FormField.TYPE_FIRST_NAME);
			_ffFirstName.label = PlayerData.firstName;
			_ffFirstName.globalContext = _spFormHolder;
			_ffFirstName.dataClass = RegistrationFormData;
			_ffFirstName.dataProperty = "firstName";
			_ffFirstName.isRequired = requiredFName;
			
			//------------------------------o
			
			_ffLastName = new FormField(2, "*Last Name", SoftKeyboardType.DEFAULT, FormField.TYPE_LAST_NAME);
			_ffLastName.label = PlayerData.lastName;
			_ffLastName.globalContext = _spFormHolder;
			_ffFirstName.dataClass = RegistrationFormData;
			_ffLastName.dataProperty = "lastName";
			_ffLastName.isRequired = requiredFName;
			
			//------------------------------o
			
			_ffEmail = new FormField(3, "*Email", SoftKeyboardType.DEFAULT, FormField.TYPE_EMAIL);
			_ffEmail.label = PlayerData.email;
			_ffEmail.globalContext = _spFormHolder;
			_ffEmail.dataClass = RegistrationFormData;
			_ffEmail.dataProperty = "email";
			_ffEmail.isRequired = requiredFName;
			
			//------------------------------o
			
			_ffPassword = new FormField(5, "*Password", SoftKeyboardType.DEFAULT, FormField.TYPE_PASSWORD);
			_ffPassword.globalContext = _spFormHolder;
			_ffPassword.dataClass = RegistrationFormData;
			_ffPassword.dataProperty = "password";
			_ffPassword.isRequired = true;
			_ffPassword.errorMsgOverride = "*Please enter a password"
			
			_arrFormItems.push(_ffFirstName, _ffLastName, _ffEmail, _ffPassword);
			
			var h:int = 0;
			
			//setPositions
			for (var i:int = 0; i < _arrFormItems.length; i++) 
			{
				var item:FormField = _arrFormItems[i];
				item.y = h * i + (_gap * i);
				_spFormHolder.addChild(item);
				item.hide();
				
				if (i == 0)
				h = item.height;
			}			
			
		}
		
		private function animateInForms():void 
		{
			for (var i:int = 0; i < _arrFormItems.length; i++) 
			{
				_arrFormItems[i].show(.2, .05* i); //["show"]();
			}	
		}
		
		private function validateForms(onSuccess:Function = null, onFail:Function = null):void 
		{
			var total:int = _arrFormItems.length;
			var validCount:int = 0;
			for (var i:int = 0; i < total; i++) 
			{
				if (FormField(_arrFormItems[i]).validate())
				validCount ++;
			}	
			
			if (validCount == total)
			{
				if (onSuccess)
				onSuccess();
			}
			else
			{
				if (onFail)
				onFail();
			}
			
		}	
		//===============================================o
		//------ Button handlers
		//===============================================o
	    private function onClick_button1():void 
	    {
			
			validateForms(onSuccess)
		}
		
		private function onSuccess():void 
		{
			core.controlBus.appUIController.changeScreen(AppStates.STATE_HOME)
		}
		
		//===============================================o
		//------ Animate in
		//===============================================o
		public override function animateIn(onComplete:Function = null):void 
		{
			//transition in elements
			animateInForms();
			
			//set Callback for animation complete
			TweenLite.delayedCall(.5, function():void
			{
				if (onComplete != null)
				onComplete();
			})

		}
		
		//===============================================o
		// ---- Animate Out
		//===============================================o
		public override function animateOut(onComplete:Function = null):void 
		{
			//transition Out
			
			if (onComplete != null)
			onComplete();
		}
		

		//===============================================o
		//------ dispose/kill/terminate/
		//===============================================o
		public override function trash():void
		{
			trace(this + "trash()");
			core.controlBus.appUIController.removeStageText();
			this.removeEventListeners();
						
			TexturePack.deleteTexturePack(DYNAMIC_REF);
			this.removeFromParent();
		}
		
		//===============================================o
		//------ Getters and Setters 
		//===============================================o			
		
	}
	
}