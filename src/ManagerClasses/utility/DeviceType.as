package ManagerClasses.utility 
{
	import flash.system.Capabilities;
	/**
	 * ...
	 * @author John Stejskal
	 */
	public class DeviceType 
	{
		
		static public var current:String;
		
		static public const IPHONE_5:String = "iphone5";
		static public const IPHONE_4:String = "iphone4";
		static public const IPAD:String = "ipad";
		static public const UNKNOWN:String = "unknown";
		static public const IOS:String = "ios";
		static public const ANDROID:String = "android";
		static public const Device_1920x1080:String = "1920x1080";
		
		static public var deviceManufacturer:String;


		static public function setDeviceType(resX:int, resY:int):void 
		{
			if (resX == 640 && resY == 1136)
			current = IPHONE_5;
			else if (resX == 640 && resY == 960)
			current = IPHONE_4;
			else if (resX == 768 && resY == 1024)
			current = IPAD;			
			else if (resX == 1080)
			current = Device_1920x1080;
			else
			{
			current = UNKNOWN;	
			}
			
			deviceManufacturer = String(Capabilities.manufacturer)
			if((deviceManufacturer.indexOf("iOS") != -1) || (deviceManufacturer.indexOf("ios") != -1))
			deviceManufacturer = "ios";
			else if ((deviceManufacturer.indexOf("Android") != -1) || (deviceManufacturer.indexOf("android") != -1))
			deviceManufacturer = ANDROID;
			else
			deviceManufacturer = IOS;
			
			
		}
		
		
		
	}

}