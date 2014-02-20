package com.johnstejskal 
{
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.QuadBatch;
	import staticData.Data;
	import view.components.screens.LoadingScreen;
	
	
	/**
	 * @author John Stejskal
	 * "Why walk when you can ride"
	 */
	
	public class StarlingUtil 
	{
		static public const CENTER:String = "CENTER";
		static public const BOTTOM_LEFT:String = "BOTTOM_LEFT";
		static public const BOTTOM_RIGHT:String = "BOTTOM_RIGHT";
		static public const TOP_LEFT:String = "TOP_LEFT";
		static public const TOP_RIGHT:String = "TOP_RIGHT";
		
		static private var loadingScreen:LoadingScreen;
		//static private var isLoadingActive:Boolean = false;
		
		public function StarlingUtil() 
		{
			
		}
		
		public static function getBoxWithBorder( ww:int, hh:int, plainColor:int = 0xFFFFFF, borderColor:int = 0x000000, borderThickness:int = 1):QuadBatch {
			// create batch
			var result : QuadBatch = new QuadBatch();
 
			// create plain color
			var center : Quad = new Quad(ww, hh, plainColor);
 
			// create borders
			var left : Quad = new Quad(borderThickness, hh, borderColor);
			var right : Quad = new Quad(borderThickness, hh, borderColor);
 
			var top : Quad = new Quad(ww, borderThickness, borderColor);
			var down : Quad = new Quad(ww, borderThickness, borderColor);
 
			// placing elements (top and left already placed)
			right.x = ww - borderThickness;
			down.y = hh - borderThickness;
 
			// build box
			result.addQuad(center);
			result.addQuad(left);
			result.addQuad(top);
			result.addQuad(right);
			result.addQuad(down);	
 
			return result;
		}		
		
		static public function showLoadingScreen():void 
		{
			if (loadingScreen)
			return;
			
			loadingScreen = new LoadingScreen();
			Starling.current.nativeOverlay.addChild(loadingScreen);
		}
		
		static public function removeLoadingScreen():void 
		{
			trace("loadingScreen.parent:" + loadingScreen.parent);
			if (loadingScreen.parent)
			loadingScreen.parent.removeChild(loadingScreen);
			//Starling.current.nativeOverlay.removeChild(loadingScreen);
		}
		
		static public function centerRegPoint(obj:*):void 
		{
			obj.x -= obj.width / 2;
			obj.y -= obj.height / 2;
		}
		
		//--------------------------------------------o
		// Changes the registration point of a starling object
		// Modifies original object
		//--------------------------------------------o
		static public function setRegPoint(obj:Quad, pos:String = CENTER):void 
		{
			switch(pos)
			{
				case CENTER:
				obj.pivotX = obj.width / 2;
				obj.pivotY = obj.height / 2;
				break;
				
				case TOP_LEFT:
				obj.pivotX = 0;
				obj.pivotY = 0;
				break;	
				
				case TOP_RIGHT:
				obj.pivotX = obj.width;
				obj.pivotY = 0;
				break;	
				
				case BOTTOM_LEFT:
				obj.pivotX = 0;
				obj.pivotY = obj.height;
				break;	
				
				case BOTTOM_RIGHT:
				obj.pivotX = obj.width;
				obj.pivotY = obj.height;
				break;	
				
			}
		}
		
		//--------------------------------------------o
		// Changes an objects screen pos to on of sever preset positions
		// Modifies original object
		// does NOT change pivotX/ pivotY
		//--------------------------------------------o
		static public function setScreenPos(obj:Quad, pos:String = CENTER):void 
		{
			switch(pos)
			{
				case CENTER:
				obj.x = Data.deviceResX / 2;
				obj.y = Data.deviceResY / 2;
				break;
				
				case TOP_LEFT:
				obj.x = 0;
				obj.y = 0;
				break;	
				
				case TOP_RIGHT:
				obj.x = Data.deviceResX;
				obj.y = 0;
				break;	
				
				case BOTTOM_LEFT:
				obj.x = 0;
				obj.y = Data.deviceResY;
				break;	
				
				case BOTTOM_RIGHT:
				obj.x = Data.deviceResX;
				obj.y = Data.deviceResY;
				break;	
				
			}
		}
		//--------------------------------------------o
		// Changes the scale of an object,
		// used for matching device scale ratios
		// pass in Data.deviceScaleX/Y
		// Modifies original object
		//--------------------------------------------o		
		static public function setScale(obj:Quad, scale:Number):void 
		{
			obj.scaleX = obj.scaleY = scale
		}
		
	}

}