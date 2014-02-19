package staticData.settings 
{
	import flash.desktop.SystemIdleMode;
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

	static public const KEEY_AWAKE:Boolean = false;
	static public const TOUCH_INPUT_MODE:String = MultitouchInputMode.TOUCH_POINT;
	static public const SYSTEM_IDLE_MODE:String = SystemIdleMode.KEEP_AWAKE;

										

	}

}