package data.constants 
{


	/**
	 * 
	 * @author John Stejskal
	 * "Why walk when you can ride"
	 * 
	 */
	
	public class AppFonts 
	{

		//========================================================o
		//---  Fonts list
		//========================================================o
		//**** MAKE SURE MIMETYPE IS SPECIFIED FOR OFT FONTS ******
		
		static public const FONT_ARIAL:String = "Arial";
		[Embed(source="../../../bin/lib/fonts/ARIAL.ttf", embedAsCFF="false", fontFamily="Arial")]
		public static const Arial:Class;
		
		//-------o
			
		static public const FONT_FUTURA_CONDENSED:String = "FuturaCondensed";
		[Embed(source="../../../bin/lib/fonts/FuturaStd-Condensed.otf", embedAsCFF="false", mimeType="application/x-font-opentype", fontFamily="FuturaCondensed")]
		public static const FuturaCondensed:Class;
			
		//-------o
	
		static public const FONT_FUTURA_NORMAL:String = "FuturaNormal";
		[Embed(source="../../../bin/lib/fonts/Futura.otf", embedAsCFF="false", mimeType="application/x-font-opentype", fontFamily="FuturaNormal")]
		public static const FuturaNormal:Class;
			
													 
		public function AppFonts()
		{
			

														

		}											

													

	}

}