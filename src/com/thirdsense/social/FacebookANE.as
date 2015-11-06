package com.thirdsense.social 
{
	import com.distriqt.extension.facebookapi.events.FacebookAPIEvent;
	import com.distriqt.extension.facebookapi.events.FacebookAppRequestEvent;
	import com.distriqt.extension.facebookapi.events.FacebookOpenGraphActionEvent;
	import com.distriqt.extension.facebookapi.FacebookAPI;
	import com.distriqt.extension.facebookapi.objects.FacebookGraphRequest;
	import com.facebook.graph.FacebookMobile;
	import com.thirdsense.LaunchPad;
	import com.thirdsense.net.Analytics;
	import com.thirdsense.settings.LPSettings;
	import com.thirdsense.settings.Profiles;
	import com.thirdsense.social.facebook.FacebookFriend;
	import com.thirdsense.social.facebook.FacebookMobileConnection;
	import com.thirdsense.social.facebook.FacebookSessionData;
	import com.thirdsense.utils.Trig;
	import flash.display.BitmapData;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.utils.setTimeout;
	import ManagerClasses.StateMachine;
	import singleton.Core;
	import singleton.EventBus;
	
	/**
	 * Interface class for use with the Distriqt Facebook ANE<p>
	 * Please ensure that you have included the com.distriqt.FacebookAPI.ane in to your library
	 * @author Ben Leffler
	 */
	
	public class FacebookANE
	{
		private static const DEVELOPER_KEY:String = "b969479e9edb2effc5b75f75151b11314998d895qzpahg6d+UUWLAV/Npev9WtzxEObhXldfmy8xnUHAhvvbx6RPsSW0vIgTIu3E/G+WCiTFMtVBwiFEXtq5YY6nkqGqB9kkA7xw7DIirkcJkPJGq6edCj13XksSV8rNpcX4QyJCVaONjj6gNoWZnJNxAiVhMD73ODu0JlYmtrYWb7rxdc0nXF+pbkY1IgiC3WfEKwkJbbXu2N118QK81gKjZUoTwHpFANi4//29fRe0hFvqhX/jQ01BGMHVIe5THml0YOwNM/APdZaKZSCptRSR1DJMA+UuAy9lHgNhlP1nWTghlPQZWpNBdqFPwoNE5Sc5GHiiEx114lyCfTo9uMzNg==";
		
		private static var init_called:Boolean = false;
		private static var onLogin:Function;
		private static var onFriendsList:Function;
		private static var onWallPost:Function;
		private static var onUploadComplete:Function;
		
		private static var onRequestPermissionsComplete:Function;
		private static var onCheckCurrentPermissions:Function;
		
		private static var session:FacebookSessionData;
		private static var android_key_hash:String = "";
		private static var onLogout:Function;
		private static var requesting_permissions:Array;
		static private var _facebookInitedOnce:Boolean = false;
		public static var log:String = "";
		public static var FAIL_OVER_USED:Boolean = false;
		
		public function FacebookANE() 
		{
			
		}
		
		public static function init( onComplete:Function ):Boolean
		{
			
			
			if ( !Profiles.mobile || !FacebookAPI.isSupported )
			{
				var message:String = "LaunchPad [class FacebookANE] Error - this ANE interface is not supported on a non-mobile device";
				trace( message );
				return false;
			}
			
			if (!init_called)
			{
				FacebookAPI.init( DEVELOPER_KEY );
			}
			else
			{
				setTimeout( onComplete, 500 );
				return true;
			}
			
			if (!FacebookAPI.service.hasEventListener(FacebookAPIEvent.SESSION_OPENED))
			{

			FacebookAPI.service.addEventListener( FacebookAPIEvent.SESSION_OPENED, session_openedHandler );
			FacebookAPI.service.addEventListener( FacebookAPIEvent.SESSION_CLOSED, session_closedHandler );
			FacebookAPI.service.addEventListener( FacebookAPIEvent.SESSION_OPEN_CANCELLED, session_openCancelledHandler );
			FacebookAPI.service.addEventListener( FacebookAPIEvent.SESSION_OPEN_DISABLED, session_openDisabledHandler );
			FacebookAPI.service.addEventListener( FacebookAPIEvent.SESSION_OPEN_ERROR, session_openErrorHandler );
			FacebookAPI.service.addEventListener( FacebookAPIEvent.GET_PERMISSIONS_COMPLETED, permissionsResultHandler );
			FacebookAPI.service.addEventListener( FacebookAPIEvent.APP_INVOKED, appInvokedHandler );
			FacebookAPI.service.addEventListener( FacebookAppRequestEvent.APP_REQUESTS_FOUND, appRequestsFoundHandler );
			FacebookAPI.service.addEventListener( FacebookAppRequestEvent.APP_REQUEST_DATA_LOADED, appRequestsDataHandler );
			FacebookAPI.service.addEventListener( FacebookOpenGraphActionEvent.ACTION_IDS_FOUND, actionIdsFoundHandler );
			FacebookAPI.service.addEventListener( FacebookAPIEvent.DIALOG_COMPLETED, dialog_completedHandler );
			FacebookAPI.service.addEventListener( FacebookAPIEvent.DIALOG_CANCELLED, dialog_completedHandler );
			FacebookAPI.service.addEventListener( FacebookAPIEvent.DIALOG_ERROR, dialog_completedHandler );
			FacebookAPI.service.addEventListener( FacebookAPIEvent.SESSION_CLOSE_ERROR, dialog_sessionCloseError );
			FacebookAPI.service.addEventListener( FacebookAPIEvent.REQUEST_PERMISSIONS_ERROR, dialog_requestPermissionsError );
			
			}
			
			FacebookAPI.service.initialiseApp( LPSettings.FACEBOOK_APP_ID, null, LPSettings.APP_VERSION );
			
			init_called = true;
			
			setTimeout( onComplete, 500 );
			
			
			return true;
		}
		
		static private function session_openCancelledHandler(e:FacebookAPIEvent):void 
		{
			trace(FacebookANE + "session_openCancelledHandler()");
			Core.getInstance().controlBus.appUIController.removeLoadingScreen();
		}
		
		/**
		 * Call to login the user to a Facebook session
		 * @param	onComplete	Callback function should accept a boolean value indicating the result of the session call
		 * @param	customPermissions	What permissions to grant. Leaving as null will pull the permission list from the LaunchPad config.xml
		 */
		
		public static function login( onComplete:Function, customPermissions:Array = null,  useOSDialogs:Boolean = true ):void
		{
			// LaunchPad.reportError(null, "FacebookANE :: login" );
			log += "login\n";
			FAIL_OVER_USED = false;
			if ( !init_called )
			{
				trace( "LaunchPad [class FacebookANE] Error - You must call to FacebookANE.init first" );
				
				return void;
			}
			
			FacebookANE.onLogin = onComplete;
			FacebookANE.requesting_permissions = customPermissions;
			trace(FacebookANE + "login -  customPermissions are :" + customPermissions);
			FacebookAPI.service.createSession( customPermissions, false, useOSDialogs );
			
		}
		
		/**
		 * Returns a session data object for the current connection. Returns null if a connection has yet to be established.
		 * @return	A FacebookSessionData object
		 */
		
		public static function getSession():FacebookSessionData
		{
			return session;
		}
		
		/**
		 * For Android devices, you need to apply a Android Hash Key to developers.facebook.com - this can only be obtained from an Android device
		 * so a call to this function after you have attempted a Facebook login will retrieve the hash key you need to enter in to the Facebook
		 * developer portal.
		 * @param	sendToEmail	If you wish to email the hash key, pass this as true
		 * @return	The Android developer hash key if an attempt to login has already occured. An empty string will be returned and the sendToEmail
		 * call will be ignored if the hash key has not been retrieved
		 */
		
		public static function getAndroidHash( sendToEmail:Boolean ):String
		{
			if ( !android_key_hash.length )
			{
				trace( "LaunchPad [class FacebookANE] There was no Android hash key detected. Call FacebookANE.login on an Android device first." );
				return android_key_hash;
			}
			else if ( sendToEmail )
			{
				navigateToURL( new URLRequest("mailto:appdevs@3rdsense.com?subject=Android%20Hash%20Key&body=" + android_key_hash) );
			}
			
			return android_key_hash;
		}
		
		/**
		 * Populates the FacebookFriend data list with friends that have logged in to the app
		 * @param	onComplete	Callback function must accept a Boolean value indicating success of the call
		 * @param	fields	The requested data fields. Recommended to be left as default
		 */
		
		public static function getFriendsList( onComplete:Function, fields:String = "installed,name" ):void
		{
			FacebookANE.onFriendsList = onComplete;
			
			var request:FacebookGraphRequest = new FacebookGraphRequest();
			request.apiPath = "/v2.0/me/friends";
			request.method = "GET";
			var fields_arr:Array = fields.split(",");
			for ( var i:uint = 0; i < fields_arr.length; i++ )
			{
				request.addField( fields_arr[i] );
			}
			
			FacebookMobile.api( request.apiPath, onGetFriendsList, { fields:request.fields.join(",") }, request.method );
			
		}
		
		private static function onGetFriendsList( success:Object, fail:Object ):void 
		{
			 Core.getInstance().controlBus.appUIController.removeLoadingScreen();
			 Core.getInstance().oDebugPanel.setTrace(FacebookANE + "onGetFriendsList2()" + success);
			 
			 var isEmpty:Boolean = true;
			for (var n in success) { isEmpty = false; break; }

			 Core.getInstance().oDebugPanel.setTrace(FacebookANE + "isEmpty()" + isEmpty);
			
			if ( success )
			{
				Core.getInstance().oDebugPanel.setTrace(FacebookANE + "onGetFriendsList3()" + String(success));
				FacebookFriend.processFromArray( success as Array );
				
			}
			Core.getInstance().oDebugPanel.setTrace(FacebookANE + "onGetFriendsList4()" + String(success));
			if ( FacebookANE.onFriendsList != null  )
			{
				Core.getInstance().oDebugPanel.setTrace(FacebookANE + "onGetFriendsList() friends list is NOT null");
				var fn:Function = FacebookANE.onFriendsList;
				FacebookANE.onFriendsList = null;
				//fn(success);
				fn( (success != null) );
			}
			else
			{
				Core.getInstance().oDebugPanel.setTrace(FacebookANE + "onGetFriendsList() friends list is null");
			}
			
		}
		
		/*
		 * Posts to the currently connect Facebook user's wall
		 * 
		 * @param	picture		An image to attach to the post
		 * @param	postName	The name of the post
		 * @param	link		The link that will open when users click on the post name
		 * @param	caption		The text that sits right afer the post name
		 * @param	description	The text that sits right afer the post caption
		 * @param	message		An optional field that was be used to add a message typed by the user
		 * @param	onComplete	The function to return the result of the post to. Function must include a parameter that accepts a boolean value - true if successful, false otherwise
		 * @return	A boolean value that indicates the success of the call
		 */
		public static function postToWall(picture:String, postName:String, link:String, caption:String, description:String, message:String = null, onComplete:Function=null):Boolean
		{

			if ( !session || !FacebookMobile.getSession() ) return false;
			
			onWallPost = onComplete;
			
			var post:Object = { name:postName, picture:picture, link:link, caption:caption, description:description };
			if ( message ) post.message = message;
			
			var request:FacebookGraphRequest = new FacebookGraphRequest();
			request.apiPath = "/v2.0/me/feed";
			request.method = "POST";
			
			FacebookMobile.api( request.apiPath, onFacebookPost, post, request.method);
			
			return true;
		}
		
		/**
		 * @private	Handler for the postToWall call
		 */
		
		private static function onFacebookPost(result:Object, fail:Object):void
		{
			
			Core.getInstance().controlBus.appUIController.removeLoadingScreen();
			
			if ( result )
			{
				Core.getInstance().oDebugPanel.setTrace( "Post to Facebook wall reported as successful" );
				
				Core.getInstance().controlBus.appUIController.showNotification("SUCCESS!", "You deeeed it. Pat yourself on the back, unless you’re in public. You don’t want to look arrogant or anything.", "OK", null, null, null, 1);
					
				if ( LPSettings.ANALYTICS_TRACKING_ID && LPSettings.ANALYTICS_TRACKING_ID.length )
				{
					//Analytics.trackSocialMedia( "facebook", "postToWall" );
				}
			}
			else
			{
				
				Core.getInstance().controlBus.appUIController.showNotification("WHOOPS", "Something went wrong, \nplease try again later", "OK", null, null, null, 1);
					
				trace(FacebookANE+"onFacebookPost() there was a facebook post to wall failure")
				//Core.getInstance().oDebugPanel.setTrace( "Post to Facebook wall reported as a failure. Error report:" );
				var str:String = JSON.stringify(fail);
				
				str += "------ END REPORT ------";
				
				
			}
			
			if ( onWallPost != null ) {
				
				var fn:Function = onWallPost;
				onWallPost = null;
				
				fn( (result != null) );
				
			}
		}
		
		/**
		 * Log out of an existing Facebook session
		 * @param	clearSession	Clears the access token from the local device upon logout
		 */
		
		public static function logout( clearSession:Boolean = true, onComplete:Function = null ):void
		{
			trace(FacebookANE + "logout()");
			onLogout = onComplete;
			FacebookAPI.service.closeSession( clearSession );
			
			if ( LPSettings.ANALYTICS_TRACKING_ID && LPSettings.ANALYTICS_TRACKING_ID.length )
			{
				//Analytics.trackSocialMedia( "facebook", "Logged Out" );
			}
			
			
			
		}
		
		/**
		 * Uploads a BitmapData object to Facebook to appear as an image in the user's gallery
		 * @param	bitmapdata	The BitmapData object to upload
		 * @param	message	The accompanying message to appear with the image
		 * @param	onComplete	Callback function. Must accept a boolean value that indicates the success of the upload
		 * @param	disposeImage	Pass as true if you want the bitmapdata object to be disposed from memory after the api call.
		 * @return	Boolean value indicating if the call went through to the Facebook API.
		 */
		
		public static function uploadLocalImage( bitmapdata:BitmapData, message:String, onComplete:Function, disposeImage:Boolean = true ):Boolean
		{
			trace( "Attempting to upload an image to Facebook" );
			// LaunchPad.reportError(null, "FacebookANE :: uploadLocalImage" );
			
			onUploadComplete = onComplete;
			
			if ( !session )
			{
				return false;
			}
			
			var post:Object = {
				source:bitmapdata,
				fileName:"img_" + Math.round(Math.random()*10000) + ".png",
				message:message,
				no_story:false
			}
			
			var request:FacebookGraphRequest = new FacebookGraphRequest();
			request.apiPath = "/v2.0/me/photos";
			request.method = "POST";
			
			/*for ( var str:String in post )
			{
				request.addParam( str, post[str] );
			}*/
			
			FacebookMobile.api( request.apiPath, onUploadLocalImage, post, request.method);
			
			if ( disposeImage )
			{
				bitmapdata.dispose();
			}
			
			return true;
		}
		
		/**
		 * @private	Handler for the Facebook Image post call
		 */
		
		private static function onUploadLocalImage( result:Object, fail:Object ):void 
		{
			
			Core.getInstance().controlBus.appUIController.removeLoadingScreen();
			
			if ( result )
			{
				
				Core.getInstance().controlBus.appUIController.showNotification("SUCCESS!", "You deeeed it. Pat yourself on the back, unless you’re in public. You don’t want to look arrogant or anything.", "OK", null, "PLAY AGAIN", function():void {
				
					EventBus.getInstance().sigScreenChangeRequested.dispatch(StateMachine.STATE_GAME);
				}, 2);
					
				trace( "Upload of image to Facebook reported as successful" );
				// LaunchPad.reportError(null, "FacebookANE :: onUploadLocalImage (S)" );
				
				if ( LPSettings.ANALYTICS_TRACKING_ID && LPSettings.ANALYTICS_TRACKING_ID.length )
				{
					//Analytics.trackSocialMedia( "facebook", "uploadImage" );
				}
			}
			else
			{
				trace( "Upload of image to Facebook failed. Error report:" );
				// LaunchPad.reportError(null, "FacebookANE :: onUploadLocalImage (F)" );
				
				var str:String = JSON.stringify(fail);
				str += "------ END REPORT ------";
				trace( str );
				
				// LaunchPad.reportError( new Error(str) );
			}
			
			if ( onUploadComplete != null )
			{
				var fn:Function = onUploadComplete;
				onUploadComplete = null;
				fn( (result != null) );
			}
		}
		
		
		/**
		 * Obtains the currently awarded permissions for the user that is logged in
		 * @param	onComplete	The callback function. Should accept a boolean as a first param (indicates success) and an object as the second containing relevant data
		 */
		
		public static function checkCurrentPermissions( onComplete:Function ):void
		{
			FacebookANE.onCheckCurrentPermissions = onComplete;
			FacebookAPI.service.addEventListener( FacebookAPIEvent.GET_PERMISSIONS_COMPLETED, loadPermissionsHandler );	
			FacebookAPI.service.addEventListener( FacebookAPIEvent.GET_PERMISSIONS_ERROR, loadPermissionsHandler );	
			FacebookAPI.service.getCurrentPermissions();
		}
		
		/**
		 * Requests additional permissions for the user currently logged in
		 * @param	permissions	An array of permission types to request
		 * @param	onComplete	Callback function. First arguement should be a boolean value indicating success. Second arg should be an object containing any error message that results.
		 */
		
		public static function requestAdditionalPermissions( permissions:Array, onComplete:Function = null ):void
		{
			FacebookANE.onRequestPermissionsComplete = onComplete;
			FacebookAPI.service.addEventListener( FacebookAPIEvent.REQUEST_PERMISSIONS_COMPLETED, requestPermissionsHandler );
			FacebookAPI.service.addEventListener( FacebookAPIEvent.REQUEST_PERMISSIONS_CANCELLED, requestPermissionsHandler );
			FacebookAPI.service.addEventListener( FacebookAPIEvent.REQUEST_PERMISSIONS_ERROR, requestPermissionsHandler );
			FacebookAPI.service.requestPermissions( permissions );
		}
		
		
		
		// =================================================================================
		// Handlers
		// =================================================================================
		private static function requestPermissionsHandler( e:FacebookAPIEvent ):void
		{
			var fn:Function = FacebookANE.onRequestPermissionsComplete;
			FacebookANE.onRequestPermissionsComplete = null;
			
			FacebookAPI.service.removeEventListener( FacebookAPIEvent.REQUEST_PERMISSIONS_COMPLETED, requestPermissionsHandler );
			FacebookAPI.service.removeEventListener( FacebookAPIEvent.REQUEST_PERMISSIONS_CANCELLED, requestPermissionsHandler );
			FacebookAPI.service.removeEventListener( FacebookAPIEvent.REQUEST_PERMISSIONS_ERROR, requestPermissionsHandler );
			
			trace("error:e.error :" + e.error);
			switch ( e.type )
			{
				case FacebookAPIEvent.REQUEST_PERMISSIONS_COMPLETED:
					fn( true, null );
					break;
				
				case FacebookAPIEvent.REQUEST_PERMISSIONS_CANCELLED:
					fn( false, { error:"User declined" } );
					break;
					
				case FacebookAPIEvent.REQUEST_PERMISSIONS_ERROR:
					fn( false, { error:e.error } );
					break;
			}
		}
		
		private static function loadPermissionsHandler( e:FacebookAPIEvent ):void
		{
			var fn:Function = FacebookANE.onCheckCurrentPermissions;
			FacebookANE.onCheckCurrentPermissions = null;
			
			FacebookAPI.service.removeEventListener( FacebookAPIEvent.GET_PERMISSIONS_COMPLETED, loadPermissionsHandler );	
			FacebookAPI.service.removeEventListener( FacebookAPIEvent.GET_PERMISSIONS_ERROR, loadPermissionsHandler );
			
					for (var i:String in e.data)
					{
						trace("loadPermissionsHandler.data :"+i + ": " + e.data[i]);
					}
			trace(FacebookANE +"loadPermissionsHandler: e.type == " + e.type);
			
			switch ( e.type )
			{
				case FacebookAPIEvent.GET_PERMISSIONS_COMPLETED:
					trace(FacebookANE + "e.data :" + e.data);
					

					trace(FacebookANE +"loadPermissionsHandler: e.error == " + e.error);
					fn( true, { data:e.data, error:e.error } );
					
					
					break;
					
				case FacebookAPIEvent.GET_PERMISSIONS_ERROR:
					fn( false, { data:e.data, error:e.error });
					break;
			}
		}
		
		
		static private function session_openedHandler(e:FacebookAPIEvent):void 
		{
			trace(FacebookANE + "session_openedHandler()");
			
			if ( session )
			{
				return void;
			}
			
			// LaunchPad.reportError(null, "FacebookANE :: session_openedHandler" );
			
			session = new FacebookSessionData();
			if ( e.data )
			{
				session.importFromSessionEvent( e.data );
			}
			else
			{
				// LaunchPad.reportError(null, "FacebookANE :: session_openedHandler - no session data" );
			}
			
			FacebookMobile.init( LPSettings.FACEBOOK_APP_ID, onFacebookMobileInit, session.accessToken );
			
			if ( LPSettings.ANALYTICS_TRACKING_ID && LPSettings.ANALYTICS_TRACKING_ID.length )
			{
				//Analytics.trackSocialMedia( "facebook", "Logged In" );
			}
			
		}
		
		private static function onFacebookMobileInit( success:Object, fail:Object ):void 
		{
			trace(FacebookANE+"onFacebookMobileInit()");
			if ( success )
			{
				// LaunchPad.reportError(null, "FacebookANE :: onFacebookMobileInit (S)" );
				trace(FacebookANE+"onFacebookMobileInit()success");
				if ( FacebookANE.onLogin != null )
				{
					var fn:Function = FacebookANE.onLogin;
					FacebookANE.onLogin = null;
					fn( true );
				}
			}
			else
			{
				// LaunchPad.reportError(null, "FacebookANE :: onFacebookMobileInit (F)" );
				trace(FacebookANE+"onFacebookMobileInit()fail");
				trace( "LaunchPad [class FacebookANE] The Facebook SDK session started but the old classes failed to initialize" );
				
				if ( FacebookANE.onLogin != null )
				{
					var fn:Function = FacebookANE.onLogin;
					FacebookANE.onLogin = null;
					fn( false );
				}
				
				
			}
		}
		
		static private function session_closedHandler(e:FacebookAPIEvent):void 
		{
			trace(FacebookANE+"session_closedHandler()");
			log += "session_closedHandler\n" + e.rawData;
			Core.getInstance().oDebugPanel.setTrace("session_closedHandler()");
			session = null;
			
			if (FacebookANE.onLogout != null)
			{
				var fn:Function = onLogout;
				onLogout = null;
				FacebookMobileConnection.logout(fn)
			}
			
		
			if ( FacebookANE.onLogin != null )
			{
				if (!FAIL_OVER_USED)
				{
					FacebookANE.login( FacebookANE.onLogin, requesting_permissions, false );
					FAIL_OVER_USED = true;
				}
				else
				{
					var fn:Function = FacebookANE.onLogin;
					FacebookANE.onLogin = null;
					fn( false );
				}
				
			}
			
		}
		
		static private function session_openDisabledHandler(e:FacebookAPIEvent):void 
		{
			trace(FacebookANE + "session_openDisabledHandler()");
			log += "session_openDisabledHandler\n";
		}
		
		static private function session_openErrorHandler(e:FacebookAPIEvent):void 
		{
			trace(FacebookANE + "session_openErrorHandler()");
			trace(FacebookANE + "session_openErrorHandler error:"+e.error);
			
			log += "session_openErrorHandler\n" + e.error;
			
			var index:int = e.error.indexOf("ApiException:Key hash");
			if ( index >= 0 )
			{
				index += 22;
				var index2:int = e.error.indexOf( " ", index );
				android_key_hash = e.error.substring( index, index2 ) + "=";
				getAndroidHash(LaunchPad.getValue("debug") == "true");
			}
			else
			{
				// LaunchPad.reportError(null, "FacebookANE :: session_openErrorHandler -->\n" + e.error );
				
			}
			
			if ( FacebookANE.onLogin != null )
			{
				var fn:Function = FacebookANE.onLogin;
				FacebookANE.onLogin = null;
				fn( false );
			}
		}
		
		static private function dialog_requestPermissionsError(e:FacebookAPIEvent):void 
		{
			log += "dialog_requestPermissionsError\n";
			trace("dialog_requestPermissionsError()");
		}
				
		static private function dialog_sessionCloseError(e:FacebookAPIEvent):void 
		{
			log += "dialog_sessionCloseError\n";
			trace("dialog_sessionCloseError()");
		}
				
		static private function permissionsResultHandler(e:FacebookAPIEvent):void 
		{
			log += "permissionsResultHandler\n";
			trace("permissionsResultHandler()");
		}
		
		static private function appInvokedHandler(e:FacebookAPIEvent):void 
		{
			log += "appInvokedHandler\n";
			trace("appInvokedHandler()");
		}
		
		static private function appRequestsFoundHandler(e:FacebookAppRequestEvent):void 
		{
			log += "appRequestsFoundHandler\n";
			trace("appRequestsFoundHandler()");
		}
		
		static private function appRequestsDataHandler(e:FacebookAppRequestEvent):void 
		{
			log += "appRequestsDataHandler\n";
			trace("appRequestsDataHandler()");
		}
		
		static private function actionIdsFoundHandler(e:FacebookOpenGraphActionEvent):void 
		{
			log += "actionIdsFoundHandler\n";
			trace("actionIdsFoundHandler()");
		}
		
		static private function dialog_completedHandler(e:FacebookAPIEvent):void 
		{
			log += "dialog_completedHandler\n";
			trace("dialog_completedHandler()");
		}
		
		
	}

}