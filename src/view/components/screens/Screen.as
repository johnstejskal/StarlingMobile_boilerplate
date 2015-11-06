package view.components.screens
{
	import com.greensock.easing.Elastic;
	import com.greensock.TweenLite;
	import com.johnstejskal.TrueTouch;
	import com.LaunchPadUtil;
	import com.thirdsense.animation.BTween;
	import com.thirdsense.animation.SpriteSequence;
	import com.thirdsense.animation.SpriteSheetHelper;
	import com.thirdsense.animation.TexturePack;
	import com.thirdsense.LaunchPad;
	import com.thirdsense.settings.Profiles;
	import com.thirdsense.utils.NativeApplicationUtils;
	import com.thirdsense.utils.Trig;
	import data.AppData;
	import data.constants.HexColours;
	import data.constants.LaunchPadLibrary;
	import data.settings.PublicSettings;
	import flash.system.Capabilities;
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.getQualifiedClassName;
	import interfaces.iScreen;
	import ManagerClasses.StateMachine;
	import singleton.Core;
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import flash.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import data.settings.PublicSettings;

	//===============================================o
	/**

	 */
	//===============================================o
	public class Screen extends Sprite implements iScreen
	{
		public var btnArray:Array;
		public var statArray:Array;
		public var manualRemoveDim:Boolean = false;
		public var requiresAssetLoad:Boolean = false;
		public var valueObject:*;
		
		protected var _core:Core = Core.getInstance();
		protected var _tt:TrueTouch;

		private var _quBGFill:Quad;
		private var _bgHexColour:uint = HexColours.BLACK;
		private var _img:Image;
		private var _mc:*;

		//===============================================o
		//------ Constructor 
		//===============================================o
		public function Screen():void 
		{
			
			// No addedToStage Events are used here as there is a loading sequence 
			// Init is called after the loaded method executes
		}
		
		//===============================================o
		//------ Assets loaded callback 
		//===============================================o
		public function loaded():void 
		{
			init();
		}
		

		
		//===============================================o
		//------ init 
		//===============================================o		
		public function init():void 
		{
			trace("dd");
			//core.controlBus.appUIController.removeLoadingScreen();
			
		}
		
		//===============================================o
		//
		//===============================================o
		public function initComplete():void 
		{
			//this is used to handle optionally handle the
			// delays that are created with intensive GPU load
			// based on large object creation ie objectPool polulation

			//_core.controlBus.controller_appUI.removeFillOverlay();
		}

		//===============================================o
		//------ dispose/kill/terminate/
		//===============================================o	
		public function trash():void
		{

		}
		
		//===============================================o
		//------ animate In
		//===============================================o	
		public function animateIn(onComplete:Function = null):void
		{
			if ( onComplete != null )
			{
				BTween.callOnNextFrame( onComplete );
			}
		}	
				
		//===============================================o
		//------ animate Out
		//===============================================o	
		public function animateOut(onComplete:Function = null):void
		{
			if ( onComplete != null )
			{
				BTween.callOnNextFrame( onComplete );
			}
		}	
				
		//===============================================o
		//------ activate
		//===============================================o	
		public function activate():void
		{
			this.touchable = true;
		}	
		
		//===============================================o
		//------ de-activate
		//===============================================o	
		public function deactivate():void
		{
			//trace(this + "deactivate()");

			this.touchable = false;
			
		}
		
		//===============================================o
		//--- set a screen BG colour
		//===============================================o
		public function setBG(hexColour:uint):void 
		{
			if (_quBGFill)
			return;
			
			_quBGFill = new Quad(AppData.deviceResX, AppData.deviceResY, hexColour);
			this.addChild(_quBGFill);
		}
		
		//===============================================o
		//--- set bg size
		// used for updating post init for clipped screens
		//===============================================o		
		public function setBGSize(w:int, h:Number):void 
		{
			if (!_quBGFill)
			return;
			
			_quBGFill.width = w;
			_quBGFill.height = h;
		}
		
		//===============================================o
		//
		//===============================================o
		public function get bgHexColour():uint 
		{
			return _bgHexColour;
		}
		
		//===============================================o
		//
		//===============================================o
		public function set bgHexColour(value:uint):void 
		{
			_bgHexColour = value;
		}
		

	}
	
}