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
	import data.valueObjects.ValueObject;
	import flash.geom.Rectangle;
	import flash.text.TextFieldAutoSize;
	import flash.utils.getQualifiedClassName;
	import interfaces.iScreen;
	import ManagerClasses.StateMachine;
	import singleton.EventBus;
	import starling.display.Image;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import view.components.ui.buttons.ButtonType1;
	import view.components.ui.buttons.SuperButton;



	//===============================================o
	/**
	 * @author John Stejskal
	 * "why walk when you can ride"
	 */
	//===============================================o
	
	public class HomeScreen extends Screen implements iScreen
	{
		private const DYNAMIC_REF:String = getQualifiedClassName (this);

		private var _bg:Image;
		
		private var _vo:ValueObject;
		
		private var _button1:ButtonType1;
		private var _button2:ButtonType1;
		
		//===============================================o
		//------ Constructor 
		//===============================================o
		public function HomeScreen():void 
		{
			
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
		
		//===============================================o
		//------  init call from state machine 
		//===============================================o
		public override function init():void 
		{		
			trace(this + "inited...");
			//Draw All Objects, load data
			
			//background
			//super.setBG();
		
			//start button
			_button1 = new ButtonType1("Change State", onClick_button1, "1");
			this.addChild(_button1);
			_button1.x = AppData.deviceResX / 2;
			_button1.y = AppData.deviceResY / 2;
			
			_button2 = new ButtonType1("Show Popup", onClick_button2, "2");
			this.addChild(_button2);
			_button2.x = AppData.deviceResX / 2;
			_button2.y = _button1.y + _button1.height + 20;
			
			//mc = null;
			
			TweenLite.delayedCall(.1, loaded);
			
		}
		

		
		
		//===============================================o
		//------ Button handlers
		//===============================================o
	    private function onClick_button1():void 
	    {
			core.controlBus.appUIController.changeScreen(AppStates.STATE_SETTINGS)
		}
		
		private function onClick_button2():void 
		{
			core.controlBus.appUIController.showNotification("Title", "sub title", "copy text", "YES", "NO", null, null);
		}
		
		//===============================================o
		//------ Animate in
		//===============================================o
		public override function animateIn(onComplete:Function = null):void 
		{
			//transition in elements
			
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
			this.removeEventListeners();
						
			TexturePack.deleteTexturePack(DYNAMIC_REF);
			this.removeFromParent();
		}
		
		//===============================================o
		//------ Getters and Setters 
		//===============================================o			
		
	}
	
}