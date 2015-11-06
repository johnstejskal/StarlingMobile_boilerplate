package data.settings 
{

	import data.constants.DeploymentPlatfoms;
	import flash.display.MovieClip;
	import ManagerClasses.StateMachine;

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

	static public var VERSION:String = "1.0.0";
	static public var DEVICE_RELEASE:Boolean = false;
	static public const DEPLOYMENT_PLATFORM:String = DeploymentPlatfoms.IOS;
	static public const DEBUG_RELEASE:Boolean = true;
	
	static public const ENABLE_ANALYTICS:Boolean = false;
	static public const ENABLE_NOTIFICATIONS:Boolean = false;
	
	static public const INITIAL_SCREEN_STATE:String = StateMachine.STATE_HOME;
	
	//sound controls
	static public const MUTE_MUSIC:Boolean = false;
	static public const MUTE_SOUND:Boolean = false;


	//debug flags
	static public const SHOW_COLLISION_BOX:Boolean = false;
	static public const SHOW_DEBUG_PANEL:Boolean = false;
	static public const SHOW_STARLING_STATS:Boolean = true;
	static public const ENABLE_GOD_MODE:Boolean = false;
	
										

	}

}