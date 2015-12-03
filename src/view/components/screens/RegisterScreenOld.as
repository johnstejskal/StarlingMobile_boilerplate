package view.components.screens
{
	import com.greensock.easing.Power1;
	import com.greensock.TweenLite;
	import com.johnstejskal.TrueTouch;
	import com.johnstejskal.Util;
	import com.thirdsense.animation.TexturePack;
	import com.thirdsense.LaunchPad;
	import com.thirdsense.net.Analytics;
	import com.thirdsense.ui.starling.LPsWebBrowser;
	import com.thirdsense.ui.starling.ScrollControl;
	import com.thirdsense.ui.starling.ScrollType;
	import flash.events.LocationChangeEvent;
	import flash.media.StageWebView;
	import flash.text.SoftKeyboardType;
	import flash.text.StyleSheet;
	import ManagerClasses.StateMachine;
	import net.Services;
	import starling.display.Image;
	import starling.display.MovieClip;
	import flash.utils.getQualifiedClassName;
	import interfaces.iScreen;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import staticData.AnalyticsLabels;
	import staticData.AppData;
	import staticData.dataObjects.formData.RegistrationFormData;
	import staticData.dataObjects.PlayerData;
	import staticData.DeviceType;
	import staticData.settings.PublicSettings;
	import staticData.Urls;
	import staticData.valueObjects.PlayerVO;
	import treefortress.sound.SoundAS;
	import view.components.ui.buttons.OrangeButton;
	import view.components.ui.CustomCheckBox;
	import view.components.ui.form.FormField;
	import view.components.ui.FormField;
	import view.components.ui.FormFieldDropDown;

	//==========================================o
	/**
	 * @author John Stejskal
	 * johnstejskal@gmail.com
	 * "Why walk when you can ride"
	 */
	//==========================================o
	public class RegisterScreenOld extends SuperScreen implements iScreen
	{
		private const DYNAMIC_TA_REF:String = getQualifiedClassName(this);

		private var _ffFirstName:FormField;
		private var _ffLastName:FormField;
		private var _ffEmail:FormField;
		private var _ffConfirmEmail:FormField;
		private var _ffPassword:FormField;
		private var _btnSubmit:OrangeButton;

		private var _gap:int = 20;
		private var _spFormHolder:Sprite;
		private var _cbPrivacy:CustomCheckBox;
		private var _smcTextPrivacy:MovieClip;
		private var _smcTextOptIn:MovieClip;
		private var _imgHBeaderBlock:Image;
		private var _arrFormItems:Array;
		private var _ffState:FormFieldDropDown;
		private var _ffEmployer:FormField;
		private var _cbOptIn:CustomCheckBox;
		private var _sc:ScrollControl;
		private var _this:RegisterScreen;
		private var _clickAreaTermsOfuse:Quad;
		private var _clickAreaPrivacyPolicy:Quad;
		private var _tt:TrueTouch;
		private var invoker:StageWebView;

		//==========================================o
		//------ Constructor /\/\/\/\/\/\/\/\/\/\/\/\
		//==========================================o
		public function RegisterScreenOld():void 
		{
			_this = this;
		}

		//==========================================o
		//------ Assets loaded callback 
		//==========================================o
		public override function loaded():void 
		{
		    
		    trace(this + "loaded():"+DYNAMIC_TA_REF);
		   super.setBG();
		   
			_tt = new TrueTouch();
		   _arrFormItems = new Array();
		   //-- Header Block
		   
		   _gap = AppData.deviceScale * _gap;
		   var heading:String = "Register";
		   var subHeading:String = "Create an account to submit high scores, save your car upgrades and earn rewards.";
		 
		   if (DeviceType.type == DeviceType.IPHONE_4)
		   {
			//subHeading = "";
			_gap = AppData.deviceScale * 12;
		   }
		   else if (DeviceType.type == DeviceType.IPAD)
		   {
			subHeading = "";
			_gap = AppData.deviceScale * 10;
		   }
		   
		   var mc:*;
		   
		   mc = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "MC_HeaderWithSubLeftAligned");
		   mc.$txheader.text = heading;
		   mc.$txSubheader.text = subHeading;
		   mc.scaleX = mc.scaleY = AppData.deviceScale;
		   
		   TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "MC_HeaderWithSubLeftAligned", null, 1, 1, null, 0)
		   _imgHBeaderBlock = TexturePack.getTexturePack(DYNAMIC_TA_REF, "MC_HeaderWithSubLeftAligned").getImage();
		   _imgHBeaderBlock.x = AppData.deviceResX;
		   _imgHBeaderBlock.y = super.getStartingYPos();
		   this.addChild(_imgHBeaderBlock);		 
		  
			_spFormHolder = new Sprite();
			
			if (DeviceType.type == DeviceType.IPHONE_4)
			_spFormHolder.y = _imgHBeaderBlock.y + _imgHBeaderBlock.height;
			else if (DeviceType.type == DeviceType.IPAD)
			_spFormHolder.y = _imgHBeaderBlock.y + AppData.deviceScale * 80;	
			else
			_spFormHolder.y = _imgHBeaderBlock.y + _imgHBeaderBlock.height + (AppData.deviceScale * 30);
			
			
			
			this.addChild(_spFormHolder);
			//---------------------------------------o
			var requiredFName:Boolean = true;
			
			if (PlayerData.firstName != null)
			{
				requiredFName = false
				RegistrationFormData.firstName = PlayerData.firstName;
			}
			
			_ffFirstName = new FormField(1, "*First Name", SoftKeyboardType.DEFAULT, FormField.TYPE_FIRST_NAME);
			_ffFirstName.label = PlayerData.firstName;
			_ffFirstName.globalContext = _spFormHolder;
			_ffFirstName.dataClass = RegistrationFormData;
			_ffFirstName.dataProperty = "firstName";
			_ffFirstName.isRequired = requiredFName;
			_ffFirstName.y = 0;
			_spFormHolder.addChild(_ffFirstName);
			_ffFirstName.hide(0);
			_arrFormItems.push(_ffFirstName);
			
			//---------------------------------------o

			var requiredLName:Boolean = true;
			if (PlayerData.lastName != null)
			{
			requiredLName = false;
			RegistrationFormData.lastName = PlayerData.lastName;
			}
			
			_ffLastName = new FormField(2, "*Last name", SoftKeyboardType.DEFAULT, FormField.TYPE_LAST_NAME);
			_ffLastName.label = PlayerData.lastName;
			_ffLastName.globalContext = _spFormHolder;
			_ffLastName.dataClass = RegistrationFormData;
			_ffLastName.dataProperty = "lastName";
			_ffLastName.isRequired = requiredLName;
			//_ffLastName.showOnActivate = true;

			_ffLastName.y = (_ffFirstName.y + _ffFirstName.height + _gap);
			_spFormHolder.addChild(_ffLastName);
			_ffLastName.hide(0);	
			_arrFormItems.push(_ffLastName);
			//---------------------------------------o

			var requiredEmail:Boolean = true;
			if (PlayerData.email != null)
			{
			requiredEmail = false;
			RegistrationFormData.email = PlayerData.email;
			}
			
			_ffEmail = new FormField(3, "*Email", SoftKeyboardType.EMAIL, FormField.TYPE_EMAIL);
			_ffEmail.label = PlayerData.email;
			_ffEmail.isRequired = requiredEmail;
			_ffEmail.dataClass = RegistrationFormData;
			_ffEmail.dataProperty = "email";
			_ffEmail.globalContext = _spFormHolder;
			//_ffEmail.showOnActivate = true;

			_ffEmail.y = (_ffLastName.y + _ffFirstName.height + _gap);
			_spFormHolder.addChild(_ffEmail);
			_ffEmail.hide(0);
			_arrFormItems.push(_ffEmail);
			//---------------------------------------o
			
			
			_ffPassword = new FormField(5, "*Password", SoftKeyboardType.DEFAULT, FormField.TYPE_PASSWORD);
			_ffPassword.globalContext = _spFormHolder;
			//_ffPassword.showOnActivate = true;
			_ffPassword.dataClass = RegistrationFormData;
			_ffPassword.dataProperty = "password";
			_ffPassword.isRequired = true;
			_ffPassword.errorMsgOverride = "*Please enter a password"
			_ffPassword.y = (_ffEmail.y + _ffEmail.height + _gap);
			_spFormHolder.addChild(_ffPassword);
			_ffPassword.hide(0);
			_arrFormItems.push(_ffPassword);
			//------------------------------o			
			

/*			var requiredEmployer:Boolean = true;
			if (PlayerData.employer != null)
			{
			requiredEmployer = false;
			RegistrationFormData.employer = PlayerData.employer;
			}
			
			_ffEmployer = new FormField(26, "*Employer", SoftKeyboardType.DEFAULT, FormField.TYPE_NONE);
			_ffEmployer.label = PlayerData.employer;
			_ffEmployer.globalContext = _spFormHolder;
			_ffEmployer.dataClass = RegistrationFormData;
			_ffEmployer.dataProperty = "employer";
			_ffEmployer.isRequired = requiredLName;
			_ffEmployer.errorMsgOverride = "*Please enter your employer.";

			_ffEmployer.y = (_ffPassword.y + _ffPassword.height + _gap);
			_spFormHolder.addChild(_ffEmployer);
			_ffEmployer.hide(0);	
			_arrFormItems.push(_ffEmployer);*/
			//---------------------------------------o
			
/*			_ffState = new FormFieldDropDown(7, "State");
			_ffState.optionsList = new Array("NSW", "SA", "WA", "QLD", "NT", "TAS", "VIC", "ACT");
			
			_ffState.dataClass = RegistrationFormData;
			_ffState.dataProperty = "state";
			_ffState.isRequired = true;

			_ffState.y = (_ffEmployer.y + _ffEmployer.height + _gap);
			_spFormHolder.addChild(_ffState);
			//_ffState.hide(0);
			_arrFormItems.push(_ffState);*/
			
			//------------------------------o
			
			_cbPrivacy = new CustomCheckBox(1, null);
			_cbPrivacy.isRequired = true;
			_cbPrivacy.x = 0;
			_cbPrivacy.y = _ffPassword.y + _ffPassword.height + _gap;
			_spFormHolder.addChild(_cbPrivacy);
			_cbPrivacy.alpha = 0;
			mc = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_textPrivacyConfirm");
			mc.scaleX = mc.scaleY =  AppData.deviceScale;
			mc.gotoAndStop("black")
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_textPrivacyConfirm", null, 1, 2, null, 0)
			_smcTextPrivacy = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_textPrivacyConfirm").getMovieClip();
			_smcTextPrivacy.currentFrame = 0;
			_smcTextPrivacy.x = _cbPrivacy.x + AppData.deviceScale *60;
			_smcTextPrivacy.y = _cbPrivacy.y + 5;
			_smcTextPrivacy.alpha = 0;
			_spFormHolder.addChild(_smcTextPrivacy);
			
			
			_spFormHolder.x = (AppData.deviceResX - _ffLastName.width) / 2;
			
		   //Login Button -------------------------------------o
		   _btnSubmit = new OrangeButton("Submit", onClickSubmit, "_btnLogin")
		   _btnSubmit.x = (AppData.deviceResX / 2);
		   this.addChild(_btnSubmit);
		   _btnSubmit.y = AppData.deviceResY + _btnSubmit.height;
		   
		   _clickAreaTermsOfuse = new Quad(AppData.deviceScale * 170, AppData.deviceScale * 40, 0xff00ff);  
		   _clickAreaPrivacyPolicy = new Quad(AppData.deviceScale * 170, AppData.deviceScale * 40, 0xff00ff); 
		   _clickAreaTermsOfuse.alpha = 0;
		   _clickAreaPrivacyPolicy.alpha = 0;
		   
		   _clickAreaTermsOfuse.x = _smcTextPrivacy.x + AppData.deviceScale * 140;
		   _clickAreaTermsOfuse.y =  _smcTextPrivacy.y;
		  
		   _clickAreaPrivacyPolicy.x = _smcTextPrivacy.x + AppData.deviceScale * 365;
		   _clickAreaPrivacyPolicy.y =  _smcTextPrivacy.y;
		  
		   _spFormHolder.addChild(_clickAreaTermsOfuse);
		   _spFormHolder.addChild(_clickAreaPrivacyPolicy);
		   
		   _clickAreaTermsOfuse.addEventListener(TouchEvent.TOUCH, onTouch);
		   _clickAreaPrivacyPolicy.addEventListener(TouchEvent.TOUCH, onTouch);
		   
		   TweenLite.delayedCall(.5, animateIn, [initComplete]);
		   
			if (PublicSettings.ENABLE_ANALYTICS)
			Analytics.trackScreen(AnalyticsLabels.REGISTER_SCREEN)		   
		   
		}
		
		private function onClickSubmit():void 
		{
			checkFields();
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
					
					switch(e.target)
					{
						case _clickAreaPrivacyPolicy:
							
						var tBrowser1:LPsWebBrowser = new LPsWebBrowser(Urls.privacyPolicy);
						invoker = tBrowser1.invoke();
						invoker.addEventListener(LocationChangeEvent.LOCATION_CHANGING, onLocationChange1, false, 0, true);
						
						if (PublicSettings.ENABLE_ANALYTICS)
						Analytics.trackScreen(AnalyticsLabels.PRIVACY_SCREEN)		
						
						break;
												
						case _clickAreaTermsOfuse:
						var tBrowser2:LPsWebBrowser = new LPsWebBrowser(Urls.termsAndConditions);
						invoker = tBrowser2.invoke();
						invoker.addEventListener(LocationChangeEvent.LOCATION_CHANGING, onLocationChange1, false, 0, true);
						
						if (PublicSettings.ENABLE_ANALYTICS)
						Analytics.trackScreen(AnalyticsLabels.TERMS_OF_USE_SCREEN)							
						break;
						
					}
					
					
					
                }
 
                else if(touch.phase == TouchPhase.MOVED)
                {
                            
                }
            }
		}
		
		//==========================================o
		//------ Animate In
		//==========================================o
		public override function animateIn(onComplete:Function = null):void 
		{
			TweenLite.to(_imgHBeaderBlock, .2, { x:AppData.offsetScaleX * 60, ease:Power1.easeInOut, onStart:function():void{
				SoundAS.play("swish2")
			}})
			TweenLite.to(_cbPrivacy, .2, {delay:.3, alpha:1} )
			TweenLite.to(_smcTextPrivacy, .2, {delay:.2, alpha:1} )
			TweenLite.to(_btnSubmit, .2, {delay:.1, y:AppData.deviceResY-(_btnSubmit.height + AppData.deviceScale * 40), onStart:function():void{
				SoundAS.play("swish1")
			}})
			
			trace("_arrFormItems :" + _arrFormItems);
		
			for (var i:int = 0; i < _arrFormItems.length; i++) 
			{
				_arrFormItems[i].show(.2, .05* i); //["show"]();
			}
			
						
			if(onComplete != null)
			TweenLite.delayedCall(.3, onComplete);			
		}
		
		//==========================================o
		//------ Animate Out
		//==========================================o	
		public override function animateOut(onComplete:Function = null):void 
		{
			for (var i:int = 0; i < _arrFormItems.length; i++) 
			{
				_arrFormItems[i].hide(.05, .05* i);
			}			
			TweenLite.to(_imgHBeaderBlock, .2, { x: AppData.deviceResX, ease:Power1.easeInOut } )
			TweenLite.to(_cbPrivacy, .2, {alpha:0} )
			TweenLite.to(_btnSubmit, .2, {y:AppData.deviceResY+_btnSubmit.height} )
			if(onComplete != null)
			TweenLite.delayedCall(.35, onComplete);
		}
		
		//=======================================o
		//-- Validate fields
		//=======================================o
		private function checkFields():void 
		{
			trace(this + "checkFormFields()");

				_ffFirstName.callBack_confirm(_ffFirstName.value);
				_ffLastName.callBack_confirm(_ffLastName.value);
				_ffEmail.callBack_confirm(_ffEmail.value);
				_ffPassword.callBack_confirm(_ffPassword.value);
				_cbPrivacy.check();
			
			if (_ffFirstName.isValid &&
					_ffLastName.isValid &&
					_ffEmail.isValid &&
					_ffPassword.isValid && 
					_cbPrivacy.isValid

				)
				{
					trace(this + "fields have all validated.. ");
					
					PlayerData.firstName = _ffLastName.value;
					PlayerData.lastName = _ffLastName.value;
					PlayerData.email = _ffEmail.value;
					
					doRegister();
				}
				else
				{
					//_stxError.text = HeaderLabels.FORM_ERROR_MESSAGE_1;
				}
			
			
		}
		
		
		//=======================================o
		//--- SERVICES
		//=======================================o
		
		private function doRegister():void
		{
			var playerVO:PlayerVO = new PlayerVO();
			
			playerVO.firstName = _ffFirstName.value;
			playerVO.lastName = _ffLastName.value;
			playerVO.email = _ffEmail.value;
			playerVO.password = _ffPassword.value;
	

			PlayerData.firstName = playerVO.firstName;
			PlayerData.lastName = playerVO.lastName;
			PlayerData.email = playerVO.email;


			Services.register.execute(playerVO, true, true, function():void 
			{
				
				core.controlBus.appUIController.changeScreen(StateMachine.STATE_ACTIVATE_ACCOUNT);

					
			})
		}

		
	
		private function onClickPlayAgain():void 
		{
			
		}
		
		//==========================================o
		//------ init
		//==========================================o
		override public function init():void 
		{

		}

		//===========================================o	
		// override activate
		//===========================================o	
		public override function activate():void
		{
			trace(this + "activate()");


		}
		
		
		//===========================================o	
		// override deactivate
		//===========================================o	
		public override function deactivate():void
		{
			if(this.parent && _sc != null)
			_sc.disable();
			//_sc.kill();
		}
		
		
		//==========================================o
		//------ Event Handlers 
		//==========================================o		

		private function onLocationChange1(e:LocationChangeEvent):void 
		{
			StateMachine.allowDeviceActivate = false;
			
			trace(this+"onLocationChange1:"+e.location)
			invoker.stop();
			
			var targ:String = String(e.location);
			 Util.openURL(targ)

		}
		

		//==========================================o
		//------ Public functions 
		//==========================================o
		
		//==========================================o
		//------ dispose/kill/terminate/
		//==========================================o
		public override function trash():void
		{
			trace(this + "trash()");
			this.removeEventListeners();
			
			core.controlBus.appUIController.removeStageText();
			//dispose texture maps
			TexturePack.deleteTexturePack(DYNAMIC_TA_REF)
			this.removeFromParent();
			
			if (_tt)
			{
				_tt.trash();
				_tt = null;
			}
			
			try
			{
				if (invoker != null)
				{
					if (invoker.hasEventListener(LocationChangeEvent.LOCATION_CHANGING))
					{
						invoker.removeEventListener(LocationChangeEvent.LOCATION_CHANGING, onLocationChange1)
						//invoker.removeEventListener(LocationChangeEvent.LOCATION_CHANGING, onLocationChange2)
					}
				}
			}catch (e:Error)
			{
				trace(this +"Error :"+ e.message);
			}
			
			
			if(this.parent && _sc != null)
			_sc.kill();
		}
		


		
		//==========================================o
		//------ Getters and Setters 
		//==========================================o			
		
	}
	
}