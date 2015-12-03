package data.settings 
{
	import com.johnstejskal.Position;
	import data.constants.HexColours;
	import flash.ui.MultitouchInputMode;

	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	/**
	 * @author John Stejskal
	 * "Why walk when you can ride"
	 */
	
	 /*
	  * This is a public interface for global UI settings.
	  *
	  */
	 
	public class UISettings 
	{
		
		//generic background settings
		static public const BACKGROUND_TYPE:String = "fill";  //fill, image
		static public const BACKGROUND_FILL_COLOUR:uint = HexColours.GREY;
		
		
		//if back button is enabled, Menu should be on the right
		static public const ENABLE_BACK_BUTTON:Boolean = false;
		static public const ENABLE_TITLE_BAR:Boolean = true;
		static public const ENABLE_TITLE_BAR_LOGO:Boolean = false;
		static public const ENABLE_TITLE_HEADING:Boolean = true;
		
		static public const ENABLE_TITLE_BAR_TRANSPARENCY:Boolean = false;
		static public const ENABLE_TITLE_BAR_IMAGE:Boolean = false; //image overrides fill
		static public const TITLE_BAR_COLOUR:uint = HexColours.NAVY_BLUE;
		
		
		//Slide out menu Settings
		static public const ENABLE_SLIDE_MENU:Boolean = true;
		static public const SLIDE_MENU_POSITION:String = Position.RIGHT; //left or right
		static public const SLIDE_MENU_IN_SPEED:Number = .2;
		static public const SLIDE_MENU_OUT_SPEED:Number = .2;

		
	
	}

}