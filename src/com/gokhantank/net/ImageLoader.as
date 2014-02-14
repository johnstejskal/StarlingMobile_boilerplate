// ActionScript file
package com.gokhantank.net 
{
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.*;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.system.LoaderContext;
	
	
	public class ImageLoader extends Loader {
		
		public static var ON_LOADER_SUCCESS:String = "on_image_success";
		public static var ON_LOADER_ERROR:String = "on_image_error";
		
		private var successEvent:Event;		
		private var errorEvent:Event;
		
		public function ImageLoader() {
			contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
			contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpHandler);
			contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioHandler);
		}
		
		public override function load(request:URLRequest, context:LoaderContext = null):void {
			super.load(request);
		}
		
		private function httpHandler(event:HTTPStatusEvent):void {
			if(event.status == 404) {
				errorEvent = new Event(ON_LOADER_ERROR, true);			
				dispatchEvent(errorEvent);
			}
		}
		private function ioHandler(event:IOErrorEvent):void {
			errorEvent = new Event(ON_LOADER_ERROR, true);			
			dispatchEvent(errorEvent);
		}
		private function completeHandler(event:Event):void {
			successEvent = new Event(ON_LOADER_SUCCESS, true);			
			dispatchEvent(successEvent);
		}
	}
}