package com.thirdsense.social.facebook 
{
	import com.thirdsense.utils.AccessorType;
	import com.thirdsense.utils.getClassVariables;
	/**
	 * ...
	 * @author Ben Leffler
	 */
	public class FacebookSessionData 
	{
		public var accessToken:String;
		public var userId:String;
		public var userName:String;
		public var firstName:String;
		public var lastName:String;
		public var email:String;
		public var expiry:String;
		
		public function FacebookSessionData() 
		{
			
		}
		
		/**
		 * Imports and populates this session data object from the ANE API call to login.
		 * @param	data
		 */
		
		public function importFromSessionEvent( data:Object ):void 
		{
			var arr:Array = getClassVariables( this, AccessorType.NONE );
			for ( var i:uint = 0; i < arr.length; i++ )
			{
				this[ arr[i] ] = String( data[ arr[i] ] );
			}
		}
		
		
	}

}