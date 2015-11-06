package ManagerClasses.dynamicAtlas 
{
	import flash.events.Event;
	/**
	 * ...
	 * @author 
	 */
	public class DynamicAtlasManager 
	{
		
		public static var arrDynamicAtlasses:Array = [];
		
		private static var _onComplete:Function;
		private static var itemsToProcess:int = 0;
		private static var itemsProcessed:int = 0;
		
		
		public function DynamicAtlasManager() 
		{
			
		}
		
		public static function processAll(onComplete:Function):void
		{
			_onComplete = onComplete;
			itemsToProcess = arrDynamicAtlasses.length;
			
			for (var i:int = 0; i < itemsToProcess; i++) 
			{
				arrDynamicAtlasses[i]["onComplete"] = onDMTItemComplete;
				arrDynamicAtlasses[i]["init"]();
			}
			
		}
		
		private static function onDMTItemComplete():void
		{
			trace("Item Completed");
			itemsProcessed ++;
			
			if (itemsProcessed == itemsToProcess)
			{
				trace("All Items Complete");
				if (_onComplete != null)
				_onComplete();
			}
		}
		
		
	}

}