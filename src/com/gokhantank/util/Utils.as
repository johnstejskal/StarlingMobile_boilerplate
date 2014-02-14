package com.gokhantank.util 
{
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	/**
	$(CBI)* ...
	$(CBI)* @author Gokhan Tank
	$(CBI)*/
	public class Utils
	{
		
		/* Gonderilen katari XML e cevirir */
		public static function convertXML(value:String):XML {
			var xml:XML = new XML(value);
			xml.ignoreWhitespace = true;
			return xml;
		}
		/* Gonderilen katari boolean a cevirir */
		public static function convertBoolean(value:String):Boolean {
			return value=="true"?true:false;
		}
		
		/* Gonderilen katari unsigned integer a cevirir */
		public static function convertUint(value:String):uint {
			return uint(value);
		}
		
		/* Gonderilen katari integer a cevirir */
		public static function convertInt(value:String):uint {
			return int(value);
		}
		
		//Gonderilen objenin bos olup olmadigina bakar
		public static function isEmptyString(value:Object):Boolean {
			if(value != null && (value is String) && (value as String).length > 0) {
				return false;
			} else {
				return true;
			}
		}
		public static function navigateURL(url:String):void {
			
			var request:URLRequest = new URLRequest(url);
            try {            
            	navigateToURL(request);
                //navigateToURL(request, "_blank");
            }
            catch (e:Error) {
            	var x:String = e.message;
				trace("error: " + x);
                // handle error here
            }
            
            /*
            var window:NativeWindow = Utils.createWindow(800,600);
            window.x = 0;
            window.y = 0;
            var html:HTMLLoader = new HTMLLoader();
            var urlReq:URLRequest = new URLRequest("http://www.adobe.com/");
            //html.width = 800;
            //html.height = 600;
            html.load(urlReq); 
            window.stage.addChild(html);
            */

		}
		
		
	}

}