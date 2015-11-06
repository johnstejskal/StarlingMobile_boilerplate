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
	import data.constants.LaunchPadLibrary;
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
		private var _continueButton:SuperButton;
		private var _sim1:Image;
		private var _vo:*;
		private var _startButton:SuperButton;
		
		//===============================================o
		//------ Constructor 
		//===============================================o
		public function HomeScreen():void 
		{
			
		}

		//===============================================o
		//------  init call from state machine 
		//===============================================o
		public override function init():void 
		{		
			trace(this + "inited...");
			_vo = valueObject;
			
			//background
			var mc:* = LaunchPad.getAsset(LaunchPadLibrary.UI, "TA_backgroundGeneric");
			mc.scaleX = mc.scaleY = AppData.deviceScaleX;
			_bg = LaunchPadUtil.convertToImage(mc, DYNAMIC_REF, "TA_backgroundGeneric");
			_bg.x = AppData.deviceResX / 2;
			_bg.y = AppData.deviceResY;
			this.addChild(_bg);
		
			
			_startButton = new SuperButton("Start", onClick_startButton, "1");
			this.addChild(_startButton);
			_startButton.x = AppData.deviceResX / 2;
			_startButton.y = AppData.deviceResY / 2;
			
			var mc:*;
			var arrSpriteSequence:Array;
			//Example Sprite Sequence - 
			//create a launch pad sprite sequence
			mc = LaunchPad.getAsset(LaunchPadLibrary.UI ,  "TA_linked1");
			var ss:SpriteSequence = SpriteSequence.create(mc, null, 1, 1, null);
			ss.sequence = "TA_linked1";
			arrSpriteSequence.push(ss);
			
			mc = LaunchPad.getAsset(LaunchPadLibrary.UI ,  "TA_linked2");
			var ss:SpriteSequence = SpriteSequence.create(mc, null, 1, 1, null);
			ss = SpriteSequence.create(mc, null, 1, 1, null, 0);
			ss.sequence = "TA_linked2";
			arrSpriteSequence.push(ss);

			mc = LaunchPad.getAsset(LaunchPadLibrary.UI ,  "TA_linked3");
			ss = SpriteSequence.create(mc, null, 1, 1, null);
			ss.sequence = "TA_linked3";
			arrSpriteSequence.push(ss);
			

			//define texture pack from sequence
			var tp:TexturePack = TexturePack.createFromHelper(arrSpriteSequence, DYNAMIC_REF, "CustomNameOfSequence");
			
			//create spites from texture pack
			_sim1 = tp.getImage(false, 0, "TA_linked1");
			_sim1.x = AppData.usedScale * 10;
			_sim1.scaleX = _sim1.scaleY = AppData.deviceScaleX;
			
			mc = null;
			
			TweenLite.delayedCall(.3, animateIn, [activate]);
			
		}
		
		private function onClick_startButton():void 
		{
			
	
		}
		
		//===============================================o
		//------ Animate in
		//===============================================o
		public override function animateIn(onComplete:Function = null):void 
		{
			//transition in elements
			TweenLite.to(_startButton, .2, { x:AppData.STAGE_WIDTH/2, ease:Power1.easeInOut })
	
			TweenLite.delayedCall(.5, function():void{
						
				activate();
			})
				
			if (onComplete != null)
			onComplete();
		}
		
		private function showUI():void 
		{
			TweenLite.to(_continueButton, .3, {y:_continueButton.y = AppData.deviceResY - (AppData.deviceScaleY * 100)})
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