package com.johnstejskal
{
	import data.constants.SharedObjectKeys;
	import data.controllerData.SoundData;
	import data.LocalData;
	import data.PlayerData;
	import data.settings.DeviceSettings;
	import data.settings.PublicSettings;
	import flash.net.SharedObject;


	
	public class SharedObjects
	{
		
		private static var APP:String = PublicSettings.APP_NAME;
		private static var so:SharedObject = null;
		private static var soNotif:SharedObject = null;
		
		public function SharedObjects():void
		{
			
		}
		
		//========================================o
		//-- initiate Shared objects
		//========================================o
		public static function init():void
		{
			trace("SharedObjects :"+SharedObjects)
			so = SharedObject.getLocal(APP);
			so.flush();
			
			var username:String = "guest";
/*			if (PlayerData.firstName)
			username = PlayerData.firstName;
			
			soNotif = SharedObject.getLocal(username+PublicSettings.VERSION);
			soNotif.flush();*/
			
		}
		
		
		public static function initNotif():void
		{
			var username:String = "guest";
			if (PlayerData.firstName)
			username = PlayerData.firstName;
			
			soNotif = SharedObject.getLocal(username+PublicSettings.VERSION);
			soNotif.flush();
		}
		//========================================o
		//-- add / update a shared object
		//========================================o
		public static function setProperty(key:String, value:*, notifData:Boolean = false):void {
			
			if (!notifData)
			{
				so.data[key] = value;
				so.flush();
			}
			else
			{
				soNotif.data[key] = value;
				soNotif.flush();	
			}
			
			//trace("so.data["+key+"] :"+so.data[key])
		}
		
		//========================================o
		//-- Retreive a property
		//========================================o
		public static function getProperty(key:String, notifData:Boolean = false):* {
			var val:*; 
			if (!notifData)
			val = so.data[key]
			else
			val = soNotif.data[key]
		
			return val;
		}
		
		//========================================o
		//-- Removed a Shared Object
		//========================================o
		public static function removeProperty(key:String, notifData:Boolean = false):void {
			
			if (!notifData)
			{
				so.data[key] = null;
				so.flush();
			}
			else
			{
				soNotif.data[key] = null;
				soNotif.flush();	
			}
		}
		
		
		//========================================o
		//-- Check to see if login credentials are stored in local memory
		//========================================o
		static public function registerData():void 
		{
			var e:Object = getProperty("email");
			var p:Object = getProperty("password");
			var pd:Object = getProperty(SharedObjectKeys.PLAYER_SAVE_DATA);
			
			
			//if(SharedObjects.getProperty(SharedObjectKeys.NEW_STATES_VIEWED))
			//LocalData.arrScreenNotificationsViewed = SharedObjects.getProperty(SharedObjectKeys.NEW_STATES_VIEWED)
			
			var isLocationServicesMuted:Boolean = getProperty(SharedObjectKeys.IS_LOCATION_SERVICES_MUTED);
			
			if(e != null){
			LocalData.email = String(e);
			//PlayerData.email = String(e);
			//LocalData.email = PlayerData.unhashEmail(String(e));
			//PlayerData.email = LocalData.email;
			}
			if (p != null)
			{
			//LocalData.password = String(p);
			//PlayerData.password = String(p);		
			//LocalData.password = //PlayerData.unhashPass(String(p));
			//PlayerData.password = LocalData.password;
			}
			if (pd != null)
			{
				LocalData.playerDataObj = String(pd);
			}
			
			var token:String = getProperty(SharedObjectKeys.TOKEN)
			trace(SharedObjects + "token :" + token);
			if (token)
			{
				LocalData.token = getProperty(SharedObjectKeys.TOKEN)
			}
			
			var isVibrationMuted:Boolean = getProperty(SharedObjectKeys.IS_VIBRATION_MUTED);
			DeviceSettings.isVibrationMuted = isVibrationMuted;
						
			var isPushMuted:Boolean = getProperty(SharedObjectKeys.IS_PUSH_MUTED);
			DeviceSettings.isPushNotificationMuted = isPushMuted;
			
			if (isLocationServicesMuted)
			DeviceSettings.isLocationServicesMuted = true;
			

			//sound SFX
			var soSFXMuted:Boolean = getProperty(SharedObjectKeys.IS_SFX_MUTED);
			SoundData.isSFXMuted = soSFXMuted;

		}
				
		//========================================o
		//-- Delete all Shared Objects
		//========================================o
		static public function deleteAll(notifData:Boolean = false):void 
		{
			if (!notifData)
			{
				so.clear();
			}
			else
			{
				soNotif.clear();
			}
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