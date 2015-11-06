package com.thirdsense.social 
{
	import com.freshplanet.ane.AirFacebook.Facebook
	import com.thirdsense.LaunchPad;
	import com.thirdsense.settings.LPSettings;
	import com.thirdsense.social.facebook.FacebookFriend;
	import com.thirdsense.social.facebook.FacebookSessionData;
	import com.thirdsense.social.utils.FPUploadPostHelper;
	import com.thirdsense.utils.Trig;
	import flash.display.BitmapData;
	import flash.display.PNGEncoderOptions;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	import starling.core.Starling;
	
	/**
	 * ...
	 * @author Ben Leffler
	 */
	
	public class FacebookFPANE 
	{
		private static var facebook:Facebook;
		private static var session:FacebookSessionData;
		private static var init_timeout:uint;
		private static var onLogin:Function;
		private static var onLogout:Function;
		private static var onGraph:Function;
		private static var onGetFriendsComplete:Function;
		private static var url_loader:URLLoader;
		private static var last_permissions:Array;
		
		public function FacebookFPANE() 
		{
			
		}
		
		public static function get isSupported():Boolean { return Facebook.isSupported };
		
		public static function init( onComplete:Function = null ):Boolean
		{
			if ( !facebook )
			{
				facebook = new Facebook();
				facebook.logEnabled = true;
				facebook.init( LPSettings.FACEBOOK_APP_ID );
				facebook.setUsingStage3D(Starling.current != null);
				
				if ( onComplete != null )
				{
					init_timeout = setTimeout( function() {
						trace( "FacebookFPANE :: init called first time this session - calling onComplete from setTimeout" );
						onComplete();
					}, 100 );
				}
				
				return true;
			}
			else
			{
				if ( onComplete != null )
				{
					init_timeout = setTimeout( function() {
						trace( "FacebookFPANE :: init was already called this session - calling onComplete from setTimeout" );
						onComplete();
					}, 100 );
				}
				
				return false;
			}
			
		}
		
		public static function login( onComplete:Function, readPermissions:Array = null ):void
		{
			trace( "FacebookFPANE :: login" );
			onLogin = onComplete;
			
			if ( !readPermissions )
			{
				readPermissions = Trig.copyArray( LPSettings.FACEBOOK_PERMISSIONS );
			}
			last_permissions = readPermissions;
			
			facebook.openSessionWithReadPermissions( readPermissions, loginHandler );
		}
		
		public static function requestPermissions( permissions:Array, onComplete:Function ):void
		{
			trace( "FacebookFPANE :: requestPermissions" );
			
			onLogin = onComplete;
			
			facebook.reauthorizeSessionWithPublishPermissions( permissions, requestPermissionHandler );
		}
		
		public static function getSession():FacebookSessionData
		{
			return session;
		}
		
		public static function getPermissions( onComplete:Function ):void
		{
			trace( "FacebookFPANE :: getPermissions" );
			
			onGraph = onComplete;
			facebook.requestWithGraphPath( "me/permissions", { fields:"permission" }, "GET", graphHandler );
		}
		
		public static function postToWall( picture:String, postName:String, link:String, caption:String, description:String, message:String = null, onComplete:Function = null ):Boolean
		{
			trace( "FacebookFPANE :: postToWall" );
			
			if ( !session ) return false;
			
			var post:Object = { name:postName, picture:picture, link:link, caption:caption, description:description };
			if ( message ) post.message = message;
			
			onGraph = onComplete;
			facebook.requestWithGraphPath( "me/feed", post, "POST", graphHandler );
			return true;
		}
		
		public static function logout( clearSession:Boolean = true, onComplete:Function = null ):void
		{
			if ( !facebook )
			{
				init();
			}
			
			facebook.closeSessionAndClearTokenInformation();
			
			if ( session )
			{
				session = null;
			}
			
			if ( onComplete != null )
			{
				setTimeout( onComplete, 1000 );
			}
		}
		
		public static function getFriendsList( onComplete:Function, fields:String = "picture,name,installed" ):void
		{
			onGraph = onGetFriends;
			onGetFriendsComplete = onComplete;
			facebook.requestWithGraphPath( "me/friends", { fields:fields }, "GET", graphHandler );
		}
		
		public static function openDialog( picture:String="", postName:String="", link:String="", caption:String="", description:String="", message:String="", onComplete:Function=null ):void
		{
			trace(FacebookFPANE + "openDialog");
			
			var obj:Object = {
				app_id:LPSettings.FACEBOOK_APP_ID
			}
			
			if ( picture.length ) obj.picture = picture;
			
			if ( postName.length ) obj.name = postName;
			
			if ( link.length ) obj.link = link;
			
			if ( caption.length ) obj.caption = caption;
			
			if ( description.length ) obj.description = description;
			
			if ( message.length ) obj.message = message;
			
			
			Facebook.getInstance().dialog( "feed", obj, onComplete );
			
			
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
			
			if ( !session )
			{
				return false;
			}
			
			onGraph = onComplete;
			
			var post:Object = {				
				message:message,
				no_story:false,
				access_token:session.accessToken
			}
			
			var bytes:ByteArray = bitmapdata.encode( bitmapdata.rect, new PNGEncoderOptions() );
			var url:String = "https://graph.facebook.com/me/photos";
			
			var url_request:URLRequest = new URLRequest();
			url_request.url = url;
			url_request.contentType = "multipart/form-data; boundary=" + FPUploadPostHelper.getBoundary();
			url_request.method = URLRequestMethod.POST;
			url_request.data = FPUploadPostHelper.getPostData( "photo_" + String(new Date().getTime()) + ".png", bytes, "source", post );
			
			url_loader = new URLLoader();
			url_loader.dataFormat = URLLoaderDataFormat.BINARY;
			url_loader.addEventListener(Event.COMPLETE, imageUploadHandler );
			url_loader.addEventListener(IOErrorEvent.IO_ERROR, imageUploadHandler );
			url_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, imageUploadHandler );
			
			try {
				url_loader.load(url_request);
			} catch (error : Error) {
				trace(error);
			}
			
			if ( disposeImage )
			{
				bitmapdata.dispose();
			}
			
			return true;
		}
		
		
		// ==========================================================================================
		
		private static function imageUploadHandler( e:Event ):void
		{
			e.currentTarget.removeEventListener(Event.COMPLETE, imageUploadHandler);
			e.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, imageUploadHandler);
			e.currentTarget.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, imageUploadHandler);
			
			var fn:Function = onGraph;
			onGraph = null;
			
			switch ( e.type )
			{
				case Event.COMPLETE:
					fn( true );
					break;
					
				case IOErrorEvent.IO_ERROR:
					fn( false );
					break;
					
				case SecurityErrorEvent.SECURITY_ERROR:
					fn( false );
					break;
			}
		}
		
		/**
		 * Call handlers
		 * @param	success
		 * @param	cancelled
		 * @param	error
		 */
		
		private static function loginHandler( success:Boolean, cancelled:Boolean, error:String = null ):void 
		{
			trace( "FacebookFPANE :: loginHandler" );
				
			if ( success && !cancelled && !error )
			{
				// Call out to get user data to fill session object
				onGraph = onGetMe;
				facebook.requestWithGraphPath( "me", {fields:"id,name,email,first_name,last_name"}, "GET", graphHandler );
			}
			else
			{
				if ( error )
				{
					trace( "FacebookFPANE :: loginHandler - Error reported as:", error );
				}
				else if ( cancelled )
				{
					trace( "FacebookFPANE :: loginHandler - User cancelled login" );
				}
				else
				{
					trace( "FacebookFPANE :: loginHandler - Login failed silently" );
				}
				
				var fn:Function = onLogin;
				onLogin = null;
				fn( false );
			}
		}
		
		private static function requestPermissionHandler( success:Boolean, cancelled:Boolean, error:String = null ):void 
		{
			trace( "FacebookFPANE :: requestPermissionHandler" );
			
			var fn:Function = onLogin;
			onLogin = null;
				
			if ( success && !cancelled && !error )
			{
				trace( "FacebookFPANE :: requestPermissionHandler - Successful" );
				fn( true, null );
			}
			else
			{
				if ( error )
				{
					trace( "FacebookFPANE :: requestPermissionHandler - Error reported as:", error );
					fn( false, { error:error } );
				}
				else if ( cancelled )
				{
					trace( "FacebookFPANE :: requestPermissionHandler - User cancelled permission request" );
					fn( false, { error:"User declined" } );
				}
				else
				{
					trace( "FacebookFPANE :: requestPermissionHandler - Request failed silently" );
					fn( false, { error:"Unknown" } );
				}
			}
		}
		
		private static function onGetMe( success:Boolean, data:Object ):void
		{
			if ( success )
			{
				session = new FacebookSessionData();
				session.accessToken = data.data.accessToken;
				session.email = data.data.email
				session.expiry = String(facebook.expirationTimestamp);
				session.firstName = data.data.first_name;
				session.lastName = data.data.last_name;
				session.userId = data.data.id;
				session.userName = data.data.name;
				
				var fn:Function = onLogin;
				onLogin = null;
				fn( success );
			}
			else
			{
				if ( data.error.code == 190 )
				{
					logout();
					login( onLogin, last_permissions );
				}
				else
				{
					fn = onLogin;
					onLogin = null;
					fn( false );
				}
			}
		}
		
		private static function onGetFriends( success:Boolean, data:Object ):void
		{
			trace ( "FacebookFPANE.onGetFriendsList :: Success = " + success );
			trace ( JSON.stringify(data) );
			
			if ( success )
			{
				FacebookFriend.processFromArray( data.data as Array );
				
			}
			
			var fn:Function = onGetFriendsComplete;
			onGetFriendsComplete = null;
			fn( success );
		}
		
		private static function graphHandler( data:Object ):void 
		{
			trace( "FacebookFPANE :: graphHandler - result:", JSON.stringify(data) );
			
			var fn:Function = onGraph;
			onGraph = null;
			
			if ( data.error )
			{
				if ( fn.length > 1 )
				{
					fn( false, { data:null, error:data.error } );
				}
				else
				{
					fn( false );
				}
			}
			else if ( data.body && data.body.error )
			{
				if ( fn.length > 1 )
				{
					fn( false, { data:null, error:data.body.error } );
				}
				else
				{
					fn( false );
				}
			}
			else
			{
				if ( fn.length > 1 )
				{
					if ( data.data )
					{
						fn( true, { data:data.data, error:null } );
					}
					else
					{
						fn( true, { data:data, error:null } );
					}
				}
				else
				{
					fn( true );
				}
			}
			
		}
	}

}