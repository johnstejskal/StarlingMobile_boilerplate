package com.thirdsense.controllers 
{
	import com.pushwoosh.nativeExtensions.PushNotification;
	import com.pushwoosh.nativeExtensions.PushNotificationEvent;
	import flash.system.Capabilities;
	
	/**
	 * ...
	 * @author Ben Leffler
	 */
	public class PushController 
	{
		private static var instance:PushController;
		
		private var pushwoosh:PushNotification;
		private var onComplete:Function;
		private var received:Array;
		
		public var onNotification:Function;
		
		public function PushController() 
		{
			trace( "PushController.constructor" );
			
			pushwoosh = PushNotification.getInstance();
			received = new Array();
		}
		
		private function startService():void
		{
			trace( "PushController.startService" );
			
			pushwoosh.addEventListener( PushNotificationEvent.PERMISSION_GIVEN_WITH_TOKEN_EVENT, pushNotificationEventHandler, false, 0, true );
			pushwoosh.addEventListener( PushNotificationEvent.PERMISSION_REFUSED_EVENT, pushNotificationEventHandler, false, 0, true );
			pushwoosh.addEventListener( PushNotificationEvent.PUSH_NOTIFICATION_RECEIVED_EVENT, pushNotificationEventHandler, false, 0, true );
			
			pushwoosh.onDeviceReady();
			
			
		}
		
		public final function muteNotifications():void
		{
			trace( "PushController.muteNotifications" );
			
			pushwoosh.unregisterFromPushNotification();
		}
		
		public final function resumeNotifications():void
		{
			trace( "PushController.resumeNotifications" );
			
			pushwoosh.registerForPushNotification();
		}
		
		public final function registerForService( onComplete:Function ):void
		{
			trace( "PushController.registerForService" );
			
			this.onComplete = onComplete;
			pushwoosh.registerForPushNotification();
		}
		
		public final function unregisterForService():void
		{
			trace( "PushController.unregisterForService" );
			
			pushwoosh.unregisterFromPushNotification();
		}
		
		private function pushNotificationEventHandler(e:PushNotificationEvent):void 
		{
			trace( "PushController.pushNotificationEventHandler" );
			
			switch ( e.type )
			{
				case PushNotificationEvent.PERMISSION_GIVEN_WITH_TOKEN_EVENT:
					trace( "PUSH TOKEN RECEIVED:", e.token );
					
					/*
					
					if ( Capabilities.manufacturer.toLowerCase().indexOf("android") >= 0 )
					{
						pushwoosh.setMultiNotificationMode();
					}
					
					*/
					
					if ( onComplete != null )
					{
						var fn:Function = onComplete;
						onComplete = null;
						fn( true, e.token );
					}
					break;
					
				case PushNotificationEvent.PERMISSION_REFUSED_EVENT:
					trace( "PUSH ERROR:", e.errorMessage + " (" + e.errorCode + ")" );
					if ( onComplete != null )
					{
						fn = onComplete;
						onComplete = null;
						fn( false, e.errorMessage );
					}
					break;
					
				case PushNotificationEvent.PUSH_NOTIFICATION_RECEIVED_EVENT:
					trace( "PUSH RECEIVED:\n" + JSON.stringify(e.parameters) );
					pushwoosh.setBadgeNumberValue(0);
					received.push( e.parameters );
					if ( this.onNotification != null )
					{
						this.onNotification();
					}
					break;
					
			}
			
		}
		
		public final function sendLocalNotification( seconds:int, alertBody:String, alertAction:String, soundName:String = "notification.caf", badge:int = 1, data:Object = null ):void
		{
			trace( "PushController.sendLocalNotification" );
			
			var custom:String = "json";
			
			if ( data != null )
			{
				custom = JSON.stringify(data);
			}
			
			var obj:Object = {
				alertBody:alertBody,
				alertAction:alertAction,
				soundName:soundName,
				badge:badge,
				custom: {
					a:custom
				}
			}
			pushwoosh.scheduleLocalNotification( seconds, JSON.stringify(obj) );
			
		}
		
		public final function cancelLocalNotifications():void
		{
			trace( "PushController.cancelLocalNotifications" );
			
			pushwoosh.clearLocalNotifications();
		}
		
		private function dispose():void
		{
			trace( "PushController.dispose" );
			
			pushwoosh.removeEventListener( PushNotificationEvent.PERMISSION_GIVEN_WITH_TOKEN_EVENT, pushNotificationEventHandler );
			pushwoosh.removeEventListener( PushNotificationEvent.PERMISSION_REFUSED_EVENT, pushNotificationEventHandler );
			pushwoosh.removeEventListener( PushNotificationEvent.PUSH_NOTIFICATION_RECEIVED_EVENT, pushNotificationEventHandler );
		}
		
		public static function init():Boolean
		{
			trace( "PushController.init" );
			
			if ( !instance )
			{
				instance = new PushController();
				
				if ( instance.pushwoosh.isPushNotificationSupported )
				{
					trace( "Push notifications are supported by this device" );
					instance.startService();
					return true;
				}
				else
				{
					trace( "Push notifications are not supported by this device" );
					instance = null;
					return false;
				}
			}
			else
			{
				return true;
			}
			
			
		}
		
		public static function getNotificationData( entries:int = -1, deleteEntry:Boolean = true ):Array
		{
			trace( "PushController.getNotificationData" );
			
			if ( entries == -1 )
			{
				entries = instance.received.length;
			}
			
			var arr:Array;
			for ( var i:int = 0; i < entries && i < instance.received.length; i++ )
			{
				if ( !arr ) arr = new Array();
				
				if ( deleteEntry )
				{
					arr.push( instance.received.shift() );
					i--;
				}
				else
				{
					arr.push( instance.received[i] );
				}
			}
			
			return arr;
		}
		
		public static function kill():void
		{
			trace( "PushController.kill" );
			if ( instance )
			{
				instance.dispose();
				instance.pushwoosh.clearLocalNotifications();
				instance = null;
			}
		}
		
		public static function getInstance():PushController
		{
			return instance;
		}
		
	}

}