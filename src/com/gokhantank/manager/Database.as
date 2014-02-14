package com.gokhantank.manager
{
	import flash.net.SharedObject;
	
	public class Database
	{
		
		private static var APP:String = "GADGET1_1";
		private static var so:SharedObject = null;
		
		public function Database()
		{
			so = SharedObject.getLocal(APP);
			so.flush();
		}
		
		public static function setProperty(key:String, value:Object):void {
			so.data[key] = value;
			so.flush();
		}
		
		public static function getProperty(key:String):Object {
			return so.data[key];
		}
		
		public static function removeProperty(key:String):void {
			so.data[key] = null;
			so.flush();
		}

	}
}