package com.johnstejskal 
{
	import com.greensock.TweenLite;
	import flash.utils.clearInterval;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.setInterval;
	
	/**
	 * ...
	 * @author john
	 */
	public class McUtils 
	{
		
		public function McUtils() 
		{
			
		}
		
		//-----------------------------------------------o
		//-------- Make an object flash
		//-----------------------------------------------o
		public static function makeObjectFlash(object:*, time:Number, interval:Number):void
		{
			var myInterval:uint = setInterval (flash, interval);

			TweenLite.delayedCall(time, function():void{  clearInterval(myInterval);  object.visible = true; })
			
			function flash():void
			{
				if (!object.visible)
				object.visible = true;
				else
				object.visible = false;
			}
			
		}
	
	}

}