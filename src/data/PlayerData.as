package data 
{
	import com.thirdsense.utils.AccessorType;
	import com.thirdsense.utils.getClassVariables;
	import flash.utils.ByteArray;

	/**
	 * ...
	 * @author John Stejskal
	 */
	public class PlayerData 
	{
		
		static public var token:String;
		
		static public var firstName:String;
		static public var arrPurchasedItems:Array = [];
		static public var arrAchievements:Array = [];
		static public var employer:String;
		
		//static public var upgradeLevel:int = 0;
		static public var rewardLevel:int = 0
		static public var carUpgradeLevel:int = 0;
		
		static public var lastName:String;
		static public var email:String;
		
		static public var arrRewards:Array = []; //fuel vouchers
		
		static public var arrUpgrades:Array = []; //car upgrades
		static public var arrEquippedUpgrades:Array = []; //car upgrades
		
		
		static public var player_id:String;
		static public var hash:String;
		static public var state:String;
		static public var isLoggedIn:Boolean = false;
		static public var hasNovaCar:Boolean = false;
		
		static public var hasSeenTute_jump:Boolean = false;
		static public var hasSeenTute_swipe:Boolean = false;
		
		static public var coins:int = 0;
		static public var rewardTokens:int = 0;
		static public var totalDistance:int = 0;
		static public var bestScore:int = 0;
		
		//Player Performance Upgrades
		static public var carHandlingLevel:Number = 1;
		static public var hasPlayedOnce:Boolean = false;
		
		static public var canJump:Boolean = true;
		static public var lastLoginDate:String;
		static public var consecutiveLogins:int = 0;
		static public var marketing_opt_in:Boolean;
		static public var password:String;

	
	}
}
	