package data.settings 
{
	import flash.ui.MultitouchInputMode;

	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	/**
	 * @author John Stejskal
	 * "Why walk when you can ride"
	 */
	
	 
	 /*
	  * This is a public interface for global Device settings.
	  *
	  */
	 
	public class DeviceSettings 
	{

		static public const TOUCH_INPUT_MODE:String = MultitouchInputMode.TOUCH_POINT;
		static public const KEEP_DEVICE_AWAKE:Boolean = true;
		static public const ENABLE_TOUCH:Boolean = true;
		static public const ENABLE_GESTURES:Boolean = true;
		static public const ENABLE_ACCELEROMETER:Boolean = true;
		static public const ENABLE_LOCAL_STORAGE:Boolean = false;
		
		static public const ENABLE_DEVICE_ACTIVATE:Boolean = true;
		static public const ENABLE_DEVICE_DEACTIVATE:Boolean = true;
		
		static public var isVibrationMuted:Boolean = false;
		static public var isPushNotificationMuted:Boolean = true;
		static public var isLocationServicesMuted:Boolean = false;
		
	
	}

}