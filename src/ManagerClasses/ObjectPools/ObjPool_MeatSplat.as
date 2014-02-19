package ManagerClasses.ObjectPools 
{

	import view.components.starlingObjects.effects.MeatSplat;
	import staticData.DataVO;
	/**
	 * ...
	 * @author jihn
	 */
	public class ObjPool_MeatSplat 
	{
		
		public static var pool:Array = [];
		public static var count:int = 0;
		static private var lgth:int = 0;
		
		
	
		
		
		public function ObjPool_MeatSplat() 

		
		
		public static function addToPool(obj:MeatSplat):void
		{
			if (count < DataVO.maxMobsOnStage)
			{
			pool.push(obj);
			count ++;
			}
			
			lgth = pool.length;
		}
		
		
		public static function getFromPool():MeatSplat
		{
			count--;
			
			trace("you are requesting :"+pool[count]) 
			return pool[count];
			
			
		}
		
		public static function returnToPool():void
		{			
			if (count < lgth)
			count++;
		}		
		
	}

}