// ActionScript file
package com.gokhantank.net
{
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.*;
	
	
	public class NetLoader extends URLLoader {	
			
		public static var ON_LOADER_SUCCESS:String = "on_loader_success";
		public static var ON_LOADER_ERROR:String = "on_loader_error";
		
		private var successEvent:Event;		
		private var errorEvent:Event;
		
		public function NetLoader() {		
			addEventListener(Event.COMPLETE, completeHandler);
			addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
            addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
            addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		}
		
		
		public override function load(request:URLRequest):void {			
			super.load(request);
		}
		
		public override function close():void {
			removeEventListener(Event.COMPLETE, completeHandler);
			removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
            removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
            removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		}
		
		private function completeHandler(event:Event):void { 
			successEvent = new Event(ON_LOADER_SUCCESS, true);			
			dispatchEvent(successEvent);
		}
		
		private function securityErrorHandler(event:SecurityErrorEvent):void {
            errorEvent = new Event(ON_LOADER_ERROR, true);	
			dispatchEvent(errorEvent);
        }

        private function httpStatusHandler(event:HTTPStatusEvent):void {
			if(event.status == 404) {
				errorEvent = new Event(ON_LOADER_ERROR, true);			
				dispatchEvent(errorEvent);
			}            
        }

        private function ioErrorHandler(event:IOErrorEvent):void {
            errorEvent = new Event(ON_LOADER_ERROR, true);			
			dispatchEvent(errorEvent);
        }
	}
}