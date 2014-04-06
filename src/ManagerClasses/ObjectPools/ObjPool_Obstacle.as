package ManagerClasses.ObjectPools 
{

	import com.johnstejskal.StringFunctions;
	import starling.display.DisplayObject;
	import view.components.gameobjects.Coin;
	import view.components.gameobjects.enemy.Block;
	import view.components.gameobjects.superClass.ActionObjSuper;
	import view.components.gameobjects.superClass.Enemy;
	import view.components.gameobjects.superClass.EnemySuper;
	import view.components.gameobjects.superClass.GameObject;
	/**
	 * ...
	 * @author john
	 */
	public class ObjPool_Obstacle 
	{
		
		public static var pool:Array = [];
		public static var count:int = 0;
		

		public function ObjPool_Obstacle() 
		{
			
		}
		
		//===============================================o
		//-- Populate an object pool by Class ie Block , Bird
		//===============================================o	
		public static function populate(targClass:Class, amount:int = 0):void 
		{

			for (var i:int = 0; i < amount; i++) 
			{
				var obj:Enemy = new targClass();
				addToPool(obj);
			}
			
			trace(ObjPool_Coin+"populate() OP has been populated:" + pool.length);
		}
				

		
		//===============================================o
		//-- add an object ie Block , Bird
		//===============================================o		
		public static function addToPool(obj:Enemy):void
		{
			pool.push(obj);
			trace(obj + " was ADDED to ObjectPool - pool is now:" + pool.length);
		}
		
		
		
		//===============================================o
		//-- Retrieve an item by Class type ie Block , Bird
		//===============================================o
		public static function getFromPool(targClass:Class):DisplayObject
		{
			var item:DisplayObject;
			var lngth:int = pool.length;
			
			if (pool.length == 0)
			populate(targClass, 10)
			
			
			for (var i:int = 0; i < lngth; i ++)
			{
				
				if (targClass == StringFunctions.getClass(pool[i]))
				{
					item = pool[i];
					pool.splice(i,1);
					return item;
				}	
			}
			return item;
		}	
		

		//-----------------------o
		//-- empty pool
		//
		static public function empty():void 
		{
			trace(ObjPool_Coin + "empty()");
			pool.length = 0;
			pool = [];
		}
		
	}

}