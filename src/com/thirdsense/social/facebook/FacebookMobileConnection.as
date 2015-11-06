package com.thirdsense.social.facebook 
{
	import com.facebook.graph.data.FacebookSession;
	import com.facebook.graph.FacebookMobile;
	import com.thirdsense.LaunchPad;
	import com.thirdsense.net.Analytics;
	import com.thirdsense.settings.LPSettings;
	import com.thirdsense.utils.SmoothImageLoad;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.LocationChangeEvent;
	import flash.geom.Rectangle;
	import flash.media.StageWebView;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	/**
	 * @private	Handles Facebook connectivity for mobile based applications
	 * @author Ben Leffler
	 */
	
	public class FacebookMobileConnection 
	{
		private static var swv:StageWebView;
		private static var connected:Boolean;
		private static var onComplete:Function;
		private static var onLogoutComplete:Function;
		private static var force_new:Boolean;
		private static var auto_only:Boolean;
		private static var callBrowser:Function;
		private static var container:MovieClip;
		private static var onAvatarLoad:Function;
		private static var onWallPost:Function;
		private static var phase:int = 0;
		static private var onUploadComplete:Function;
		
		/**
		 * Initializes a connection to the Facebook API and begins the login process. Facebook permissions are set up in the LaunchPad config.xml file.
		 * @param	onComplete	Function that gets called upon a result of this process
		 * @param	force_new_login	Pass as true if you wish to force a new Facebook login (instead of using an existing session)
		 * @param	auto_login_only	Pass as true if you only wish to use an existing saved session
		 * @param	browserInvoke	If you wish to use a custom browser window, pass the browser invoke function. This function MUST return a StageWebView object.
		 * @see	com.thirdsense.ui.starling.LPsWebBrowser
		 * @see	flash.media.StageWebView
		 */
		
		public static function init( onComplete:Function=null, force_new_login:Boolean=false, auto_login_only:Boolean=false, browserInvoke:Function=null ):void
		{
			force_new = force_new_login;
			auto_only = auto_login_only;
			if ( browserInvoke != null )
			{
				callBrowser = browserInvoke;
				//swv = callBrowser();
			}
			
			var appId:String = LPSettings.FACEBOOK_APP_ID;
			
			if ( onComplete != null ) {
				FacebookMobileConnection.onComplete = onComplete;
			}
			
			FacebookMobile.init( appId, onFacebookInit );
			
			phase = 0;
		}
		
		/**
		 * @private	Init handler
		 */
		
		private static function onFacebookInit( success:Object, fail:Object ):void
		{
			phase = 1;
			
			if ( (!success || success == null) && !auto_only ) {
				
				if ( callBrowser == null )
				{
					swv = new StageWebView();
					swv.viewPort = new Rectangle( 10, 10, LaunchPad.instance.nativeStage.stageWidth - 20, LaunchPad.instance.nativeStage.stageHeight - 20 );
					swv.stage = LaunchPad.instance.nativeStage;
				}
				else
				{
					swv = callBrowser();
				}
				
				FacebookMobile.login( onFacebookLogin, LaunchPad.instance.nativeStage, LPSettings.FACEBOOK_PERMISSIONS, swv );
				
				return void;
				
			}
			else if ( force_new && !auto_only )
			{
				logout( FacebookMobileConnection.init );
			}
			else
			{
				onFacebookLogin(success, null);
			}
			
		}
		
		/**
		 * @private	Facebook login handler
		 */
		
		private static function onFacebookLogin( success:Object, fail:Object ):void
		{
			( success == null || !success ) ? connected = false : connected = true;
			
			if ( success )
			{
				trace( "Connected to Facebook as user: " + FacebookMobile.getSession().user.name );
				
				if ( LPSettings.ANALYTICS_TRACKING_ID && LPSettings.ANALYTICS_TRACKING_ID.length )
				{
					//Analytics.trackSocialMedia( "facebook", "connected" );
				}
			}
			else
			{
				trace( "Connection to Facebook failed. No existing session data" );
			}
			
			if ( FacebookMobileConnection.onComplete != null && phase > 0 ) {
				var fn:Function = FacebookMobileConnection.onComplete;
				FacebookMobileConnection.onComplete = null;
				fn(connected);
			}
		}
		
		/**
		 * Because of oAuth issues, FacebookMobile.logout no longer works. This function is a hack way of forcing a logout and is not likely to work forever (once Facebook inevitably updates it's HTML structure)
		 * @param	onComplete	The function to call upon a successful logout
		 */
		
		public static function logout( onComplete:Function ):void
		{
			if ( !getUserSession() )
			{
				onComplete( true );
				return void;
			}
			
			FacebookMobileConnection.onLogoutComplete = onComplete;
			
			swv = new StageWebView();
			swv.viewPort = new Rectangle( -1, 0, 1, 1 );
			swv.stage = LaunchPad.instance.nativeStage;
			swv.loadURL( "https://m.facebook.com/logout.php?confirm=1&next=http://www.facebook.com/&access_token=" + getUserSession().accessToken );
			swv.addEventListener( Event.COMPLETE, logoutHandler, false, 0, true );
		}
		
		/**
		 * @private	Hacky Facebook logout handler
		 */
		
		private static function logoutHandler( evt:Event ):void
		{
			swv.removeEventListener( Event.COMPLETE, logoutHandler );
			swv.stage = null;
			swv.dispose();
			connected = false;
			
			var url:String = "https://m.facebook.com/dialog/permissions.request?app_id="+ LPSettings.FACEBOOK_APP_ID +"&display=touch&next=http://www.facebook.com/&type=user_agent&perms=email&fbconnect=1";
			FacebookMobile.logout( onFacebookLogout, url );
			
		}
		
		/**
		 * @private	Hacky Facebook logout handler part deux
		 */
		
		private static function onFacebookLogout( success:Boolean ):void
		{
			trace( "onFacebookLogout" );
			
			FacebookMobileConnection.connected = false;
			
			var fn:Function = FacebookMobileConnection.onLogoutComplete;
			FacebookMobileConnection.onLogoutComplete = null;
			fn( true );
		}
		
		/**
		 * Obtains a Facebook connection status
		 * @return	True if currently connected
		 */
		
		public static function isConnected():Boolean
		{
			if ( connected ) {
				return true;
			} else {
				return false;
			}
		}
		
		/**
		 * Obtains the currently connected user's Facebook friends
		 * @param	onComplete	The function to call upon a result. Must accept a boolean value that indicates success
		 * @param	fields	The fields to include in the result data packet from Facebook. If left as null, FacebookFriendField.INSTALLED and FacebookFriendField.NAME are used
		 * @see com.thirdsense.social.facebook.FacebookFriend
		 * @see	com.thirdsense.social.facebook.FacebookFriendField
		 */
		
		public static function getFriends( onComplete:Function, fields:Array=null ):void
		{
			FacebookMobileConnection.onComplete = onComplete;
			
			var session:FacebookSession = FacebookMobile.getSession();
			if ( session )
			{
				if ( fields )
				{
					var field_str:String = fields.join(",");
				}
				else
				{
					field_str = "installed,name";
				}
				
				FacebookMobile.api( "/me/friends", onGetFriends, { fields:field_str } );
				
				var user:Object = session.user;
				var friend:FacebookFriend = new FacebookFriend();
				friend.id = user.id;
				friend.name = user.name;
				friend.installed = true;
				for ( var str:String in user )
				{
					if ( !friend[str] )
					{
						friend[str] = user[str];
					}
				}
				FacebookFriend.addMe( friend );
			}
			else
			{
				trace( "LaunchPad", FacebookMobileConnection, "Error calling getFriends. You must be connecte to Facebook first in order to call this" );
				onGetFriends( null, true );
			}
			
		}
		
		/**
		 * @private	Handler for getFriends
		 */
		
		private static function onGetFriends( success:Object, fail:Object ):void
		{
			var fn:Function = FacebookMobileConnection.onComplete;
			FacebookMobileConnection.onComplete = null;
			
			if ( success != null )
			{
				FacebookFriend.processFromArray( success as Array );
			}
			
			fn( (success != null) );
			
		}
		
		/**
		 * Allows the currently connected Facebook user to invite friends to the application
		 * @param	message	The message to append to the invitation
		 * @param	prompt_title	The title of the prompt that the user will see when asked to select the friends to invite
		 */
		
		public static function inviteFriends( message:String, prompt_title:String ):void
		{
			var url:String = "https://www.facebook.com/dialog/apprequests?";
			url += "app_id=" + LPSettings.FACEBOOK_APP_ID;
			url += "&message=" + escape( message );
			url += "&redirect_uri=" + LPSettings.FACEBOOK_REDIRECT_URL;
			url += "&title=" + escape( prompt_title );
			url += "&display=touch";
			
			swv = new StageWebView();
			swv.viewPort = new Rectangle( 10, 10, LaunchPad.instance.nativeStage.stageWidth - 20, LaunchPad.instance.nativeStage.stageHeight - 20 );
			swv.stage = LaunchPad.instance.nativeStage;
			swv.assignFocus();
			swv.loadURL( url );
			
			swv.addEventListener( LocationChangeEvent.LOCATION_CHANGE, inviteFriendsHandler, false, 0, true);
			
		}
		
		/**
		 * @private	Invite friends handler. Closes the StageWebView instance down when the redirect location has been detected (as set up in config.xml)
		 */
		
		private static function inviteFriendsHandler(evt:*):void
		{
			trace( "inviteFriendsHandler :", evt.location );
			
			if ( !evt.location.indexOf(LPSettings.FACEBOOK_REDIRECT_URL) && swv ) {
				swv.removeEventListener( LocationChangeEvent.LOCATION_CHANGE, inviteFriendsHandler );
				swv.dispose();
				swv = null;
				
				if ( LPSettings.ANALYTICS_TRACKING_ID && LPSettings.ANALYTICS_TRACKING_ID.length )
				{
					//Analytics.trackSocialMedia( "facebook", "inviteFriends" );
				}
			}
		}
		
		/**
		 * Retrieves the current user session
		 * @return	FacebookSession object, fully populated
		 */
		
		public static function getUserSession():FacebookSession
		{
			return FacebookMobile.getSession();
		}
		
		/**
		 * Loads a user's 50x50 pixel Facebook avatar
		 * @param	onComplete	The function to call upon a result. Must accept a Bitmap object as it's parameter. This will be passed as null if the call failed
		 * @param	fbUserId	The requested Facebook user id. If left as a blank string, the currently logged in user's id is passed.
		 * @return	A boolean value that indicates if the call was successfully made
		 */
		
		public static function getUserAvatar( onComplete:Function, fbUserId:String="" ):Boolean
		{
			var session:FacebookSession = getUserSession();
			if ( session || fbUserId.length )
			{
				onAvatarLoad = onComplete;
				if ( !fbUserId.length )
				{
					fbUserId = session.uid;
				}
				
				container = new MovieClip();
				container.addEventListener(Event.COMPLETE, fbUserAvatarLoaded, false, 0, true);
				container.addEventListener(SmoothImageLoad.CANCEL_LOAD, cancelFbUserAvatarLoad, false, 0, true);
				SmoothImageLoad.imageLoad( "https://graph.facebook.com/" + fbUserId + "/picture?type=square", container, 50, 50, SmoothImageLoad.EXACT, true, true );
				return true;
			}
			else
			{
				return false;
			}
		}
		
		/**
		 * @private	Avatar load cancelled handler. Usually triggered by calling SmoothImageLoad.killCue()
		 */
		
		private static function cancelFbUserAvatarLoad( evt:Event ):void
		{
			var container:MovieClip = evt.currentTarget as MovieClip;
			container.removeEventListener(Event.COMPLETE, fbUserAvatarLoaded);
			container.removeEventListener(SmoothImageLoad.CANCEL_LOAD, cancelFbUserAvatarLoad);
			
			var fn:Function = onAvatarLoad;
			onAvatarLoad = null;
			fn( null );
			
		}
		
		/**
		 * @private	Avatar loaded handler. Passes the result through to the onAvatarLoad function as a Bitmap object and disposes of the local bitmapData object
		 */
		
		private static function fbUserAvatarLoaded( evt:Event ):void
		{
			var container:MovieClip = evt.currentTarget as MovieClip;
			container.removeEventListener(Event.COMPLETE, fbUserAvatarLoaded);
			container.removeEventListener(SmoothImageLoad.CANCEL_LOAD, cancelFbUserAvatarLoad);
			
			var bmp:Bitmap = new Bitmap( (container.getChildAt(0) as Bitmap).bitmapData.clone(), "auto", true );
			(container.getChildAt(0) as Bitmap).bitmapData.dispose();
			(container.getChildAt(0) as Bitmap).bitmapData = null
			container = null;
			
			var fn:Function = onAvatarLoad;
			onAvatarLoad = null;
			fn( bmp );
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
			
			if ( !FacebookMobile.getSession() )
			{
				return false;
			}
			
			var post:Object = {
				source:bitmapdata,
				fileName:"img_" + Math.round(Math.random()*10000) + ".png",
				message:message,
				no_story:false
			}
			
			onUploadComplete = onComplete;
			
			FacebookMobile.api( "me/photos", onUploadLocalImage, post, "POST" );
			
			if ( disposeImage )
			{
				bitmapdata.dispose();
			}
			
			return true;
		}
		
		/**
		 * @private	Handler for the Facebook Image post call
		 */
		
		static private function onUploadLocalImage( result:Object, fail:Object ):void 
		{
			if ( result )
			{
				trace( "Upload of image to Facebook reported as successful" );
				
				if ( LPSettings.ANALYTICS_TRACKING_ID && LPSettings.ANALYTICS_TRACKING_ID.length )
				{
					//Analytics.trackSocialMedia( "facebook", "uploadImage" );
				}
			}
			else
			{
				trace( "Upload of image to Facebook failed. Error report:" );
				
				var str:String = JSON.stringify(fail);
				str += "------ END REPORT ------";
				trace( str );
			}
			
			if ( onUploadComplete != null )
			{
				var fn:Function = onUploadComplete;
				onUploadComplete = null;
				fn( (result != null) );
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
			trace( "Attempting to post to Facebook wall" );
			
			if ( !FacebookMobile.getSession() ) return false;
			
			var post:Object = { name:postName, picture:picture, link:link, caption:caption, description:description };
			onWallPost = onComplete;
			
			if ( message ) post.message = message;
			
			FacebookMobile.api("/me/feed", onFacebookPost, post, "POST");
			
			return true;
		}
		
		/**
		 * @private	Handler for the postToWall call
		 */
		
		private static function onFacebookPost(result:Object, fail:Object):void
		{
			if ( result )
			{
				trace( "Post to Facebook wall reported as successful" );
				
				if ( LPSettings.ANALYTICS_TRACKING_ID && LPSettings.ANALYTICS_TRACKING_ID.length )
				{
					//Analytics.trackSocialMedia( "facebook", "postToWall" );
				}
			}
			else
			{
				trace( "Post to Facebook wall reported as a failure. Error report:" );
				var str:String = JSON.stringify(fail);
				str += "------ END REPORT ------";
				trace( str );
			}
			
			if ( onWallPost != null ) {
				
				var fn:Function = onWallPost;
				onWallPost = null;
				
				fn( (result != null) );
				
			}
		}
		
	}

}