package view.components.screens
{


	import com.greensock.easing.Cubic;
	import com.greensock.easing.Linear;
	import com.greensock.TweenLite;
	import com.johnstejskal.StarlingUtil;
	import flash.sampler.NewObjectSample;
	import interfaces.iScreen;
	import ManagerClasses.AssetsManager;
	import ManagerClasses.StateMachine;
	import org.gestouch.events.GestureEvent;
	import org.gestouch.gestures.SwipeGesture;
	import singleton.Core;
	import singleton.EventBus;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import staticData.Data;
	import staticData.settings.DeviceSettings;
	import staticData.SpriteSheets;


	import staticData.Constants;


	//===============================================o
	/**
	 * @author John Stejskal
	 * "Why walk when you can ride"
	 */
	//===============================================o
	
	public class TitleScreen extends Screen implements iScreen
	{
		private var _core:Core;
		private var _imgBG:Image;
		private var _imgTitleLogo:Image;
		private var _imgButton:Image;


		//===============================================o
		//------ Constructor 
		//===============================================o
		public function TitleScreen():void 
		{
			_core = Core.getInstance();

		}

		//===============================================o
		//------ Assets loaded callback 
		//===============================================o
		public override function loaded():void 
		{
			trace(this + "loaded()");
			
			_imgBG = new Image(AssetsManager.getAtlas(SpriteSheets.SPRITE_ATLAS_GAME_BG).getTexture("TA_bg_10000"));
			
			this.addChild(_imgBG);
			
			_imgTitleLogo = new Image(AssetsManager.getAtlas(SpriteSheets.SPRITE_ATLAS_TITLE_SCREEN).getTexture("TA_titleScreenLogo0000"));
			StarlingUtil.setRegPoint(_imgTitleLogo, StarlingUtil.CENTER);
			StarlingUtil.setScreenPos(_imgTitleLogo, StarlingUtil.CENTER)
			StarlingUtil.setScale(_imgTitleLogo, Data.deviceScaleX)
			
			this.addChild(_imgTitleLogo);	
			
			
			_imgButton = new Image(AssetsManager.getAtlas(SpriteSheets.SPRITE_ATLAS_TITLE_SCREEN).getTexture("TA_button10000"));
			StarlingUtil.setRegPoint(_imgButton, StarlingUtil.TOP_LEFT);
			StarlingUtil.setScale(_imgButton, Data.deviceScaleX)

			this.addChild(_imgButton);	
				
			//addListeners
			if (DeviceSettings.ENABLE_TOUCH)
			this.addEventListener(TouchEvent.TOUCH, onTouch)

		}
		
		
		//===============================================o
		//------ Touch Handlers 
		//===============================================o	
		private function onTouch(e:TouchEvent):void 
		{
			var touch:Touch = e.getTouch(stage);
            if(touch)
            {
				//trace(this + "onTouch(" + touch.phase + ")");
				
                if(touch.phase == TouchPhase.BEGAN)
                {				
					if (e.target == _imgButton)
					{
					EventBus.getInstance().sigScreenChangeRequested.dispatch(StateMachine.STATE_PLAY);
					}
					
                }
 
                else if(touch.phase == TouchPhase.ENDED)
                {

                }
 
                else if(touch.phase == TouchPhase.MOVED)
                {
                            
                }
            }
		}
		
		
		
		//===============================================o
		//------ Enter frame loop
		//===============================================o	
		private function onUpdate(e:Event):void 
		{
			_core.animationJuggler.advanceTime(.02);
			
		}


		//===============================================o
		//------ dispose/kill/terminate/
		//===============================================o
		public override function trash():void
		{
			trace(this + "trash()");
			this.removeEventListeners();
			
			//dispose texture maps
			
			this.removeFromParent();
		}
		
		//===============================================o
		//------ Getters and Setters 
		//===============================================o			
		
	}
	
}