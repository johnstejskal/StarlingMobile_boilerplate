package view.components.screens
{


	import com.bumpslide.util.Delegate;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Linear;
	import com.greensock.TweenLite;
	import com.johnstejskal.maths.Maths;
	import flash.sampler.NewObjectSample;
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
	import vo.SpriteSheets;


	import vo.Constants;


	
	/**
	 * @author John Stejskal
	 * "Why walk when you can ride"
	 */
	
	public class TitleScreen extends Sprite
	{
		private var _core:Core;
		private var _imgBG:Image;


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
			
			//Assets.loadTextureFromFile(Assets.TA_PATH_TITLESCREEN, Assets.SPRITE_ATLAS_TITLESCREEN, this.loaded );
			//Assets.loadTextureFromFile(Assets.TA_PATH_TITLE_TEXT, Assets.SPRITE_ATLAS_TITLE_TEXT, this.loaded );
			
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
				trace(this + "onTouch(" + touch.phase + ")");
				
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
			removeEventListener(Event.ENTER_FRAME, onUpdate);
			
			//dispose texture maps
			//Assets.disposeTexture(Assets.SPRITE_ATLAS_TITLESCREEN);
			this.removeFromParent();
		}
		
		//-------------------------------------------------------------------------o
		//------ Getters and Setters 
		//-------------------------------------------------------------------------o			
		
	}
	
}