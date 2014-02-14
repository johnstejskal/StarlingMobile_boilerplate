package com.johnstejskal 
{
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.display.QuadBatch;
	import view.components.screens.LoadingScreen;
	
	
	/**
	 * @author John Stejskal
	 * "Why walk when you can ride"
	 */
	
	public class StarlingUtil 
	{
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
		
	}

}