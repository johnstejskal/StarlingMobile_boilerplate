package view.components.screens
{


	import com.bumpslide.util.Delegate;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Linear;
	import com.greensock.TweenLite;
	import com.johnstejskal.maths.Maths;
	import com.johnstejskal.StarlingUtil;
	import flash.sampler.NewObjectSample;
	import interfaces.iScreen;
	import ManagerClasses.AssetsManager;
	import ManagerClasses.StateMachine;
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
	import staticData.SpriteSheets;


	import staticData.Constants;


	
	/**
	 * @author John Stejskal
	 * "Why walk when you can ride"
	 */
	
	public class TitleScreen extends Sprite implements iScreen
	{
		private var _core:Core;
		private var _imgBG:Image;
		private var _imgTitleLogo:Image;
		private var _imgButton:Image;


		//----------------------------------------o
		//------ Constructor 
		//----------------------------------------o
		public function TitleScreen():void 
		{
			_core = Core.getInstance();

			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);

		}

		//----------------------------------------------------------------------o
		//------ Private API 
		//----------------------------------------------------------------------o		
		private function init(e:Event = null):void 
		{
			trace(this + " inited");
			
			/*
			 * Load State Specific Assets
			 */
			AssetsManager.loadTextureFromFile(SpriteSheets.TA_PATH_GAME_BG, SpriteSheets.SPRITE_ATLAS_GAME_BG,  this.loaded);
			AssetsManager.loadTextureFromFile(SpriteSheets.TA_PATH_TITLE_SCREEN, SpriteSheets.SPRITE_ATLAS_TITLE_SCREEN, this.loaded );
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
		}
		//----------------------------------------o
		//------ Assets loaded callback 
		//----------------------------------------o
		private function loaded():void 
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
			this.addEventListener(TouchEvent.TOUCH, onTouch)
		}
		
		//----------------------------------------------------------------------o
		//------ Event Handlers 
		//----------------------------------------------------------------------o			
		private function onTouch(e:TouchEvent):void 
		{
			var touch:Touch = e.getTouch(stage);
            if(touch)
            {
				//trace(this + "onTouch(" + touch.phase + ")");
				
                if(touch.phase == TouchPhase.BEGAN)
                {
					EventBus.sigOnStartClicked.dispatch(StateMachine.STATE_PLAY);
                }
 
                else if(touch.phase == TouchPhase.ENDED)
                {

                }
 
                else if(touch.phase == TouchPhase.MOVED)
                {
                            
                }
            }
		}
		
		//----------------------------------------o
		//------ Entewr frame loop
		//----------------------------------------o		
		private function onUpdate(e:Event):void 
		{
			_core.animationJuggler.advanceTime(.02);
			
		}

		//----------------------------------------o
		//------ Public functions 
		//----------------------------------------o	
		
		//----------------------------------------o
		//------ dispose/kill/terminate/
		//----------------------------------------o	
		public function trash():void
		{
			//removeEventListener(Event.ENTER_FRAME, onUpdate);
			this.removeEventListeners();
			//dispose texture maps
			//Assets.disposeTexture(Assets.SPRITE_ATLAS_TITLESCREEN);
			this.removeFromParent();
		}
		
		//-------------------------------------------------------------------------o
		//------ Getters and Setters 
		//-------------------------------------------------------------------------o			
		
	}
	
}