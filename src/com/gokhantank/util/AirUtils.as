package com.gokhantank.util
{
	
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindowSystemChrome;
	import flash.display.NativeWindowType;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import mx.core.Window;
	
	public class AirUtils
	{
											
		public static var alwaysInFront:Boolean = false;
		
		public static var seperator:String = "#";
		
		public static var delimeter:String = "/";
		public static function findArrayIndex(arr:Array, data:Object):Number {
			var len:Number = arr.length;
			for(var i:Number = 0; i<len; i++) {
				if(arr[i] == data) {
				return i;
				}
			}
			return -1;
		}
		
		
		public static function createWindowless(width:int, height:int, type:String = null):NativeWindow {
		    //create the init options
		    var options:NativeWindowInitOptions = new NativeWindowInitOptions();
		    options.transparent = true;
		    options.systemChrome = NativeWindowSystemChrome.NONE;
		    if(type != null) {
		    	options.type = type;
		    } else {
		    	options.type = NativeWindowType.LIGHTWEIGHT;
		    }
		    
		    //create the window
		    var newWindow:NativeWindow = new NativeWindow( options);
		    newWindow.x = -500;
		    newWindow.y = -500;
		    newWindow.width = width;
		    newWindow.height = height;
		    newWindow.alwaysInFront = alwaysInFront;
		    
		    newWindow.stage.align = StageAlign.TOP_LEFT;
		    newWindow.stage.scaleMode = StageScaleMode.NO_SCALE;
		    
		    newWindow.activate();
		    
		    return newWindow;
		    
		}
		
		public static function createWindow(width:int, height:int):NativeWindow {
		    //create the init options
		    var options:NativeWindowInitOptions = new NativeWindowInitOptions();
		    options.transparent = false;
		    options.systemChrome = NativeWindowSystemChrome.STANDARD;
		    options.type = NativeWindowType.NORMAL;
		    
		    //create the window
		    var newWindow:NativeWindow = new NativeWindow(options);
		    newWindow.x = -500;
		    newWindow.y = -500;
		    newWindow.width = width;
		    newWindow.height = height;
		    newWindow.alwaysInFront = alwaysInFront;
		    
		    newWindow.stage.align = StageAlign.TOP_LEFT;
		    newWindow.stage.scaleMode = StageScaleMode.NO_SCALE;
		    
		    newWindow.activate();
		    
		    return newWindow;
		    
		}
		
		
		public static function createNormalWindowless(width:int, height:int):Window {
		    //create the window
		    var newWindow:Window = new Window();
		    newWindow.width = width;
		    newWindow.height = height;
		    newWindow.transparent = true;
			newWindow.systemChrome = NativeWindowSystemChrome.NONE;
			newWindow.type = NativeWindowType.LIGHTWEIGHT;
			newWindow.layout = "absolute";
			newWindow.showStatusBar = false;
			newWindow.showTitleBar = false;
			newWindow.resizable = false;
			newWindow.showGripper = false;
			newWindow.setStyle("backgroundAlpha", 0);
			newWindow.setStyle("borderThickness", 0);
		    newWindow.open(true);
		    newWindow.alwaysInFront = alwaysInFront;
		    return newWindow;
		    
		}
		
		
		
		
		
		
	}
}