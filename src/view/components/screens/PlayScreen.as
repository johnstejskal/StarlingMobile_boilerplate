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
	import flash.events.AccelerometerEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.sensors.Accelerometer;
	import flash.utils.Timer;
	import interfaces.iScreen;
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
	import singleton.EventBus;
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
	import staticData.settings.DeviceSettings;
	import staticData.settings.PublicSettings;
	import view.components.gameobjects.Player;

	import staticData.Data;
	import staticData.SpriteSheets;

	import view.components.ui.DevConsole;


	import starling.utils.deg2rad;
	import starling.utils.rad2deg;
	import ManagerClasses.StateMachine;


	import singleton.Core;

	import staticData.Constants;


	
	/**
	 * ...
	 * @author john stejskal
	 * "Why walk when you can ride"
	 */
	public class PlayScreen extends Sprite implements iScreen
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
		
		
		//Assets
		private var _oPlayer:Player;
		private var _accelerometer:Accelerometer;
		
		private var veloX:Number = 0;
        private var veloY:Number = 0;		

		//----------------------------------------o
		//------ Constructor
		//----------------------------------------o
		public function PlayScreen():void 
		{
			trace(this + " PlayScreen()");

			_core = Core.getInstance();
			_nativeStage = Starling.current.nativeStage;
			
			StateMachine._oPlayScreen = this;

		}
		
		//------------------------------------------------------------------------------o
		//------ Public API 
		//------------------------------------------------------------------------------o		
		public function init(levelToLoad:String = "level1"):void
		{
			trace("levelToLoad :" + levelToLoad)
			
			AssetsManager.loadTextureFromFile(SpriteSheets.TA_PATH_ACTION_ASSETS, SpriteSheets.SPRITE_ATLAS_ACTION_ASSETS,  this.loaded);
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

			_oPlayer = new Player();
			_oPlayer.x = Data.deviceResX/2
			_oPlayer.y = Data.deviceResY / 2
			
			
			_layerAction.addChild(_oPlayer);
			
			
			if (Accelerometer.isSupported && DeviceSettings.ENABLE_ACCELEROMETER)
			{
			_accelerometer = new Accelerometer();
			_accelerometer.setRequestedUpdateInterval(50);
			_accelerometer.addEventListener(AccelerometerEvent.UPDATE, onAccUpdate);
			}
			

			
			//fillObjectPool(DataVO["LEVEL_" + DataVO.currentGameLevel + "_WAVE_" + DataVO.currentWave]);
			
			//------------------------------------------o
			//--------  AddEventListeners --------------o
			//------------------------------------------o
			if(DeviceSettings.ENABLE_TOUCH)
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
				//trace(this + "onTouch(" + touch.phase + ")");
				
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
		//-- Accelerometer event
		//------------------------------------o
		private	function onAccUpdate(e:AccelerometerEvent):void
		{
			//trace(e.accelerationY)
			_oPlayer.x -= (e.accelerationX*20);
			//_oPlayer.y += (e.accelerationY * 10);
			
			
			if (_oPlayer.x < 0)
			_oPlayer.x = 0;
			if (_oPlayer.x > Data.deviceResX)
			_oPlayer.x = Data.deviceResX;
			


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

		
		

		//------------------------------------o
		//-- Trash/Dispose/Kill/Anihliate
		//------------------------------------o		
		public function trash():void
		{
		  this.removeEventListeners();
			
		}

		//-------------------------------------------------------------------------o
		//------ Getters and Setters 
		//-------------------------------------------------------------------------o		
		

		

		


		


		

			
		
		
	}
	
}