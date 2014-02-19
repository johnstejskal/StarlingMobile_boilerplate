package com.gokhantank.manager
{
	
	import com.gokhantank.net.NetLoader;
	import staticData.ConfigVo;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
		
	public class Manager extends EventDispatcher
	{
		
		public static var ON_LOADED:String = "onInitManagerLoaded"
		public static var ON_LOAD_ERROR:String = "onInitManagerLoadError"
		
		private var config:Config;
		private var language:Language;
		private var database:Database;
		
		private var onLoadEvent:Event;
		
		private var netLoader:NetLoader;
	
		public function Manager()
		{
			//database = new Database();
			
			language = new Language("en");
			ConfigVo.language = "en";
			language.addEventListener(Language.ON_LOADED, onLanguageLoaded);
			
			
			
			/*netLoader = new NetLoader();
			netLoader.addEventListener(NetLoader.ON_LOADER_SUCCESS, onNetSuccess);
			netLoader.addEventListener(NetLoader.ON_LOADER_ERROR, onNetError);
			var url:String = "http://www3.smartadserver.com/track/pix.asp?51634;6665;" + Math.round(Math.random()*100000000);
			netLoader.load(new URLRequest(url));*/
			
			//MediaServer.self.addEventListener(MediaServer.SERVICE_CONNECTED, onConnected);
			//MediaServer.self.addEventListener(MediaServer.SERVICE_FAILED, onFailed);
			//MediaServer.self.connect();
		}
		
		private function onConfigLoaded(evtObj:Event):void {
			onLoadEvent = new Event(ON_LOADED, true);
			dispatchEvent(onLoadEvent);
		}
		
		private function onConnected(e:Event=null):void
		{
			trace(this + ".onConnected");
		}
		private function onFailed(e:Event=null):void
		{
			trace(this + ".onFailed");
			dispatchEvent(new Event(ON_LOAD_ERROR,true));
		}
	
		private function onLanguageLoaded(evtObj:Event):void { 
			config = new Config();
			config.addEventListener(Config.ON_LOADED, onConfigLoaded);
			
			
		}

	}
}