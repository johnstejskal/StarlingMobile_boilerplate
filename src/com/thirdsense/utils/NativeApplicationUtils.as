package com.thirdsense.utils 
{
	import flash.desktop.NativeApplication;
	
	/**
	 * ...
	 * @author Ben Leffler
	 */
	
	public class NativeApplicationUtils 
	{
		
		public function NativeApplicationUtils() 
		{
			
		}
		
		public static function getAppVersion():String
		{
			var appDescriptor:XML = NativeApplication.nativeApplication.applicationDescriptor;
			var xml_str:String = appDescriptor.toString();
			xml_str = StringTools.replaceAll( xml_str, "xmlns=", "xmlns:default=" );
			appDescriptor = XML( xml_str );
			
			return String( appDescriptor.versionNumber );
		}
		
		public static function getAspectRatio():String
		{
			var appDescriptor:XML = NativeApplication.nativeApplication.applicationDescriptor;
			var xml_str:String = appDescriptor.toString();
			xml_str = StringTools.replaceAll( xml_str, "xmlns=", "xmlns:default=" );
			appDescriptor = XML( xml_str );
			
			return String( appDescriptor.initialWindow.aspectRatio );
		}
		
		public static function getNativeExtensions():Array
		{
			var appDescriptor:XML = NativeApplication.nativeApplication.applicationDescriptor;
			var xml_str:String = appDescriptor.toString();
			xml_str = StringTools.replaceAll( xml_str, "xmlns=", "xmlns:default=" );
			appDescriptor = XML( xml_str );
			
			var arr:Array = new Array();
			for ( var i:int = 0; appDescriptor.extensions.extensionID[i]; i++ )
			{
				arr.push( String(appDescriptor.extensions.extensionID[i]) );
			}
			
			return arr;
		}
	}

}