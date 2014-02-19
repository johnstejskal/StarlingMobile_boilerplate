package ManagerClasses.ObjectPools 
{

	import view.components.starlingObjects.effects.BloodSplat;
	import staticData.DataVO;
	/**
	 * ...
	 * @author jihn
	 */
	public class ObjPool_BloodSplat 
	{
		
		public static var pool:Array = [];
		public static var count:int = 0;
		static private var lgth:int = 0;		
		
	
		
		
		public function ObjPool_BloodSplat() 
		{
			
		}
		
		
		public static function addToPool(obj:BloodSplat):void
		{
			if (count < DataVO.maxMobsOnStage)
			{
			pool.push(obj);
			count ++;
			}
			lgth = pool.length;
		}
		
		
		public static function getFromPool():BloodSplat
		{
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