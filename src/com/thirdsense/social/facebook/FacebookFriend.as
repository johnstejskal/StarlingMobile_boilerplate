package com.thirdsense.social.facebook 
{
	import com.thirdsense.utils.getClassVariables;
	import com.thirdsense.utils.StringTools;
	import flash.display.BitmapData;
	import singleton.Core;
	
	/**
	 * Facebook Friends data that in most cases will be populated upon a call to FacebookInterface.getFriends
	 * @author Ben Leffler
	 */
	
	public dynamic class FacebookFriend 
	{
		public var id:String;
		public var name:String;
		public var first_name:String;
		public var last_name:String;
		public var email:String;
		public var gender:String;
		public var username:String;
		public var link:String;
		public var updated_time:String;
		public var hometown:Object;
		public var timezone:int;
		public var location:Object;
		public var verified:Boolean;
		public var locale:String;
		public var installed:Boolean;
		private var isMe:Boolean;
		
		private static var friends:Vector.<FacebookFriend>;
		
		public function FacebookFriend() 
		{
			this.isMe = false;
			this.installed = false;
			
		}
		
		public function toString():String
		{
			return StringTools.toString(this);
		}
		
		/**
		 * Creates a 2D Array of all session stored Facebook Friends.
		 * @return	An array containing an untyped object representation of the FacebookFriend object
		 */
		
		public static function to2DArray():Array
		{
			var arr:Array = new Array();
			var arr2:Array = getClassVariables( friends[i] );
			
			for ( var i:uint = 0; i < friends.length; i++ )
			{
				var obj:Object = new Object();
				for ( var j:uint = 0; j < arr2.length; j++ )
				{
					obj[ arr2[j] ] = friends[i][ arr2[j] ]; 
				}
				arr.push( obj );
			}
			
			return arr;
		}
		
		/*public static function from2DArray( arr:Array ):void
		{
			friends = new Vector.<FacebookFriend>;
			
			for ( var i:uint = 0; i < arr.length; i++ )
			{
				var friend:FacebookFriend = new FacebookFriend();
				var obj:Object = arr[i];
				for ( var str:String in obj )
				{
					friend[str] = obj[str];
				}
				friends.push(friend);
			}
			
			friends.sort( friendSort );
		}*/
		
		/**
		 * Adds or updates an existing FacebookFriend object to session stored data from an untyped object representation of a FacebookFriend object
		 * @param	data	untyped object representation of a FacebookFriend object
		 */
		
		public static function addFriendFromObject( data:Object ):void
		{
			if ( !friends ) {
				friends = new Vector.<FacebookFriend>;
			}
			
			var fr:FacebookFriend = new FacebookFriend();
			
			for ( var i:uint = 0; i < friends.length; i++ ) {
				if ( friends[i].id == data.id ) {
					fr = friends[i];
				}
			}
			
			fr.id = data.id;
			fr.name = data.name;
			if ( data.installed ) {
				fr.installed = true;
			}
			for ( var str:String in data )
			{
				if ( !fr[str] )
				{
					fr[str] = data[str];
				}
			}
			friends.push( fr );
		}
		
		/**
		 * Adds or replaces a session stored FacebookFriend object
		 * @param	friend	A FacebookFriend object to add or replace an existing record (based on the 'id' value)
		 */
		
		public static function addFriend( friend:FacebookFriend ):void
		{
			if ( !friends )
			{
				friends = new Vector.<FacebookFriend>;
			}
			
			for ( var i:uint = 0; i < friends.length; i++ )
			{
				if ( friends[i].id == friend.id )
				{
					friends.splice( i, 1 );
					break;
				}
			}
			
			friends.push( friend );
			
			friends.sort( friendSort );
		}
		
		/**
		 * Adds data to the session stored Facebook friend data
		 * @param	data	The 2D array consisting of untyped objects representing the FacebookFriend object
		 */
		
		public static function processFromArray( data:Array ):void
		{
			friends = new Vector.<FacebookFriend>;
			
			for ( var i:uint = 0; i < data.length; i++ ) {
				addFriendFromObject( data[i] );
			}
			
			friends.sort( friendSort );
			
		}
		
		/**
		 * @private	Sort function for the Facebook friend session data (alphabetically)
		 */
		
		private static function friendSort( a:FacebookFriend, b:FacebookFriend ):int
		{
			var strA:String = a.name.toLowerCase();
			var strB:String = b.name.toLowerCase();
			
			var length:int = strA.length;
			if ( strB.length < length ) {
				length = strB.length;
			}
			
			for ( var i:uint = 0; i < length; i++ ) {
				var codeA:int = strA.charCodeAt(i);
				var codeB:int = strB.charCodeAt(i);
				if ( codeA < codeB )
				{
					return -1;
				}
				else if ( codeA > codeB )
				{
					return 1;
				}
			}
			
			if ( strA.length < strB.length )
			{
				return -1;
			}
			else if ( strA.length > strB.length )
			{
				return 1;
			}
			
			return 0;
			
		}
		
		/**
		 * Obtains all Facebook friends (or just those that have installed this app)
		 * @param	installs_only	Pass as true if the resulting data is to only include those friends that have installed this app
		 * @return	Vector of FacebookFriend objects
		 */
		
		public static function getFriends( installs_only:Boolean=false ):Vector.<FacebookFriend>
		{
			if ( !installs_only ) {
				return friends;
			} else {
				var installed_friends:Vector.<FacebookFriend> = new Vector.<FacebookFriend>;
				for ( var i:uint = 0; i < friends.length; i++ ) {
					if ( friends[i].installed && !friends[i].isMe ) {
						installed_friends.push( friends[i] );
					}
				}
				return installed_friends;
			}
			
		}
		
		/**
		 * Retrieves the FacebookFriend object of a specific friend based on facebook id
		 * @param	facebook_id	The facebook id of the specified friend
		 * @return	A FacebookFriend object of the requested friend. If not found, null is returned.
		 */
		
		public static function getFriendFromID( facebook_id:String ):FacebookFriend
		{
			if ( friends )
			{
				for ( var i:uint = 0; i < friends.length; i++ )
				{
					if ( friends[i].id == facebook_id )
					{
						return friends[i];
					}
				}
			}
			
			return null;
		}
		
		/**
		 * Adds the passed FacebookFriend object and flags this record as the current user
		 * @param	me	FacebookFriend object to be flagged as the current user
		 */
		
		public static function addMe( me:FacebookFriend ):void
		{
			if ( !friends ) {
				friends = new Vector.<FacebookFriend>;
			}
			else
			{
				for ( var i:uint = 0; i < friends.length; i++ )
				{
					if ( friends[i].isMe )
					{
						friends.splice( i, 1 );
						i--;
					}
				}
			}
			
			me.isMe = true;
			friends.push(me);
		}
		
		/**
		 * Obtains the session stored FacebookFriend object that is flagged as the current user
		 * @return	A FacebookFriend object of the current user
		 */
		
		public static function getMe():FacebookFriend
		{
			if ( friends ) {
				for ( var i:uint = 0; i < friends.length; i++ )
				{
					if ( friends[i].isMe )
					{
						return friends[i];
					}
				}
			}
			
			return null;
		}
		
		/**
		 * Obtains a 2D array of all current Facebook friend id's
		 * @return
		 */
		
		public static function getAllFriendIDs():Array
		{
			if (!friends)
			{
				return null;
			}
			
			var arr:Array = new Array();
			
			for ( var i:uint = 0; i < friends.length; i++ )
			{
				arr.push( friends[i].id );
			}
			
			return arr;
		}
		
		/**
		 * Clears all session stored FacebookFriend data
		 */
		
		public static function clear():void
		{
			friends = null;
		}
		
	}

}