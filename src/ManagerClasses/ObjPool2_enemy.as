package ManagerClasses 
{
	import starling.display.DisplayObject;
	/**
	 * ...
	 * @author jihn
	 */
	public class ObjectPool 
	{
		
		private var _arrPool:Array;
		private var _counter:int = 0;
		private var _poolLength:int;
		
		public function ObjectPool(type:Class, len:int) 
		{
			_arrPool = new Array();
			
			var i:int = 0;
			while (i < len){
			_arrPool[i] = new type();
			trace("_arrPool[i] :" + _arrPool[i]);
			i ++;
			}
			
			_poolLength = len;
			
			
		}
		
		public function getSprite():DisplayObject
		{
			if (_counter < _poolLength)
			{
			_counter++;
			trace("_counter :" + _counter);
			}
			return _arrPool[_counter - 1];
		}
		public function returnSprite(s:DisplayObject):void
		{
			_arrPool[_counter - 1] = s;
			_counter--;
		}
		
		public function get poolLength():int 
		{
			return _poolLength;
		}
		
	}

}