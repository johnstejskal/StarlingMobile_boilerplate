package ManagerClasses.ObjectPools 
{

	import view.components.starlingObjects.collectables.Coin;

	import staticData.DataVO;
	/**
	 * ...
	 * @author jihn
	 */
	public class ObjPool_Coin 
	{
		
		public static var pool:Array = [];
		public static var count:int = 0;
		static private var lgth:int = 0;		
		static private var maxItems:int = 30;	
	
		
		
		public function ObjPool_Coin() 
		{
			
		}
		
		
		public static function addToPool(obj:Coin):void
		{
			if (count < maxItems)
			{
			pool.push(obj);
			count ++;
			}
			lgth = pool.length;
		}
		
		
		public static function getFromPool():Coin
		{
			//if (count > 1)
			
			
			count--;
			
			return pool[count];
			
			
			
		}
		
		public static function returnToPool():void
		{			
			if (count < lgth)
			count++;
		}		
		
	}

}