package staticData.settings 
{

	import flash.display.MovieClip;

	/**
	 * @author John Stejskal
	 * "Why walk when you can ride"
	 */
	
	 
	 /*
	  * This is a public interface for global app settings.
	  * for game specific constants like level maps, go to Constants.as 
	  */
	 
	public class PublicSettings 
	{

	static public const DEVICE_RELEASE:Boolean = false;
	static public const ANALYTICS:Boolean = false;
	
	static public const MUTE_MUSIC:Boolean = false;
	static public const MUTE_SOUND:Boolean = false;

	static public const DEBUG_MODE:Boolean = false;
	static public const DISABLE_TOUCH:Boolean = false;
	

	//debug flags
	static public const SHOW_COLLISION_BOX:Boolean = false;
	static public const SHOW_DEBUG_PANEL:Boolean = false;
	static public const SHOW_STARLING_STATS:Boolean = true;
										

	}

}