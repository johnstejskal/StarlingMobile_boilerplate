package view.components.screens
{



	import com.greensock.TweenLite;
	import com.johnstejskal.ArrayUtil;
	import com.johnstejskal.Delegate;
	import com.johnstejskal.maths.Mathematics;
	import com.johnstejskal.maths.Maths;
	import com.johnstejskal.StringFunctions;
	import flash.display.Bitmap;
	import flash.display.Stage;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import ManagerClasses.AssetsManager;
	import ManagerClasses.ObjectPools.ObjPool_BloodPuddle;
	import ManagerClasses.ObjectPools.ObjPool_BloodSplat;
	import ManagerClasses.ObjectPools.ObjPool_Coin;
	import ManagerClasses.ObjectPools.ObjPool_effects;
	import ManagerClasses.ObjectPools.ObjPool_enemy;
	import ManagerClasses.ObjectPools.ObjPool_MeatSplat;
	import org.gestouch.events.GestureEvent;
	import org.gestouch.gestures.SwipeGesture;
	import org.osflash.signals.Signal;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.events.Event;
	import flash.events.MouseEvent;
	import starling.display.Sprite;
	import flash.events.KeyboardEvent;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.TextureSmoothing;
	import starling.utils.Color;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	import view.components.gameobjects.Car;
	import view.components.gameobjects.Coin;
	import view.components.gameobjects.MapTile;
	import vo.Data;
	import vo.SpriteSheets;

	import view.components.ui.DevConsole;


	import starling.utils.deg2rad;
	import starling.utils.rad2deg;
	import ManagerClasses.StateMachine;


	import singleton.Core;

	import vo.Constants;


	
	/**
	 * ...
	 * @author john stejskal
	 */
	public class PlayScreen extends Sprite
	{
		
		private var _core:Core;
		private var _nativeStage:Stage;
		
		//game layers
		private var _layerUnderlay:Sprite; //items beneath player
		private var _layerAction:Sprite;  //player layer
		private var _layerOverlay:Sprite; //effects overlay
		
		private var _imgBG:Image;
		private var _currBGName:String;
		private var _isGameInPlay:Boolean = false;
		private var _stateMachine:StateMachine;
		
		

		
		
		//----------------------------------------o
		//------ Constructor
		//----------------------------------------o
		public function PlayScreen():void 
		{
			trace(this + " PlayScreen()");

			_core = Core.getInstance();
			_nativeStage = Starling.current.nativeStage;
			
			StateMachine._oPlayScreen = this;

			if (stage) StateMachine.setup_callBack();
			else addEventListener(Event.ADDED_TO_STAGE, function(e:Event = null):void{StateMachine.setup_callBack();});
		}
		
		//------------------------------------------------------------------------------o
		//------ Public API 
		//------------------------------------------------------------------------------o		
		public function init(levelToLoad:String = "level1"):void
		{
			trace("levelToLoad :" + levelToLoad)
			
			
			//------------Load State Assets ---------------//
			switch(levelToLoad)
			{
				case "level1":
					_currBGName = SpriteSheets.SPRITE_ATLAS_GAME_BG;
					AssetsManager.loadTextureFromFile(SpriteSheets.TA_PATH_GAME_BG, SpriteSheets.SPRITE_ATLAS_GAME_BG,  this.loaded);
				break;
				
				case "level2":
					_currBGName = SpriteSheets.SPRITE_ATLAS_GAME_BG;
				break;
								
				case "level3":
					_currBGName = SpriteSheets.SPRITE_ATLAS_GAME_BG;
				break;
				
			}

		}
		
		//----------------------------------------o
		//------ AssetLoad Callback
		//----------------------------------------o
		public function loaded():void
		{
			trace(this + "loaded()");
			createWorld();
		}
		
		//------------------------------------------------------------------------------o
		//------ Private  API 
		//------------------------------------------------------------------------------o	
		//------------------------------------------o
		//-- Setup and position all the components
		//------------------------------------------o
		private function createWorld():void 
		{
			
			trace(this + "createLevel()");	
			this.alpha = 0.99;
			
			_imgBG = new Image(AssetsManager.getAtlas(_currBGName).getTexture("TA_bg_30000"));
			this.addChild(_imgBG);
			
			//setup layers for indexed asset management
			_layerUnderlay = new Sprite();
			this.addChild(_layerUnderlay);	
			
			_layerAction = new Sprite();
			this.addChild(_layerAction);				
			
			_layerOverlay = new Sprite();
			this.addChild(_layerOverlay);

			
			//fillObjectPool(DataVO["LEVEL_" + DataVO.currentGameLevel + "_WAVE_" + DataVO.currentWave]);
			
			
			//----------------AddEventListeners--------------------o
			this.addEventListener(TouchEvent.TOUCH, onTouch)
			
			
			startGameplay();
			
			
		}	
		
		//------------------------------------------o
		//-- Start Game Play
		//------------------------------------------o
		private function startGameplay():void 
		{
			trace(this + " startGameplay()");
			_isGameInPlay = true; 
			this.addEventListener(Event.ENTER_FRAME, update_gameLoop);
			
		}
		

		//------------------------------------------------------------------------------o
		//------ Event Handlers 
		//------------------------------------------------------------------------------o	
		//------------------------------------o
		//-- Screen Touch events
		//------------------------------------o
		private function onTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(stage);
			if(touch)
			{
				trace(this + "onTouch(" + touch.phase + ")");
				
				if(touch.phase == TouchPhase.BEGAN)
				{
					
				}
 
				else if(touch.phase == TouchPhase.ENDED)
				{
					
				}
 
				else if(touch.phase == TouchPhase.MOVED)
				{
					
				}
			}
 
		}
		
		//------------------------------------o
		//-- Enter Frame - Main Game Loop
		//------------------------------------o
		private function update_gameLoop(e:Event):void 
		{
			if (_isGameInPlay)
			{
				//-----------------------------------------o
				// Global Starling Juggler
				//keep this 'coupled' for maximum execution speed
				//-----------------------------------------o
				_core.animationJuggler.advanceTime(.02);
			}
		}

		
		

		


		//-------------------------------------------------------------------------o
		//------ Getters and Setters 
		//-------------------------------------------------------------------------o		
		

		

		


		


		

			
		
		
	}
	
}