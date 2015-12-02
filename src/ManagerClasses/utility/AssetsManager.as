package ManagerClasses.utility 
{
	import com.johnstejskal.StarlingUtil;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.utils.getDefinitionByName;
	import singleton.Core;
	import starling.core.Starling;
	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.ConcreteTexture;
	import starling.textures.Texture
	import starling.textures.TextureAtlas;
	//import view.components.screens.LoadingScreen;
	
	/**
	 * @author John Stejskal
	 * "Why walk when you can ride"
	 */
	
	public class AssetsManager
	{
		

			//Set the location of the class where the TA list is managed
			public static var SPRITE_SHEET_CLASS:Class;
			
			private static var _gametextures:Dictionary = new Dictionary();
			static private var loadQueCount:int = 0;
			
			public function AssetsManager() 
			{
				
			}

			//=========================================o
			//-- Retrieve the sprite sheet
			//=========================================o
			public static function getAtlas(textureAtlas:String):TextureAtlas
			{
				if (!SPRITE_SHEET_CLASS)
				throw new Error("Error: you have not set SPRITE_SHEET_CLASS")
				
				if (_gameTextureAtlas == null)
				{
					trace("textureAtlas:" + textureAtlas);
					var texture:Texture = getTexture(textureAtlas);
					var xml:XML = XML(new SPRITE_SHEET_CLASS[textureAtlas + "XML"]()) //var xml:XML = XML(new textureAtlasXML())
					var _gameTextureAtlas:TextureAtlas = new TextureAtlas(texture, xml)
					
				}
				return _gameTextureAtlas;
			}	
			
			//=========================================o
			//-- Retrieve a specific texture
			//=========================================o				
			public static function getTexture(name:String):Texture
			{
				trace(AssetsManager + " getTexture(" + name + ")");
				if (_gametextures[name] == undefined || _gametextures[name] == null)
				{
					var bitmap:Bitmap = new SPRITE_SHEET_CLASS[name]();
					_gametextures[name] = Texture.fromBitmap(bitmap,false);
				}
				return _gametextures[name];
			}
			
			//=========================================o
			//-- Dispose a texture (not whole atlast)
			//=========================================o
			public static function disposeTexture(name:String) : void
			{
				trace(AssetsManager + "disposeTexture(" + name + ")");
				if (_gametextures[name] == undefined || _gametextures[name] == null)
				{
					trace("Error: The Atlas you are attempting to dispose does not exist")
					return;
				}
				
				Dictionary(_gametextures)[name].dispose();
				delete _gametextures[name];
				_gametextures[name] = null;
				
			}		
			
			
			//=========================================o
			//-- load a sprtiesheet from file
			//=========================================o
			public static function loadTextureFromFile(path:String, name:String, callback:Function):void
			{
				loadQueCount++;
				//StarlingUtil.showLoadingScreen();
				
				trace("loadTextureFromFile path:" + path + " | name:" + name);
				
				var loader:Loader = new Loader();
				loader.load (new URLRequest(path));
				loader.contentLoaderInfo.addEventListener ( Event.COMPLETE, onComplete );

				function onComplete ( e : Event ):void
				{
					trace(AssetsManager+".onComplete(): "+ e.currentTarget.loader.content);
					var loadedBitmap:Bitmap = e.currentTarget.loader.content as Bitmap;

					if (_gametextures[name] == undefined || _gametextures[name] == null)
					{
						_gametextures[name] = Texture.fromBitmap(loadedBitmap, false);
						
					}
					
					loadQueCount --;
					//when all assets in file stream are loaded, remove the loading screen
					if (loadQueCount <= 0) {
					//StarlingUtil.removeLoadingScreen();
					callback();
					}
	
				}	
			}
			
			//=========================================o
			//-- dispose all textures
			//=========================================o
			public static function disposeAll():void
			{
				for (var key:* in _gametextures)
				{
				disposeTexture(key);
				delete _gametextures[key];
				key = null;
				}

				trace(AssetsManager+"disposeAll() All Textures have been disposed");
			}
			
			//=========================================o
			//--- count dictionary keys
			//=========================================o
			public static function countKeys(myDictionary:flash.utils.Dictionary):int 
			{
				var n:int = 0;
				for (var key:* in myDictionary) {
					n++;
				}
				return n;
			}
			
		
	}

}