package com.thirdsense.social.facebook 
{
	import com.facebook.graph.data.FacebookAuthResponse;
	import com.facebook.graph.data.FacebookSession;
	import com.facebook.graph.Facebook;
	import com.thirdsense.net.Analytics;
	import com.thirdsense.settings.LPSettings;
	import com.thirdsense.utils.SmoothImageLoad;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.utils.setTimeout;
	
	/**
	 * @private	Handles Facebook connectivity functionality for web based projects
	 * @author Ben Leffler
	 */
	
	public class FacebookConnection 
	{
		private static var onComplete:Function;
		private static var onLogoutComplete:Function;
		private static var force_new:Boolean;
		private static var auto_only:Boolean;
		private static var appId:String;
		private static var connected:Boolean;
		private static var phase:int;
		private static var onAvatarLoad:Function;
		private static var onWallPost:Function;
		private static var container:MovieClip;
		private static var ping:uint;
		private static var ping_counter:int;
		static private var onUploadComplete:Function;
		
		/**
		 * Initializes a connection to the Facebook API and begins the login process
		 * @param	onComplete	A function to call back to upon a login result. Must accept a boolean param that indicates the success of the login
		 * @param	force_new_login	If a new login is to be called, pass this as true
		 * @param	auto_login_only	To check for and use an existing session from the browser cookies, pass this as true
		 */
		
		public static function init( onComplete:Function=null, force_new_login:Boolean=false, auto_login_only:Boolean=false ):void
		{
			if ( ExternalInterface.available )
			{
				trace( "FacebookConnection.init" );
				
				FacebookConnection.appId = LPSettings.FACEBOOK_APP_ID;
				
				FacebookConnection.force_new = force_new_login;
				FacebookConnection.auto_only = auto_login_only;
				
				if ( onComplete != null )	FacebookConnection.onComplete = onComplete;
				
				Facebook.init( FacebookConnection.appId, FacebookConnection.onFacebookInit );
				
				phase = 0;
			}
			else
			{
				trace( "Call to Facebook.init failed as there is no external interface available" );
				onComplete(false);
			}
		}
		
		/**
		 * @private
		 */
		
		private static function onFacebookInit( success:Object, fail:Object ):void
		{
			trace( "FacebookConnection.onFacebookInit", success, fail );
			
			if ( success && success.uid == null )
			{
				success = null;
			}
			
			phase = 1;
			
			if ( success == null && !FacebookConnection.auto_only )
			{
				trace( "FacebookConnection.onFacebookInit - calling for login" );
				
				Facebook.login( FacebookConnection.onFacebookLogin, { scope:String(LPSettings.FACEBOOK_PERMISSIONS) } );
			}
			else if ( FacebookConnection.force_new && !FacebookConnection.auto_only )
			{
				trace( "FacebookConnection.onFacebookInit - calling for logout" );
				FacebookConnection.logout( FacebookConnection.init );
			}
			else
			{
				FacebookConnection.onFacebookLogin( success, null );
			}
		}
		
		/**
		 * Calls a logout of an existing Facebook session
		 * @param	onComplete	The function to call back to. Must accept a boolean value that indicates the success of the call
		 */
		
		public static function logout( onComplete:Function ):void
		{
			if ( onComplete != null )	FacebookConnection.onLogoutComplete = onComplete;
			
			Facebook.logout( FacebookConnection.onFacebookLogout );
		}
		
		/**
		 * @private
		 */
		
		private static function onFacebookLogin( success:Object, fail:Object ):void
		{
			trace( "FacebookConnection.onFacebookLogin", success, fail );
			
			if ( success && success.uid == null )
			{
				success = null;
			}
			
			FacebookConnection.connected = (success != null);
			
			if ( FacebookConnection.connected )
			{
				var session:FacebookSession = FacebookConnection.getUserSession();
				if ( session && session.user )
				{
					trace( "Connected to Facebook as user: " + session.user.name );
				}
				else if ( session )
				{
					trace( "Connected to Facebook as user id: " + session.uid );
				}
				else
				{
					trace( "Connect to Facebook, but user details unavailable for some reason" );
				}
			}
			else
			{
				trace( "Connection to Facebook failed. No existing session data" );
			}
			
			if ( !success && !fail && !auto_only )
			{
				trace( "Starting session ping" );
				ping = setTimeout( pingSession, 3000 );
				ping_counter = 30;
			}
			else if ( FacebookConnection.onComplete != null && FacebookConnection.phase > 0 )
			{
				if ( !FacebookConnection.connected )
				{
					var fn:Function = FacebookConnection.onComplete;
					FacebookConnection.onComplete = null;
					fn( FacebookConnection.connected );
				}
				else
				{
					FacebookConnection.getUser( FacebookConnection.onComplete );
					
					if ( LPSettings.ANALYTICS_TRACKING_ID && LPSettings.ANALYTICS_TRACKING_ID.length )
					{
						//Analytics.trackSocialMedia( "facebook", "connected" );
					}
				}
			}
		}
		
		/**
		 * @private	The Facebook API for some reason doesn't call back upon connection. This pings the session until a connection is found or until it times out
		 */
		
		private static function pingSession():void
		{
			var session:FacebookSession = getUserSession();
			if ( !session.uid )
			{
				ping_counter--;
				if ( ping_counter ) 
				{
					trace( "Session pinged. No connection yet" );
					ping = setTimeout( pingSession, 3000 );
					return void;
				}
				else
				{
					trace( "Session pinged. No connection and timed out. Login failed." );
					FacebookConnection.connected = false;
					
					var fn:Function = FacebookConnection.onComplete;
					FacebookConnection.onComplete = null;
					fn( FacebookConnection.connected );
				}
			}
			else
			{
				trace( "Session pinged. Connection found!" );
				FacebookConnection.connected = true;
				
				if ( LPSettings.ANALYTICS_TRACKING_ID && LPSettings.ANALYTICS_TRACKING_ID.length )
				{
					//Analytics.trackSocialMedia( "facebook", "connected" );
				}
				
				// Upon a connection, calls to get user as FacebookSession object doesn't auto-populate with user details like it does in the mobile version.
				
				FacebookConnection.getUser( FacebookConnection.onComplete );
			}
			
		}
		
		/**
		 * Retrieves a severly depleted version of a FacebookSession object. Only the auth response, access token and uid is populated in this object
		 * @return	A FacebookSession object (severly depleted)
		 */
		
		public static function getUserSession():FacebookSession
		{
			if ( FacebookConnection.connected || Facebook.getAuthResponse() )
			{
				var session:FacebookSession = new FacebookSession();
				var auth:FacebookAuthResponse = Facebook.getAuthResponse();
				session.accessToken = auth.accessToken;
				session.uid = auth.uid;
				return session;
			} 
			else
			{
				return null;
			}
		}
		
		/**
		 * @private	Called on a Facebook logout being successful
		 */
		
		private static function onFacebookLogout():void
		{
			FacebookFriend.clear();
			FacebookConnection.connected = false;
			
			if ( FacebookConnection.onLogoutComplete != null )
			{
				var fn:Function = FacebookConnection.onLogoutComplete;
				FacebookConnection.onLogoutComplete = null;
				fn();
			}
			
		}
		
		/**
		 * Checks if the app has been Facebook connected
		 * @return
		 */
		
		public static function isConnected():Boolean
		{
			return ( FacebookConnection.connected == true );
			
		}
		
		/**
		 * Retrieves the connected Facebook user's friend list an populates the FacebookFriend class with resulting data
		 * @param	onComplete	The function to call back to. Must accept a boolean parameter that indicates the success of the call
		 * @param	fields	The fields to include in the result data packet from Facebook. If left as null, FacebookFriendField.INSTALLED and FacebookFriendField.NAME are used
		 * @see com.thirdsense.social.facebook.FacebookFriend
		 * @see	com.thirdsense.social.facebook.FacebookFriendField
		 */
		
		public static function getFriends( onComplete:Function, fields:Array = null ):void
		{
			FacebookConnection.onComplete = onComplete;
			
			var session:FacebookSession = FacebookConnection.getUserSession();
			
			if ( session )
			{
				if ( fields )
				{
					var field_str:String = fields.join(",");
				}
				else
				{
					field_str = "installed,name"
				}
				
				Facebook.api( "/me/friends", onGetFriends, { fields:field_str } );
				
				
				if ( session.user && !FacebookFriend.getMe() )
				{
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
			}
			else
			{
				trace( "LaunchPad", FacebookConnection, "Error calling getFriends. You must be connecte to Facebook first in order to call this" );
				onGetFriends( null, true );
			}
			
		}
		
		/**
		 * @private	Called on a result from a getFriends retrieval. If successful, the FacebookFriend class is populated with data.
		 */
		
		private static function onGetFriends( success:Object, fail:Object ):void
		{
			var fn:Function = FacebookConnection.onComplete;
			FacebookConnection.onComplete = null;
			
			if ( success != null )
			{
				FacebookFriend.processFromArray( success as Array );
			}
			
			fn( (success != null) );
			
		}
		
		/**
		 * Retrieves the current Facebook user's available data
		 * @param	onComplete	The function that gets called on a result. Must accept a boolean parameter that indicates the call's success.
		 */
		
		public static function getUser( onComplete:Function ):void
		{
			FacebookConnection.onComplete = onComplete;
			Facebook.api( "me", onGetUser );
			
		}
		
		/**
		 * @private	Handler for the getUser call. If successful, a FacebookFriend object is populated with the user's data and added to the class.
		 */
		
		private static function onGetUser( success:Object, fail:Object ):void
		{
			var fn:Function = FacebookConnection.onComplete;
			FacebookConnection.onComplete = null;
			
			if ( success != null )
			{
				var friend:FacebookFriend = new FacebookFriend();
				friend.installed = true;
				
				for ( var str:String in success )
				{
					//ignore any unexpected fields
					try
					{
						friend[str] = success[str];
					}
					catch (e:*)
					{
						
					}
				}				
				FacebookFriend.addMe( friend );
			}
			
			fn( (success != null) );
		}
		
		/**
		 * Loads a user's 50x50 pixel Facebook avatar
		 * @param	onComplete	The function to call upon a result. Must accept a Bitmap object as it's parameter. This will be passed as null if the call failed
		 * @param	fbUserId	The requested Facebook user id. If left as a blank string, the currently logged in user's id is passed.
		 * @return	A boolean value that indicates if the call was successfully made
		 */
		
		public static function getUserAvatar( onComplete:Function, fbUserId:String="" ):Boolean
		{
			var session:FacebookSession = FacebookConnection.getUserSession();
			if ( session || fbUserId.length )
			{
				FacebookConnection.onAvatarLoad = onComplete;
				
				if ( !fbUserId.length )
				{
					fbUserId = session.uid;
				}
				
				container = new MovieClip();
				container.addEventListener(Event.COMPLETE, FacebookConnection.fbUserAvatarLoaded, false, 0, true);
				container.addEventListener(SmoothImageLoad.CANCEL_LOAD, FacebookConnection.cancelFbUserAvatarLoad, false, 0, true);
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
			container.removeEventListener(Event.COMPLETE, FacebookConnection.fbUserAvatarLoaded);
			container.removeEventListener(SmoothImageLoad.CANCEL_LOAD, FacebookConnection.cancelFbUserAvatarLoad);
			
			var fn:Function = FacebookConnection.onAvatarLoad;
			FacebookConnection.onAvatarLoad = null;
			fn( null );
			
		}
		
		/**
		 * @private	Avatar loaded handler. Passes the result through to the onAvatarLoad function as a Bitmap object and disposes of the local bitmapData object
		 */
		
		private static function fbUserAvatarLoaded( evt:Event ):void
		{
			var container:MovieClip = evt.currentTarget as MovieClip;
			container.removeEventListener(Event.COMPLETE, FacebookConnection.fbUserAvatarLoaded);
			container.removeEventListener(SmoothImageLoad.CANCEL_LOAD, FacebookConnection.cancelFbUserAvatarLoad);
			
			var bmp:Bitmap = new Bitmap( (container.getChildAt(0) as Bitmap).bitmapData.clone(), "auto", true );
			(container.getChildAt(0) as Bitmap).bitmapData.dispose();
			(container.getChildAt(0) as Bitmap).bitmapData = null
			container = null;
			
			var fn:Function = FacebookConnection.onAvatarLoad;
			FacebookConnection.onAvatarLoad = null;
			fn( bmp );
		}
		
		/**
		* Posts to the currently connected user's Facebook wall
		 * 
		 * @param	picture		An image to attach to the post
		 * @param	postName	The name of the post
		 * @param	link		The link that will open when users click on the post name
		 * @param	caption		The text that sits right afer the post name
		 * @param	description	The text that sits right afer the post caption
		 * @param	message		An optional field that was be used to add a message typed by the user
		 * @param	onComplete	The function to return the result of the post to. Function must include a parameter that accepts a boolean value - true if successful, false otherwise
		 * 
		 * @return
		 */
		
		public static function postToWall(picture:String, postName:String, link:String, caption:String, description:String, message:String = null, onComplete:Function=null):Boolean
		{
			if ( !FacebookConnection.getUserSession() ) return false;
			
			var post:Object = { name:postName, picture:picture, link:link, caption:caption, description:description };
			FacebookConnection.onWallPost = onComplete;
			
			if ( message ) post.message = message;
			
			Facebook.api("/me/feed", FacebookConnection.onFacebookPost, post, "POST");
			
			return true;
		}
		
		/**
		 * @private	Handler for the Facebook wall post call
		 */
		
		private static function onFacebookPost(result:Object, fail:Object):void
		{
			if ( result != null )
			{
				if ( LPSettings.ANALYTICS_TRACKING_ID && LPSettings.ANALYTICS_TRACKING_ID.length )
				{
					//Analytics.trackSocialMedia( "facebook", "postToWall" );
				}
			}
			
			if ( FacebookConnection.onWallPost != null ) {
				
				var fn:Function = FacebookConnection.onWallPost;
				FacebookConnection.onWallPost = null;
				
				fn( (result != null) );
				
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
			
			if ( !FacebookConnection.getUserSession() )
			{
				return false;
			}
			
			var post:Object = {
				source:bitmapdata,
				fileName:"img_" + Math.round(Math.random()*10000) + ".png",
				message:message,
				no_story:false
			}
			
			FacebookConnection.onUploadComplete = onComplete;
			
			Facebook.api( "me/photos", onUploadLocalImage, post, "POST" );
			
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
			
			navigateToURL( new URLRequest(url), "_blank" );
			
			if ( LPSettings.ANALYTICS_TRACKING_ID && LPSettings.ANALYTICS_TRACKING_ID.length )
			{
				//Analytics.trackSocialMedia( "facebook", "inviteFriends" );
			}
		}
		
	}

}