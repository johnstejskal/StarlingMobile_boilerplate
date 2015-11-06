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
		[Embed(source="../../bin/lib/fonts/ARIAL.ttf", embedAsCFF="false", fontFamily="Arial")]
		public static const Arial:Class;
		
		//-------o
		
		static public const AVERIN_OBLIQUE:String = "AverinOblique";
		[Embed(source="../../bin/lib/fonts/AvenirLTStd-MediumOblique.ttf", embedAsCFF="false", fontFamily="AverinOblique")]
		public static const AverinOblique:Class;
		
		//-------o
		
		static public const FONT_OSTRICH:String = "Ostrich";
		[Embed(source="../../bin/lib/fonts/OSTRICH BOLD_0.ttf", embedAsCFF="false", fontFamily="Ostrich")]
		public static const OstrichBold:Class;
		
		//-------o
		
		static public const FONT_OSTRICH_BLACK:String = "OstrichBlack";
		[Embed(source="../../bin/lib/fonts/OSTRICH BLACK_0.ttf", embedAsCFF="false", fontFamily="OstrichBlack")]
		public static const OstrichBlack:Class;
		
		//-------o
		
		static public const FONT_FUTURA_CONDENSED:String = "FuturaCondensed";
		[Embed(source="../../bin/lib/fonts/FuturaStd-Condensed.otf", embedAsCFF="false", mimeType="application/x-font-opentype", fontFamily="FuturaCondensed")]
		public static const FuturaCondensed:Class;
			
		//-------o
	
		static public const FONT_FUTURA_NORMAL:String = "FuturaNormal";
		[Embed(source="../../bin/lib/fonts/Futura.otf", embedAsCFF="false", mimeType="application/x-font-opentype", fontFamily="FuturaNormal")]
		public static const FuturaNormal:Class;
			
													 
		public function AppFonts()
		{
			

														

		}											

													

	}

}