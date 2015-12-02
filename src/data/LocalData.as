package data 
{
	/**
	 * ...
	 * @author 
	 */
	public class LocalData 
	{
		//----------------------------------------o
		//------ Data list 
		//----------------------------------------o		
		public static var first_name:String;
		public static var last_name:String;
		public static var email:String;
		public static var password:String;
		static public var token:String;
		
		static public var playerDataObj:String;
		
		static private var arrScreenNotificationsViewed:Array = [];
		

		public function LocalData() 
		{

		}
		
		static public function reset():void 
		{
			trace(LocalData + "reset()");
			playerDataObj = null
			first_name = null;
			token = null;
			last_name = null;
			email = null;
			password = null;
			arrScreenNotificationsViewed = [];
		}
		
	}

}