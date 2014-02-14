package vo 
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



													 


													

													

													

	}

}