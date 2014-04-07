package ManagerClasses.ObjectPools 
{

	import com.johnstejskal.StringFunctions;
	import starling.display.DisplayObject;
	import view.components.gameobjects.Coin;
	import view.components.gameobjects.superClass.GameObject;
	/**
	 * ...
	 * @author john
	 */
	public class ObjPool_Coin 
	{
		
		public static var pool:Array = [];
		public static var count:int = 0;
		
		
	
		
		
		public function ObjPool_Coin() 
		{
			
		}
		
		public static function populate(amount:int = 0):void 
		{

			
			for (var i:int = 0; i < amount; i++) 
			{
				var obj:Coin = new Coin();
				addToPool(obj);
			}
			
			//trace(ObjPool_Coin+"populate() OP has been populated:" + pool.length);
		}
		
		public static function addToPool(obj:Coin):void
		{
			pool.push(obj);
			trace(obj + " was ADDED to ObjectPool - pool is now:" + pool.length);
		}
		
		
		public static function getFromPool(targClass:Class = null ):Coin
		{
			var item:Coin;
			var lngth:int = pool.length;

				if (pool.length == 0) {
				trace(ObjPool_Coin+" EXPANDING OBJECT POOL")
				populate(10)
				}
				
					item = pool[0];
					pool.splice(0, 1);
					
					
					//trace(item + " was REMOVED from ObjectPool - pool is now:" + pool.length);
					return item;

		}
		
		static public function empty():void 
		{
			trace(ObjPool_Coin + "empty()");
			pool.length = 0;
			pool = [];
		}
		
		
		
	}

}