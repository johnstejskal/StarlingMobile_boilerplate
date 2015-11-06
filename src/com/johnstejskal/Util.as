package com.johnstejskal 
{
	import air.net.URLMonitor;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.StatusEvent;
	import flash.net.navigateToURL;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author John Stejskal
	 */
	public class Util 
	{
		
		public function Util() 
		{
			
		}
		
		public static function openNativeHTML(url:String, w:int, h:int):void
		{
		    /*var window:NativeWindow = Utils.createWindow(w,h);
            window.x = 0;
            window.y = 0;
            var html:HTMLLoader = new HTMLLoader();
            var urlReq:URLRequest = new URLRequest(url);
            //html.width = 800;
            //html.height = 600;
            html.load(urlReq); 
            window.stage.addChild(html);*/
		}
		
		static public function openURL(url:String):void 
		{
			var myURL:URLRequest = new URLRequest(url);
			navigateToURL(myURL, "_blank");
		}
		
		//========================================o
		//-- Check for internet Connection
		//========================================o
 		static public function checkForInternerConnection(callbackTrue:Function, callbackFalse:Function):void 
		{
			var value:Boolean;
			var testURL:String = "http://www.google.com";
			var testRequest:URLRequest = new URLRequest(testURL);
			var urlCheck:URLMonitor = new URLMonitor(testRequest);
			urlCheck.addEventListener(StatusEvent.STATUS, statusChanged);
			urlCheck.start();

			// This function is called when internet connection status has changed

			function statusChanged(event:StatusEvent):void
			{
				trace("my status is: "+urlCheck.available);
				if (urlCheck.available)
				{
				  trace("You have an internet connection, all is good");
				  value =  true;
				  callbackTrue();
				}
				else 
				{
				 trace("No connection detected");
				 value = false;
				 callbackFalse()
				}
			}
			
		}
		
		//===========================================o	
		//------ Load The Json Data from url
		//===========================================o	
		public static function loadFile(url:String, onSuccess:Function, onFail:Function):void
		{
			trace(Util + "loadFile()");
			
			var urlRequest:URLRequest  = new URLRequest(url);
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(flash.events.Event.COMPLETE, onSuccess);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onFail);

			try{
				urlLoader.load(urlRequest);
			} catch (error:Error) {

			}
			
		}
		



		
		
		
		//========================================o
		//-- load External XML
		//========================================o
/*		private function loadExternalURL(url:String, callback:Function):void 
		{

			var myXML:XML;
			var myLoader:URLLoader = new URLLoader();
			myLoader.load(new URLRequest(url));
			myLoader.addEventListener(Event.COMPLETE, callback);
			
			function processXML(e:Event):void 
			{
			trace("XML LOADED");
			myXML = new XML(e.target.data);
			}
		
		}*/


		
	}

}