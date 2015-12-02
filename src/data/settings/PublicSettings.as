package data.settings 
{

	import data.constants.AppStates;
	import data.constants.Platform;
	import flash.display.MovieClip;
	import ManagerClasses.StateMachine;

	/**
	 * @author John Stejskal
	 * "Why walk when you can ride"
	 */
	
	//=====================================================================o 
	/*
	 * This is a public interface for global app settings.
	 * for game specific constants like level maps, go to Constants.as 
	 */
	 //=====================================================================o 
	public class PublicSettings 
	{

	static public var VERSION:String = "1.0.0";
	static public var APP_NAME:String = "appName";
	static public var DEVICE_RELEASE:Boolean = false;
	static public const DEPLOYMENT_PLATFORM:String = Platform.IOS;
	static public const DEBUG_RELEASE:Boolean = true;
	
	static public const ENABLE_ANALYTICS:Boolean = false;
	static public const ENABLE_NOTIFICATIONS:Boolean = false;
	
	static public const INITIAL_SCREEN_STATE:String = AppStates.STATE_HOME;
	
	//sound controls
	static public const MUTE_MUSIC:Boolean = false;
	static public const MUTE_SOUND:Boolean = false;


	//debug flags
	static public const SHOW_COLLISION_BOX:Boolean = false;
	static public const SHOW_DEBUG_PANEL:Boolean = false;
	static public const SHOW_STARLING_STATS:Boolean = true;
	static public const ENABLE_GOD_MODE:Boolean = false;
	
	
	
	static public const SLIDE_MENU_IN_SPEED:Number = .1;
	static public const SLIDE_MENU_OUT_SPEED:Number = .2;
	static public const NEW_SECTIONS:Array = [];
	
										

	}

}