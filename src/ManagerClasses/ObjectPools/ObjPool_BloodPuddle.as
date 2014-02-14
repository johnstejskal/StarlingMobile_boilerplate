package ManagerClasses.ObjectPools 
{


	import view.components.starlingObjects.effects.BloodPuddle;
	import vo.DataVO;
	/**
	 * ...
	 * @author jihn
	 */
	public class ObjPool_BloodPuddle 
	{
		
		public static var pool:Array = [];
		public static var count:int = 0;
		public static var lgth:int = 0;
		
		
	
		
		
		public function ObjPool_BloodPuddle() 

		
		
		public static function addToPool(obj:BloodPuddle):void
		{
			if (count < DataVO.maxMobsOnStage)
			{
			pool.push(obj);
			count ++;
			
			}
			
			lgth = pool.length;
		}
		
		
		public static function getFromPool():BloodPuddle
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