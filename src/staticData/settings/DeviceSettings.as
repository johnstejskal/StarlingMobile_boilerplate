package staticData.settings 
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
	static public const ENABLE_GESTURES:Boolean = false;
	static public const ENABLE_ACCELEROMETER:Boolean = true;


	
	// first check to see if we're on the device or in the debugger //
	public static const isDebugger:Boolean = Capabilities.isDebugger;
		
	// set a few variables that'll help us deal with the debugger//
	public static const isLandscape:Boolean = true;  // most of my games are in landscape
	public static const debuggerDevice:String = "iPhone3"; // iPhone3 = iPhone4,4s, etc.
 
		// we create an object here that'll keep a detailed abount of the current environment.
	public static const DeviceDetails:Object = getDeviceDetails();
 
	public static const GameWidth:int  = DeviceDetails.width;  // set an Easy reference for Height & Width
	public static const GameHeight:int = DeviceDetails.height; 
 
	public static const CenterX:int = DeviceDetails.x;  // Calculate the CenterX & Y for the screen
	public static const CenterY:int = DeviceDetails.y;
 
	// I find that having a rect that accurately represents the screen size is useful, so I make one here for both main orientations.
	public static const GameScreenLandscape:Rectangle = new Rectangle(CenterX, CenterY, GameWidth, GameHeight);
	public static const GameScreenPortrait:Rectangle = new Rectangle(CenterY, CenterX, GameHeight, GameWidth); 
 
	public static function getDeviceDetails():Object 
	{
			var retObj:Object = {};
			var devStr:String = Capabilities.os;
			var devStrArr:Array = devStr.split(" ");
			devStr = devStrArr.pop();
			devStr = (devStr.indexOf(",") > -1)?devStr.split(",").shift():debuggerDevice;
			if ((devStr == "iPhone1") || (devStr == "iPhone2")){
				// lowdef iphone, 3, 3g, 3gs
				retObj.width = 480;
				retObj.height = 320;
				retObj.x = 240;
				retObj.y = 160;
				retObj.device = "iphone";
				retObj.scale = 1;
			} else if ((devStr == "iPhone3") || (devStr == "iPhone4") || (devStr == "iPhone5")){
				// highdef iphone 4, 4s, 5?
				retObj.width = 960;
				retObj.height = 640;
				retObj.x = 480;
				retObj.y = 320;
				retObj.device = "iphone4";
				retObj.scale = 2;
			} else if ((devStr == "iPad1") || (devStr == "iPad2")){
				// ipad 1,2
				retObj.width = 1024;
				retObj.height = 768;
				retObj.x = 512;
				retObj.y = 384;
				retObj.device = "ipad";
				retObj.scale = 1;
			} else if ((devStr == "iPad3")){
				//AKA "the new ipad"
				retObj.width = 2048;
				retObj.height = 1536;
				retObj.x = 1024;
				retObj.y = 768;
				retObj.device = "ipad";
				retObj.scale = 2; // oops!  thanks for pointing that out
			} else {
				//No devices identified, lets try a back up approach based on device res
				
				   var resolutionY:Number;
				   if (!Capabilities.isDebugger)
					resolutionY = Capabilities.screenResolutionY; 
					
					  if(resolutionY == 960)  // now we just guess the device based on that resolution
					  {
						retObj.device = 'iphone4'; // high def iphone (4, 4s)
					  }
					  else if (resolutionY == 480)
					  {
						retObj.device = 'iphone';  // low def iphone  (3g, 3gs, iPod Touch)
					  }
					  else if (resolutionY == 1024)
					  {
						retObj.device = 'ipad';  // ipad ( 1 & 2)
					  }
					  else if (resolutionY == 2048)
					  {
						retObj.device = 'ipad3'; //ipad3 and above
					  }
			}
			return retObj;
	}		
	
	
	
	
	}

}