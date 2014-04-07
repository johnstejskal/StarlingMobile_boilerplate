package view.components.screens
{

	import com.greensock.TweenLite;
	import flash.display.MovieClip;
	import interfaces.iScreen;
	import singleton.Core;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	import staticData.AppFonts;
	import staticData.Constants;
	import staticData.Data;
	import staticData.HexColours;
	import staticData.settings.PublicSettings;



	
	/**
	 * @author John Stejskal
	 * "Why walk when you can ride"
	 */
	
	public class Screen extends Sprite implements iScreen
	{
		public var core:Core = Core.getInstance();

		private var _quBGFill:Quad;
		private var _bgHexColour:uint = HexColours.NAVY_BLUE;
		
		public var manualRemoveDim:Boolean = false;


		//----------------------------------------o
		//------ Constructor 
		//----------------------------------------o
		public function Screen():void 
		{
			
			// No addedToStage Events are used here as there is a loading sequence 
			// Init is called after the loaded method executes
		}
		
		//-----------------------------------------------------------------------o
		//------ Assets loaded callback 
		//-----------------------------------------------------------------------o
		public function loaded():void 
		{
			init()
			
			
			
		}
		
		//----------------------------------------------------------------------o
		//------ init 
		//----------------------------------------------------------------------o		
		public function init():void 
		{
			//core.controlBus.appUIController.removeLoadingScreen();
			
		}
		
		public function initComplete():void 
		{
			//this is used to handle optionally handle the
			// delays that are created with intensive GPU load
			// based on large object creation ie objectPool polulation

			
			core.controlBus.controller_appUI.removeFillOverlay();
		}

		//----------------------------------------o
		//------ dispose/kill/terminate/
		//----------------------------------------o	
		public function trash():void
		{

		}
		
		//----------------------------------------o
		//------ activate
		//----------------------------------------o	
		public function activate():void
		{
			
		}	
		
		//----------------------------------------o
		//------ de-activate
		//----------------------------------------o	
		public function deactivate():void
		{
			trace(this + "deactivate()");

			this.touchable = false;
		}
		
		//========================================o
		//--- set a screen BG colour
		//========================================o
		public function setBG(hexColour:uint):void 
		{
			if (_quBGFill)
			return;
			
			_quBGFill = new Quad(Data.deviceResX, Data.deviceResY, hexColour);
			this.addChild(_quBGFill);
		}
		
		//========================================o
		//--- set bg size
		// used for updating post init for clipped screens
		//========================================o		
		public function setBGSize(w:int, h:Number):void 
		{
			if (!_quBGFill)
			return;
			
			_quBGFill.width = w;
			_quBGFill.height = h;
		}
		
		
		public function get bgHexColour():uint 
		{
			return _bgHexColour;
		}
		
		public function set bgHexColour(value:uint):void 
		{
			_bgHexColour = value;
		}
		
		
	}
	
}