package staticData.settings 
{
	import flash.ui.MultitouchInputMode;


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
	static public const ENABLE_GESTURES:Boolean = false;
	static public const ENABLE_ACCELEROMETER:Boolean = true;


	}

}