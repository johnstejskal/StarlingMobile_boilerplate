package staticData 
{


	/**
	 * @author John Stejskal
	 * "Why walk when you can ride"
	 */
	
	 
	 /*
	  * Store all the Sprite sheet referencing info here to be passed into the AssetManager
	  * 
	  */
	 
	public class SpriteSheets 
	{

		//Texture Atlas/ Sprite Sheet
		
		//-------------------------------------------o
		//-------------------------o Game Background 
		//-------------------------------------------o
		public static const SPRITE_ATLAS_GAME_BG:String = "textureAtlasGameBG";
		public static const TA_PATH_GAME_BG:String = "runtimeAssets/spriteSheets/SpriteSheet_gameBG.png"; //used for external loading
			
		[Embed(source = "../../bin/runtimeAssets/spriteSheets/SpriteSheet_gameBG.xml", mimeType="application/octet-stream")]
		public static var textureAtlasGameBGXML:Class; 



		//-------------------------------------------o
		//-------------------------o Action Assets
		//-------------------------------------------o
		public static const SPRITE_ATLAS_ACTION_ASSETS:String = "textureAtlasActionAssets";
		public static const TA_PATH_ACTION_ASSETS:String = "runtimeAssets/spriteSheets/SpriteSheet_actionAssets.png"; //used for external loading
			
		[Embed(source = "../../bin/runtimeAssets/spriteSheets/SpriteSheet_actionAssets.xml", mimeType="application/octet-stream")]
		public static var textureAtlasActionAssetsXML:Class; 												 


		//-------------------------------------------o
		//-------------------------o title screen
		//-------------------------------------------o
		public static const SPRITE_ATLAS_TITLE_SCREEN:String = "textureAtlasTitleScreen";
		public static const TA_PATH_TITLE_SCREEN:String = "runtimeAssets/spriteSheets/SpriteSheet_titleScreen.png"; //used for external loading
			
		[Embed(source = "../../bin/runtimeAssets/spriteSheets/SpriteSheet_titleScreen.xml", mimeType="application/octet-stream")]
		public static var textureAtlasTitleScreenXML:Class; 													

													

													

	}

}