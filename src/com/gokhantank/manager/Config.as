package com.gokhantank.manager
{
	import com.gokhantank.net.NetLoader;
	import com.gokhantank.util.Utils;
	import flash.net.SharedObject;
	import flash.net.URLLoader;
	import org.flashdevelop.utils.FlashConnect;
	import vo.CharVo;
	import vo.ConfigVo;
	import vo.DataVo;
	import vo.WineVo;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	
	public class Config extends EventDispatcher
	{
		public static var ON_LOADED:String = "onConfigLoaded";
		
		/* Uygulamanin versiyon numarasi */
		public static var APP_VERSION:String;
		/* Uygulamanin versiyon numarasi */
		public static var DEBUG:Boolean;
		/* Sunucunun adresi */
		public static var SERVER_PATH:String;
		//TEMP VARIABLES
		public static var USER_ID:int;
		public static var USER_NAME:String;
		public static var USER_EMAIL:String;

		private var netLoader:NetLoader;
		private var onLoadEvent:Event;
		
		public function Config()
		{
			var urlRequest:URLRequest = new URLRequest("resources/config.xml");
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, onConfigLoaded);
			urlLoader.load(urlRequest);
		}
		
		private function onConfigLoaded(e:Event):void {
			trace(this+".onConfigLoaded");
			var xml:XML = new XML(e.target.data);
			trace("xml.xmls_path: "+xml.xmls_path);
			ConfigVo.xmlsPath = xml.xmls_path;
			ConfigVo.bottlesPath = xml.bottles_path;
			loadWines();
		}
		private function loadWines():void {
			trace(this+".loadWines");
			var urlRequest:URLRequest = new URLRequest(ConfigVo.xmlsPath+ConfigVo.language+"/wines.xml");
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, onLoadWines);
			urlLoader.load(urlRequest);
		}
		private function onLoadWines(e:Event):void {
			trace(this+".onLoadWines");
			var xml:XML = new XML(e.target.data);
			xml.ignoreWhitespace = true;
			
			DataVo.winesObject = new Object();
			DataVo.winesArray = new Array();
			
			for (var i:int; i < xml.wine.length(); i++) {
				var wineVo:WineVo = new WineVo();
				wineVo.id = xml.wine[i].@id;
				wineVo.name = xml.wine[i].@name;
				wineVo.deepLink = xml.wine[i].@deepLink;
				wineVo.description = xml.wine[i].description;
				wineVo.colour = xml.wine[i].colour;
				wineVo.bottle = xml.wine[i].bottle;
				wineVo.region = xml.wine[i].region;
				wineVo.variety = xml.wine[i].variety;
				wineVo.bitly = xml.wine[i].bitly;
				wineVo.chars = String(xml.wine[i].chars).toUpperCase().split(",");
				wineVo.nonchars = String(xml.wine[i].nonchars).toUpperCase().split(",");
				DataVo.winesObject[wineVo.id] = wineVo;
				DataVo.winesArray.push(wineVo);
			}
			getSharedObject();
			loadChars();
		}
		private function getSharedObject():void {
			DataVo.sharedObject = SharedObject.getLocal("AWBC");
				for (var key:String in DataVo.sharedObject.data) {
					for (var i:Number = 0; i<DataVo.winesArray.length; i++) {
						if (DataVo.winesArray[i].id == key) {
							if (isNaN(DataVo.sharedObject.data[key]) == false) {
								WineVo(DataVo.winesObject[DataVo.winesArray[i].id]).score = DataVo.sharedObject.data[key];
							}
						}
					}
				}
		}

		private function loadChars():void {
			trace(this+".loadChars");
			var urlRequest:URLRequest = new URLRequest(ConfigVo.xmlsPath+"chars.xml");
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, onLoadChars);
			urlLoader.load(urlRequest);
		}
		private function onLoadChars(e:Event):void {
			trace(this+".onLoadChars");
			var xml:XML = new XML(e.target.data);
			xml.ignoreWhitespace = true;
			
			DataVo.charsObject = new Object();
			
			for (var i:int; i < xml.chars.length(); i++) {
				var charVo:CharVo = new CharVo();
				charVo.id = xml.chars[i].id;
				var char:String = String(xml.chars[i].char).toUpperCase();
				charVo.char = char;
				charVo.fgcol = xml.chars[i].fgcol;
				charVo.bgcol = xml.chars[i].bgcol;
				DataVo.charsObject[charVo.char] =charVo;
			}
			loadRegions();
		}
		private function loadRegions():void {
			//resources/xmls/en/data_regions.xml
			var urlRequest:URLRequest = new URLRequest(ConfigVo.xmlsPath+ConfigVo.language+"/data_regions.xml");
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, onLoadRegions);
			urlLoader.load(urlRequest);
		}
		
		private function onLoadRegions(e:Event):void 
		{
			var xml:XML = new XML(e.target.data);
			xml.ignoreWhitespace = true;
			
			DataVo.regionsArray = new Array();
			
			for (var i:int; i < xml.region.length(); i++) {
				var obj:Object = {
					id:xml.region[i].id,
					state:xml.region[i].state,
					region_title:xml.region[i].region_title,
					desc:xml.region[i].desc,
					url_moreinfo:xml.region[i].url_moreinfo,
					bottle1:xml.region[i].bottle1,
					bottle2:xml.region[i].bottle2,
					url_podCast:xml.region[i].url_podCast,
					url_photo:xml.region[i].url_photo
				}
				DataVo.regionsArray.push(obj);
			}
			//onLoadEvent = new Event(ON_LOADED, true);
			//dispatchEvent(onLoadEvent);
			loadStates();
		}
		
		//
		
		private function loadStates():void {
		//resources/xmls/en/data_regions.xml
		var urlRequest:URLRequest = new URLRequest(ConfigVo.xmlsPath+ConfigVo.language+"/data_states.xml");
		var urlLoader:URLLoader = new URLLoader();
		urlLoader.addEventListener(Event.COMPLETE, onLoadStates);
		urlLoader.load(urlRequest);
		}
		
		private function onLoadStates(e:Event):void 
		{
			var xml:XML = new XML(e.target.data);
			xml.ignoreWhitespace = true;
			
			DataVo.statesArray = new Array();
			
			for (var i:int; i < xml.state.length(); i++) {
				var obj:Object = {
					id:xml.state[i].id,
					state:xml.state[i].state,
					region_title:xml.state[i].region_title,
					desc:xml.state[i].desc,
					url_moreinfo:xml.state[i].url_moreinfo,
					url_photo:xml.state[i].url_photo
				}
				DataVo.statesArray.push(obj);
			}
			loadScoreTexts();
		}
		
		private function loadScoreTexts():void {
			var urlRequest:URLRequest = new URLRequest(ConfigVo.xmlsPath+ConfigVo.language+"/scoreTexts.xml");
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, onLoadScoreTexts);
			urlLoader.load(urlRequest);
		}
		
		private function onLoadScoreTexts(e:Event):void 
		{
			var xml:XML = new XML(e.target.data);
			xml.ignoreWhitespace = true;
			
			DataVo.scoreTextsArray = new Array();
			
			for (var i:int; i < xml.score.length(); i++) {
				var obj:Object = {
					score:xml.score[i].score,
					title:xml.score[i].title,
					text:xml.score[i].text
				}
				DataVo.scoreTextsArray.push(obj);
			
			}
			onLoadEvent = new Event(ON_LOADED, true);
			dispatchEvent(onLoadEvent);
		}
			
	}
}