package view.components.screens
{



	import com.greensock.TweenLite;
	import com.johnstejskal.ArrayUtil;
	import com.johnstejskal.Delegate;
	import com.johnstejskal.Maths;

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
	import view.components.TileGrid;
	import view.components.ui.nativeDisplay.DebugPanel;

	import staticData.Data;
	import staticData.SpriteSheets;

	import starling.utils.deg2rad;
	import starling.utils.rad2deg;
	import ManagerClasses.StateMachine;


	import singleton.Core;

	import staticData.Constants;


	//=========================================o
	/**
	 * @author john stejskal
	 * "Why walk when you can ride"
	 */
	//=========================================o
	
	public class PlayScreen extends Screen implements iScreen
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

		//=========================================o
		//------ Constructor
		//=========================================o
		public function PlayScreen():void 
		{
			trace(this + " PlayScreen()");

			_core = Core.getInstance();
			_nativeStage = Starling.current.nativeStage;

		}
		
		//=========================================o
		//------ Init
		//=========================================o
		public override function init():void
		{
			

		}
		
		//=========================================o
		//------ AssetLoad Callback
		//=========================================o
		public override function loaded():void
		{
			trace(this + "loaded()");
			createWorld();
		}
		

		//=========================================o
		//-- Setup and position all the components
		//=========================================o
		private function createWorld():void 
		{
			trace(this + "createLevel()");	
			this.alpha = 0.99;
			
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
			
			
			
			/* 
			 * optional Tile Based grid
			 */
/*			var tileGrid:TileGrid = new TileGrid();
			tileGrid.generateGrid(0, 0, 80, 80, TileGrid.LEVEL_MAP)
			this.addChild(tileGrid);*/
			
			//------------------------------------------o
			//--------  AddEventListeners --------------o
			//------------------------------------------o
			if(DeviceSettings.ENABLE_TOUCH)
			this.addEventListener(TouchEvent.TOUCH, onTouch)
			
			startGameplay();
			
		}	
		
		//=========================================o
		//-- Start Game Play
		//=========================================o
		private function startGameplay():void 
		{
			trace(this + " startGameplay()");
			_isGameInPlay = true; 
			this.addEventListener(Event.ENTER_FRAME, update_gameLoop);
			
		}
		

		//=========================================o
		//-- Screen Touch events
		//=========================================o
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
		
			
		//=========================================o
		//-- Enter Frame - Main Game Loop
		//=========================================o
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


		//=========================================o
		//-- Trash/Dispose/Kill/Anihliate
		//=========================================o	
		public override function trash():void
		{
		trace(this + "trash()");
		  this.removeEventListeners();
		  this.removeFromParent();
			
		}

		//=========================================o
		//------ Getters and Setters 
		//=========================================o		
		

		

		


		


		

			
		
		
	}
	
}