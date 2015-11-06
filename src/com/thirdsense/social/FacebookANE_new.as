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
	import com.thirdsense.social.facebook.FacebookSessionData;
	import com.thirdsense.utils.Trig;
	import flash.display.BitmapData;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.utils.setTimeout;
	
	/**
	 * Interface class for use with the Distriqt Facebook ANE<p>
	 * Please ensure that you have included the com.distriqt.FacebookAPI.ane in to your library
	 * @author Ben Leffler
	 */
	
	public class FacebookFPANE_new
	{
		private static const DEVELOPER_KEY:String = "b969479e9edb2effc5b75f75151b11314998d895qzpahg6d+UUWLAV/Npev9WtzxEObhXldfmy8xnUHAhvvbx6RPsSW0vIgTIu3E/G+WCiTFMtVBwiFEXtq5YY6nkqGqB9kkA7xw7DIirkcJkPJGq6edCj13XksSV8rNpcX4QyJCVaONjj6gNoWZnJNxAiVhMD73ODu0JlYmtrYWb7rxdc0nXF+pbkY1IgiC3WfEKwkJbbXu2N118QK81gKjZUoTwHpFANi4//29fRe0hFvqhX/jQ01BGMHVIe5THml0YOwNM/APdZaKZSCptRSR1DJMA+UuAy9lHgNhlP1nWTghlPQZWpNBdqFPwoNE5Sc5GHiiEx114lyCfTo9uMzNg==";
		
		private static var init_called:Boolean = false;
		private static var onLogin:Function;
		private static var onFriendsList:Function;
		private static var onRequestPermissionsComplete:Function;
		private static var onCheckCurrentPermissions:Function;
		private static var onGraphRequestComplete:Function;
		private static var session:FacebookSessionData;
		private static var android_key_hash:String = "";
		
		
		public function FacebookFPANE_new() 
		{
			
		}
		
		public static function get isSupported():Boolean { return FacebookAPI.isSupported };
		
		public static function init( onComplete:Function ):Boolean
		{
			if ( !Profiles.mobile || !FacebookAPI.isSupported )
			{
				var message:String = "LaunchPad [class FacebookFPANE] Error - this ANE interface is not supported on a non-mobile device";
				trace( message );
				return false;
			}
			
			FacebookAPI.init( DEVELOPER_KEY );
			
			FacebookAPI.service.addEventListener( FacebookAPIEvent.SESSION_OPENED, session_openedHandler );
			FacebookAPI.service.addEventListener( FacebookAPIEvent.SESSION_CLOSED, session_closedHandler );
			FacebookAPI.service.addEventListener( FacebookAPIEvent.SESSION_OPEN_DISABLED, session_openDisabledHandler );
			FacebookAPI.service.addEventListener( FacebookAPIEvent.SESSION_OPEN_ERROR, session_openErrorHandler );
			FacebookAPI.service.addEventListener( FacebookAPIEvent.APP_INVOKED, appInvokedHandler );
			FacebookAPI.service.addEventListener( FacebookAppRequestEvent.APP_REQUESTS_FOUND, appRequestsFoundHandler );
			FacebookAPI.service.addEventListener( FacebookAppRequestEvent.APP_REQUEST_DATA_LOADED, appRequestsDataHandler );
			FacebookAPI.service.addEventListener( FacebookOpenGraphActionEvent.ACTION_IDS_FOUND, actionIdsFoundHandler );
			FacebookAPI.service.addEventListener( FacebookAPIEvent.DIALOG_COMPLETED, dialog_completedHandler );
			FacebookAPI.service.addEventListener( FacebookAPIEvent.DIALOG_CANCELLED, dialog_completedHandler );
			FacebookAPI.service.addEventListener( FacebookAPIEvent.DIALOG_ERROR, dialog_completedHandler );
			
			FacebookAPI.service.initialiseApp( LPSettings.FACEBOOK_APP_ID, null, LPSettings.APP_VERSION );
			
			init_called = true;
			
			setTimeout( onComplete, 500 );
			
			// LaunchPad.reportError(null, "FacebookFPANE :: init" );
			
			return true;
		}
		
		/**
		 * Call to login the user to a Facebook session
		 * @param	onComplete	Callback function should accept a boolean value indicating the result of the session call
		 * @param	customPermissions	What permissions to grant. Leaving as null will pull the permission list from the LaunchPad config.xml
		 */
		
		public static function login( onComplete:Function, customPermissions:Array = null ):void
		{
			// LaunchPad.reportError(null, "FacebookFPANE :: login" );
			
			if ( !init_called )
			{
				trace( "LaunchPad [class FacebookFPANE] Error - You must call to FacebookFPANE.init first" );
				return void;
			}
			
			FacebookFPANE.onLogin = onComplete;
			
			if ( !customPermissions )
			{
				customPermissions = Trig.copyArray( LPSettings.FACEBOOK_PERMISSIONS );
			}
			
			FacebookAPI.service.createSession( customPermissions, false, true );
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
				trace( "LaunchPad [class FacebookFPANE] There was no Android hash key detected. Call FacebookFPANE.login on an Android device first." );
				return android_key_hash;
			}
			else if ( sendToEmail )
			{
				navigateToURL( new URLRequest("mailto:appdevs@3rdsense.com?subject=Android%20Hash%20Key%20for%20"+ escape(LPSettings.APP_NAME) +"&body=" + android_key_hash) );
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
			FacebookFPANE.onFriendsList = onComplete;
			
			var request:FacebookGraphRequest = new FacebookGraphRequest();
			request.apiPath = "/me/friends";
			request.method = "GET";
			var fields_arr:Array = fields.split(",");
			for ( var i:uint = 0; i < fields_arr.length; i++ )
			{
				request.addField( fields_arr[i] );
			}
			
			FacebookFPANE.onGraphRequestComplete = onGetFriendsList;
			FacebookAPI.service.addEventListener( FacebookAPIEvent.GRAPH_REQUEST_COMPLETED, graphRequestHandler );
			FacebookAPI.service.addEventListener( FacebookAPIEvent.GRAPH_REQUEST_ERROR, graphRequestHandler );
			FacebookAPI.service.graphRequest( request );
			
		}
		
		private static function onGetFriendsList( success:Boolean, data:Object ):void 
		{
			if ( success )
			{
				FacebookFriend.processFromArray( data.data as Array );
			}
			
			if ( FacebookFPANE.onFriendsList != null )
			{
				var fn:Function = FacebookFPANE.onFriendsList;
				FacebookFPANE.onFriendsList = null;
				fn( success );
			}
		}
		
		/**
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
			if ( !session ) return false;
			
			var post:Object = { name:postName, picture:picture, link:link, caption:caption, description:description };
			if ( message ) post.message = message;
			
			var request:FacebookGraphRequest = new FacebookGraphRequest();
			request.apiPath = "/me/feed";
			request.method = "POST";
			
			for ( var str:String in post )
			{
				request.addParam( str, post[str] );
			}
			
			FacebookFPANE.onGraphRequestComplete = onComplete;
			FacebookAPI.service.addEventListener( FacebookAPIEvent.GRAPH_REQUEST_COMPLETED, graphRequestHandler );
			FacebookAPI.service.addEventListener( FacebookAPIEvent.GRAPH_REQUEST_ERROR, graphRequestHandler );
			FacebookAPI.service.graphRequest( request );
			
			if ( LPSettings.ANALYTICS_TRACKING_ID && LPSettings.ANALYTICS_TRACKING_ID.length )
			{
				//Analytics.trackSocialMedia( "facebook", "postToWall" );
			}
			
			return true;
		}
		
		/**
		 * Log out of an existing Facebook session
		 * @param	clearSession	Clears the access token from the local device upon logout
		 */
		
		public static function logout( clearSession:Boolean = true ):void
		{
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
			// LaunchPad.reportError(null, "FacebookFPANE :: uploadLocalImage" );
			
			if ( !session )
			{
				return false;
			}
			
			var post:Object = {				
				message:message,
				no_story:false
			}
			
			var request:FacebookGraphRequest = new FacebookGraphRequest();
			request.apiPath = "/me/photos";
			request.method = "POST";
			request.image = bitmapdata;
			
			for ( var str:String in post )
			{
				request.addParam( str, post[str] );
			}
			
			FacebookFPANE.onGraphRequestComplete = onComplete;
			FacebookAPI.service.addEventListener( FacebookAPIEvent.GRAPH_REQUEST_COMPLETED, graphRequestHandler );
			FacebookAPI.service.addEventListener( FacebookAPIEvent.GRAPH_REQUEST_ERROR, graphRequestHandler );
			FacebookAPI.service.graphRequest( request );
			
			if ( LPSettings.ANALYTICS_TRACKING_ID && LPSettings.ANALYTICS_TRACKING_ID.length )
			{
				//Analytics.trackSocialMedia( "facebook", "uploadImage" );
			}
			
			if ( disposeImage )
			{
				bitmapdata.dispose();
			}
			
			return true;
		}
		
		/**
		 * Places a custom Graph API call to Facebook
		 * @param	request	The FacebookGraphRequest object to pass through to the API
		 * @param	onComplete	Callback for the request
		 * @return	Boolean value indicating the success of request dispatch
		 */
		
		public static function customAPICall( request:FacebookGraphRequest, onComplete:Function = null ):Boolean
		{
			if ( !session ) return false;
			
			if ( LPSettings.ANALYTICS_TRACKING_ID && LPSettings.ANALYTICS_TRACKING_ID.length )
			{
				//Analytics.trackSocialMedia( "facebook", request.apiPath );
			}
			
			FacebookFPANE.onGraphRequestComplete = onComplete;
			FacebookAPI.service.addEventListener( FacebookAPIEvent.GRAPH_REQUEST_COMPLETED, graphRequestHandler );
			FacebookAPI.service.addEventListener( FacebookAPIEvent.GRAPH_REQUEST_ERROR, graphRequestHandler );
			FacebookAPI.service.graphRequest( request );
			
			return true;
		}
		
		/**
		 * Obtains the currently awarded permissions for the user that is logged in
		 * @param	onComplete	The callback function. Should accept a boolean as a first param (indicates success) and an object as the second containing relevant data
		 */
		
		public static function checkCurrentPermissions( onComplete:Function ):void
		{
			FacebookFPANE.onCheckCurrentPermissions = onComplete;
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
			FacebookFPANE.onRequestPermissionsComplete = onComplete;
			FacebookAPI.service.addEventListener( FacebookAPIEvent.REQUEST_PERMISSIONS_COMPLETED, requestPermissionsHandler );
			FacebookAPI.service.addEventListener( FacebookAPIEvent.REQUEST_PERMISSIONS_CANCELLED, requestPermissionsHandler );
			FacebookAPI.service.addEventListener( FacebookAPIEvent.REQUEST_PERMISSIONS_ERROR, requestPermissionsHandler );
			FacebookAPI.service.requestPermissions( permissions );
		}
		
		/**
		 * Obtains the currently logged in user details
		 * @param	onComplete	The callback. First arg should be boolean indicating success. Second arg is an object containing what was returned.
		 */
		
		public static function getUserInfo( onComplete:Function ):void
		{
			FacebookFPANE.onGraphRequestComplete = onComplete;
			FacebookAPI.service.addEventListener( FacebookAPIEvent.GRAPH_REQUEST_COMPLETED, graphRequestHandler );
			FacebookAPI.service.addEventListener( FacebookAPIEvent.GRAPH_REQUEST_ERROR, graphRequestHandler );
			
			var request:FacebookGraphRequest = new FacebookGraphRequest( "/me" );
			request.method = "GET";
			FacebookAPI.service.graphRequest( request );
		}
		
		// =================================================================================
		// Handlers
		// =================================================================================
		
		private static function graphRequestHandler( e:FacebookAPIEvent ):void
		{
			var fn:Function = FacebookFPANE.onGraphRequestComplete;
			var numArgs:int = fn.length;
			FacebookFPANE.onGraphRequestComplete = null;
			
			FacebookAPI.service.removeEventListener( FacebookAPIEvent.GRAPH_REQUEST_COMPLETED, graphRequestHandler );
			FacebookAPI.service.removeEventListener( FacebookAPIEvent.GRAPH_REQUEST_ERROR, graphRequestHandler );
			
			if ( fn == null ) return void;
			
			switch ( e.type )
			{
				case FacebookAPIEvent.GRAPH_REQUEST_COMPLETED:
					var success:Boolean = true;
					break;
					
				case FacebookAPIEvent.GRAPH_REQUEST_ERROR:
					success = false;
					break;
			}
			
			if ( !numArgs ) fn();
			else if ( numArgs == 1 ) fn( success );
			else fn( success, { data:e.data, error:e.error, raw:e.rawData } );
		}
		
		private static function requestPermissionsHandler( e:FacebookAPIEvent ):void
		{
			var fn:Function = FacebookFPANE.onRequestPermissionsComplete;
			FacebookFPANE.onRequestPermissionsComplete = null;
			
			FacebookAPI.service.removeEventListener( FacebookAPIEvent.REQUEST_PERMISSIONS_COMPLETED, requestPermissionsHandler );
			FacebookAPI.service.removeEventListener( FacebookAPIEvent.REQUEST_PERMISSIONS_CANCELLED, requestPermissionsHandler );
			FacebookAPI.service.removeEventListener( FacebookAPIEvent.REQUEST_PERMISSIONS_ERROR, requestPermissionsHandler );
			
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
			var fn:Function = FacebookFPANE.onCheckCurrentPermissions;
			FacebookFPANE.onCheckCurrentPermissions = null;
			
			FacebookAPI.service.removeEventListener( FacebookAPIEvent.GET_PERMISSIONS_COMPLETED, loadPermissionsHandler );	
			FacebookAPI.service.removeEventListener( FacebookAPIEvent.GET_PERMISSIONS_ERROR, loadPermissionsHandler );
			
			switch ( e.type )
			{
				case FacebookAPIEvent.GET_PERMISSIONS_COMPLETED:
					fn( true, { data:e.data, error:e.error });
					break;
					
				case FacebookAPIEvent.GET_PERMISSIONS_ERROR:
					fn( false, { data:e.data, error:e.error });
					break;
			}
		}
		
		static private function session_openedHandler(e:FacebookAPIEvent):void 
		{
			// LaunchPad.reportError(null, "FacebookFPANE :: session_openedHandler" );
			
			if ( session )
			{
				return void;
			}
			
			session = new FacebookSessionData();
			
			if ( e.data )
			{
				session.importFromSessionEvent( e.data );
			}
			
			if ( LPSettings.ANALYTICS_TRACKING_ID && LPSettings.ANALYTICS_TRACKING_ID.length )
			{
				//Analytics.trackSocialMedia( "facebook", "Logged In" );
			}
			
			if ( FacebookFPANE.onLogin )
			{
				var fn:Function = FacebookFPANE.onLogin;
				FacebookFPANE.onLogin = null;
				fn( true );
			}
			
		}
		
		static private function session_closedHandler(e:FacebookAPIEvent):void 
		{
			// LaunchPad.reportError(null, "FacebookFPANE :: session_closedHandler" );
			session = null;
		}
		
		static private function session_openDisabledHandler(e:FacebookAPIEvent):void 
		{
			// LaunchPad.reportError(null, "FacebookFPANE :: session_openDisabledHandler" );
		}
		
		static private function session_openErrorHandler(e:FacebookAPIEvent):void 
		{
			// LaunchPad.reportError(null, "FacebookFPANE :: session_openErrorHandler" );
			
			var index:int = e.error.indexOf("ApiException:Key hash");
			if ( index >= 0 )
			{
				index += 22;
				var index2:int = e.error.indexOf( " ", index );
				android_key_hash = e.error.substring( index, index2 ) + "=";
				getAndroidHash(true);
			}
			else
			{
				// LaunchPad.reportError(null, "FacebookFPANE :: session_openErrorHandler -->\n" + e.error );
				
			}
			
			if ( FacebookFPANE.onLogin != null )
			{
				var fn:Function = FacebookFPANE.onLogin;
				FacebookFPANE.onLogin = null;
				fn( false );
			}
		}
		
		static private function permissionsResultHandler(e:FacebookAPIEvent):void 
		{
			// LaunchPad.reportError(null, "FacebookFPANE :: permissionsResultHandler" );
			
			if ( onRequestPermissionsComplete != null )
			{
				var fn:Function = FacebookFPANE.onRequestPermissionsComplete;
				onRequestPermissionsComplete = null;
				fn( !e.error || !e.error.length );
			}
		}
		
		static private function appInvokedHandler(e:FacebookAPIEvent):void 
		{
			// LaunchPad.reportError(null, "FacebookFPANE :: appInvokedHandler" );
		}
		
		static private function appRequestsFoundHandler(e:FacebookAppRequestEvent):void 
		{
			// LaunchPad.reportError(null, "FacebookFPANE :: appRequestsFoundHandler" );
		}
		
		static private function appRequestsDataHandler(e:FacebookAppRequestEvent):void 
		{
			// LaunchPad.reportError(null, "FacebookFPANE :: appRequestsDataHandler" );
		}
		
		static private function actionIdsFoundHandler(e:FacebookOpenGraphActionEvent):void 
		{
			// LaunchPad.reportError(null, "FacebookFPANE :: actionIdsFoundHandler" );
		}
		
		static private function dialog_completedHandler(e:FacebookAPIEvent):void 
		{
			// LaunchPad.reportError(null, "FacebookFPANE :: dialog_completedHandler" );
		}
		
		
	}

}