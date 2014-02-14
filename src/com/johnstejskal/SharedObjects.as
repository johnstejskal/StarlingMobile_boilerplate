package com.johnstejskal
{
	import flash.net.SharedObject;
	
	public class SharedObjects
	{
		
		private static var APP:String = "APP_NAME";
		private static var so:SharedObject = null;
		
		public function SharedObjects():void
		{
		}
		public static function setup_sharedObjects():void
		{
			trace("SharedObjects :"+SharedObjects)
			so = SharedObject.getLocal(APP);
			so.flush();
		}
		
		public static function setProperty(key:String, value:Object):void {
			so.data[key] = value;
			so.flush();
			
			trace("so.data["+key+"] :"+so.data[key])
		}
		
		public static function getProperty(key:String):Object {
			return so.data[key];
		}
		
		public static function removeProperty(key:String):void {
			so.data[key] = null;
			so.flush();
		}
		/*
		private function save_mobile(key:String, value:*):void 
		{ 
			
			
			so.data[key] = value;//int(so.data['age']) + 1; 
			so.flush(); 
			
			
			trace("Saved generation " + so.data[key]); 
		} 
		
		private function load():void 
		{ // Get the shared object. 
			var so:SharedObject = SharedObject.getLocal("myApp"); 
			
			// And indicate the value for debugging. 
			trace("Loaded generation " + so.data['age']); 
		}	
		*/
		
		

	}
}