package com.gokhantank.manager
{
	
	import com.gokhantank.net.NetLoader;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	
	
	public class Language extends EventDispatcher
	{
		
		public static var ON_LOADED:String = "onLanguageLoaded";
		
		public static var _suffix:String;
		private var netLoader:NetLoader;
		private static var dataProvider:Object;
		
		private var onLoadEvent:Event;
		
		public function	Language(suffix:String) {
			//_suffix = "tr";
			_suffix = suffix;
			netLoader = new NetLoader();
			netLoader.addEventListener(NetLoader.ON_LOADER_SUCCESS, xmlLoaded);
			var url:String = "resources/languages/" + _suffix + ".xml";
			var request:URLRequest = new URLRequest(url);
			netLoader.load(request);
		}
		
		public static function getLanguage(name:String):String {
			return dataProvider[name];
		}
		
		private function xmlLoaded(evtObj:Event):void { 
			try {				
				dataProvider = new Object();
				var langXML:XML = XML(netLoader.data);
				//App.out("Language xml: " + langXML.toXMLString());
				//for each (var item:XML in langXML..i) {
					//var name:String = item.@name;
					//var value:String = item.toString();
					//dataProvider[name] = value;
				
			} catch (error:Error) {
			
			}
			
			onLoadEvent = new Event(ON_LOADED, true);
			dispatchEvent(onLoadEvent);
		}
		
		
	}
	
}