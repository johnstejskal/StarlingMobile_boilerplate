package staticData 
{


	/**
	 * @author John Stejskal
	 * "Why walk when you can ride"
	 */
	
	public class AppFonts 
	{
	/*
	 * fonts list for use with the starling framework
	 */
	
	 
	 
	//------------------------------------------------------o
	//---  Fonts list
	//------------------------------------------------------o
	
	
	static public const FONT_ARIAL:String = "Arial";
	
	[Embed(source="../../bin/runtimeAssets/fonts/ARIAL.ttf", embedAsCFF="false", fontFamily="Arial")]
	public static const Arial:Class;
	
	//-------o
	
	static public const FONT_OSTRICH:String = "Ostrich";
	
	[Embed(source="../../bin/runtimeAssets/fonts/OSTRICH BOLD_0.ttf", embedAsCFF="false", fontFamily="Ostrich")]
	public static const OstrichBold:Class;
	
	
	static public const FONT_OSTRICH_BLACK:String = "OstrichBlack";
	
	[Embed(source="../../bin/runtimeAssets/fonts/OSTRICH BLACK_0.ttf", embedAsCFF="false", fontFamily="OstrichBlack")]
	public static const OstrichBlack:Class;
		

													 
		public function AppFonts()
		{
			

														

		}											

													

	}

}