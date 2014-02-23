package com.johnstejskal 
{

	/**
	 * ...
	 * @author john Stejskal	
	 * www.johnstejskal.com
	 * "Why walk when you can ride"
	 */
	public class ArrayUtil
	{
		
		public function ArrayUtil() 
		{
			
		}
		
		//----------------------------------------------o
		//--- last Character of String
		//----------------------------------------------o
		public static function getLastCharInString($s:String):String
		{
		return $s.substr($s.length-1,$s.length);
		}
		
		//----------------------------------------------o
		//--- Find Value in array
		//----------------------------------------------o		
		public static function findIndexInArray(value:Object, arr:Array):Number {
			for (var i:uint=0; i < arr.length; i++) {
				if (arr[i]==value) {
					return i;
				}
			}
			return NaN;
		}		
		
		//----------------------------------------------o
		//--- Remove an item from array
		//----------------------------------------------o		
		public static function removeItemFromArray(thearray:Array, theItem:*):void
		{
			for (var i:int = 0; i < thearray .length; i++)
			{
				if (thearray[i] == theItem) {
					
					thearray.splice(i,1);
				}
			}
		}
		
		//----------------------------------------------o
		//--- Remove an item from Vector
		//----------------------------------------------o		
	/*	public static function removeItemFromVector(theVector:Vector.<EnemySuper>, theItem:*):void
		{
			//trace("##################  Your vector is - "+theVector);
			for (var i:int = 0; i < theVector .length; i++)
			{
				if (theVector[i] == theItem) {
					
					theVector.splice(i,1);
					//i-=1;
				}
		}
			
		}*/
		
		//----------------------------------------------o
		//--- Shuffle Array 
		//--  modified original
		//----------------------------------------------o			
		static public function shuffleArray( a:Array ):void {			
			var len:uint = a.length;
			var n:uint;
			var i:uint;
			var el:*;
			for (i=0; i<len; i++) {
				el = a[i];
				n = Math.floor( Math.random() * len );
				a[i] = a[n];
				a[n] = el;
			}		
		}	
		
		//----------------------------------------------o
		//--- Shuffle Array 
		//--  returns new array
		//----------------------------------------------o	
		static public function shuffleArray2( arr:Array ):void {			
			var a:Array = arr;
		
			var len:uint = a.length;
			var n:uint;
			var i:uint;
			var el:*;
			for (i=0; i<len; i++) {
				el = a[i];
				n = Math.floor( Math.random() * len );
				a[i] = a[n];
				a[n] = el;
			}		
		}
		
		//----------------------------------------------o
		//--- Search array item by name
		//----------------------------------------------o		
		public static function getIndexByName(array:Array, search:String):int {
		
		for (var i:int = 0; i < array.length; i++) {
			if (array[i].name == search) {
				return i;
			}
		}
		return -1;
		}
		
	}

}