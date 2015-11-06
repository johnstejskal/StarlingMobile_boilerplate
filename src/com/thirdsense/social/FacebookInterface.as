package com.thirdsense.social 
{
	import com.facebook.graph.data.FacebookSession;
	import com.thirdsense.settings.LPSettings;
	import com.thirdsense.settings.Profiles;
	import com.thirdsense.social.facebook.FacebookConnection;
	import com.thirdsense.social.facebook.FacebookMobileConnection;
	import flash.display.BitmapData;
	import flash.utils.getDefinitionByName;
	
	/**
	 * <p>Allows both mobile and web integration of Facebook connectivity. Whilst oAuth requires differing approaches of connectivity
	 * depending on platform, this class consolidates functionality and allow a code once - deploy everywhere approach when it comes
	 * to Facebook Graph API integration.</p>
	 * <p>It is recommended that this class is to be used for all Facebook calls, no matter what platform you are developing for.</p>
	 * <p>The following is an example of a Facebook connection process for a starling based mobile app:</p>
	 * <listing>
	 * import com.thirdsense.social.FacebookInterface;
	 * import com.thirdsense.ui.starling.LPsWebBrowser;
	 * import com.thirdsense.social.facebook.FacebookFriend;
	 * import com.thirdsense.social.facebook.FacebookFriendField;
	 * 
	 * FacebookInterface.init( this.onFacebookConnect, false, false, LPsWebBrowser.invoke );
	 * 
	 * function onFacebookConnect( success:Boolean ):void
	 * {
	 * 	if ( success )
	 * 	{
	 * 		trace( "Facebook connection successful!" );
	 * 		FacebookInterface.getFriends( this.onGetFriends, [FacebookFriendField.INSTALLED, FacebookFriendField.EMAIL, FacebookFriendField.NAME] );
	 * 	}
	 * 	else
	 * 	{
	 * 		trace( "Facebook connection failed" );
	 * 	}
	 * }
	 * 
	 * function onGetFriends( success:Boolean ):void
	 * {
	 * 	if ( success )
	 * 	{
	 * 		trace( "Facebook friends retrieved" );
	 * 
	 * 		// Get the list of friends that have installed this application
	 * 		var installs:Vector&lt;FacebookFriend&gt; = FacebookFriend.getFriends(true);
	 * 		trace( installs );
	 * 	}
	 * 	else
	 * 	{
	 * 		trace( "Retrieval of Facebook friends failed" );
	 * 	}
	 * }
	 * </listing>
	 * 		
	 * @author Ben Leffler
	 */
	
	public class FacebookInterface 
	{
		/**
		 * @private Clears the mobile and web connection constructors from memory (Housekeeping)
		 */
		
		public static function clearConstructors():void
		{
			var constructors:Array = [ FacebookMobileConnection, FacebookConnection ];
		}
		
		/**
		 * Determines which Facebook class to utilize for communication. This is determined as a choice between Mobile or Web.
		 * @return	A class that will be used for communication to Facebook.
		 */
		
		private static function getClass():Class
		{
			if ( Profiles.mobile )
			{
				var type:String = "Mobile";
			}
			else
			{
				type = "";
			}
			
			var cl:Class = getDefinitionByName( "com.thirdsense.social.facebook.Facebook" + type + "Connection" ) as Class;
			return cl;
		}
		
		/**
		 * Initializes a Facebook connection to the project. This requires that the Facebook App ID has been set up in the LaunchPad config.xml file correctly.
		 * @param	onComplete	The callback function upon connection. This must accept a boolean parameter that indicates the connection success
		 * @param	force_new_login	Pass as true if you wish to force a new login (if a session is detected, user is auto-logged-out)
		 * @param	existing_session_only	If only a current session is to be used, pass this as true (does not allow a new log-in to occur)
		 * @param	invokeBrowser	If a customer browser or LPsWebBrowser interface is to be used, the function to call the browser should be passed through
		 * here (only compatible with mobile app and the function MUST return a StageWebView instance to be used)
		 * @see	flash.media.StageWebView
		 * @see	com.thirdsense.ui.starling.LPsWebBrowser
		 */
		
		public static function init( onComplete:Function=null, force_new_login:Boolean=false, existing_session_only:Boolean=false, invokeBrowser:Function = null ):void
		{
			var cl:Class = getClass();
			
			if ( Profiles.mobile )
			{
				cl.init( onComplete, force_new_login, existing_session_only, invokeBrowser );
			}
			else
			{
				cl.init( onComplete, force_new_login, existing_session_only );
			}
		}
		
		/**
		 * Calls to Facebook to retrieve the current user (Only compatible with web app)
		 * @param	onComplete	A callback function that accepts a boolean response (to indicate success). You can then call FacebookFriend.getMe() to retrieve the new data.
		 */
		
		public static function getCurrentUser( onComplete:Function = null ):void
		{
			if ( !Profiles.mobile ) getClass().getUser( onComplete );
		}
		
		/**
		 * Places a call to Facebook to retrieve a user's friends list
		 * @param	onComplete	The callback function upon completion. This must accept a boolean parameter that indicates the calls success.
		 * @param	fields	An array of field names to include in the data set that Facebook sends back. Leaving this a null will retrieve name and installed fields only.
		 */
		
		public static function getFriends( onComplete:Function = null, fields:Array = null ):void
		{
			var cl:Class = getClass();
			cl.getFriends( onComplete, fields );
		}
		
		/**
		 * Calls a log out of the current Facebook session.
		 * @param	onComplete	Callback function that accepts a boolean parameter that indicates the call success.
		 */
		
		public static function logout( onComplete:Function ):void
		{
			var cl:Class = getClass();
			cl.logout( onComplete );
		}
		
		/**
		 * Indicates if the project is currently connected to Facebook.
		 * @return	Boolean response
		 */
		
		public static function isConnected():Boolean
		{
			var cl:Class = getClass();
			return cl.isConnected();
		}
		
		/**
		 * Retrieves the current user Facebook session
		 * @return	FacebookSession object. Some fields will not be populated if this is called from a web based project.
		 */
		
		public static function getUserSession():FacebookSession
		{
			var cl:Class = getClass();
			return cl.getUserSession();
		}
		
		/**
		 * Obtains a user's 50x50 pixel Facebook avatar.
		 * @param	onComplete	The callback function that must accept a Bitmap object of the resulting avatar upon load.
		 * @param	fbUserId	The Facebook user id to obtain the avatar of. If left as the default blank string, the currently connected user's avatar will be called.
		 * @return	Boolean value that indicates if the call was made successfully. This will be false if a Facebook connection hasn't been made before this call.
		 */
		
		public static function getUserAvatar( onComplete:Function, fbUserId:String = "" ):Boolean
		{
			var cl:Class = getClass();
			return cl.getUserAvatar(onComplete, fbUserId);
		}
		
		/**
		 * Posts a picture and message to the currently connected user's Facebook wall
		 * @param	picture		An image to attach to the post. If left as a blank string, LaunchPad will attempt to use the image defined in the config.xml
		 * @param	postName	The name of the post
		 * @param	link		The link that will open when users click on the post name. If left as a blank string, LaunchPad will attempt to use the url defined in the config.xml
		 * @param	caption		The text that sits right afer the post name
		 * @param	description	The text that sits right afer the post caption
		 * @param	message		An optional field that was be used to add a message typed by the user
		 * @param	onComplete	The function to return the result of the post to. Function must include a parameter that accepts a boolean value - true if successful, false otherwise
		 * @return	A boolean value to indicate if the call was made. It will return false if a Facebook connection hasn't been made before this call.
		 */
		
		public static function postToWall(picture:String, postName:String, link:String, caption:String, description:String, message:String = null, onComplete:Function = null):Boolean
		{
			if ( !isConnected() )
			{
				return false;
			}
			
			if ( !picture.length && LPSettings.FACEBOOK_WALLPIC_URL.length ) picture = LPSettings.FACEBOOK_WALLPIC_URL;
			if ( !link.length && LPSettings.FACEBOOK_WALLPIC_URL.length ) link = LPSettings.FACEBOOK_REDIRECT_URL;
			
			var cl:Class = getClass();
			return cl.postToWall( picture, postName, link, caption, description, message, onComplete );
		}
		
		/**
		 * Allows the currently connected Facebook user to invite friends to the application. (Web app users must have pop-ups enabled for this call to not be blocked)
		 * @param	message	The message to append to the invitation
		 * @param	prompt_title	The title of the prompt that the user will see when asked to select the friends to invite
		 */
		
		public static function inviteFriends( message:String, prompt_title:String ):void
		{
			var cl:Class = getClass();
			cl.inviteFriends( message, prompt_title );
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
			var cl:Class = getClass();
			return cl.uploadLocalImage( bitmapdata, message, onComplete, disposeImage );
		}
		
	}

}