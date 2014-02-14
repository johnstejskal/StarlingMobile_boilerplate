package ManagerClasses.ObjectPools 
{
	import com.johnstejskal.ArrayFunctions;
	import com.johnstejskal.StringFunctions;
	import starling.display.DisplayObject;
	/**
	 * ...
	 * @author jihn
	 */
	public class ObjPool_effects 
	{
		
		public static var pool:Array = [];
		public static var count:int = 0;
		
		
	
		
		
		public function ObjPool_effects() 
		{
			
		}
		
		
		public static function addToPool(obj:DisplayObject):void
		{
			pool.push(obj);
			count ++;
			trace(obj + " was added to ObjectPool - pool is now:" + pool);
		}
		
		
		public static function getFromPool(targClass:Class):DisplayObject
		{
			var item:DisplayObject;
			var lngth:int = pool.length;
			for (var i:int = 0; i < lngth; i ++)
			{
				trace("i:"+i)
				if (targClass == StringFunctions.getClass(pool[i]))
				{
					item = pool[i];
					pool.splice(i,1);
					return item;
								
				}	
			}
			return item;
		}
		
		
		
	}

}