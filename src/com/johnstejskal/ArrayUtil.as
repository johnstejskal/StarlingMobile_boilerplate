package com.johnstejskal 
{
	import starling.display.Sprite;

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
		//--- Return Length of object
		//----------------------------------------------o	
		public static function getObjectLength(o:Object):uint
		{
			var length:uint = 0;

			for (var s:* in o)
			length++;

			return length;
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
		
		//----------------------------------------------o
		//---  Flatten 2 Dimentional Array
		//----------------------------------------------o	
		public static function flatten2D(arrays:Array):Array {
			var result:Array = [];
			for(var i:int=0;i<arrays.length;i++){
				result = result.concat(arrays[i]);
			}
			return result;
		}

		
		//----------------------------------------------o
		//--- Split an array into a chunks of a specific number 
		//-- returns multidimentional array 
		//----------------------------------------------o	
		public static function chunk (arr:Array, chunkSize:int):Array {

			  var chunks:Array = new Array()
			  var i:int = 0;
			  var n:int = arr.length;
  
			  while (i < n) {
				chunks.push(arr.slice(i, i += chunkSize));
			  }

			  return chunks;
		}
			
			
		//----------------------------------------------o
		//--- Split an array evenly into a group of arrays 
		//-- returns multidimentional array
		//----------------------------------------------o	
		public static function splitTo(a1:Array, parts:uint):Array 
		{
			if (parts > 1) {
				
				var aCount:Number = a1.length / parts;
				var limit:int = int(aCount);
				var res:Array = new Array();
				
				// if aCount <= 1
				if (aCount <= 1) 
				{
					
					// put every element in new array
					for (var i:uint = 0; i<a1.length; i++) 
					{
						
						// make new array and resulting array
						var newarray:Array = new Array();
						newarray.push(a1[i]);
						res.push(newarray);
					}
				} else {
					for (var k:uint = 0; k<parts; k++) 
					{
						var newarray2:Array = new Array();
						
						if (a1.length > 0) 
						{ 
						
							// if a1 is not empty
							for (var j:uint = 0; j<limit; j++) 
							{
								newarray2.push(a1.splice(0, 1));
							}
							res.push(newarray2);
						}
					}
					
					// put rest of the elements inside last array
					while (a1.length > 0) 
					{
						res[res.length-1].push(a1.splice(0, 1));
					}
				}
				
				// return resulting Array of Array[s]
				return res; 
			} else {
				return a1;
			}
		}
		
		
		
		
		
		static public function emptySpriteArray(arr:Array):void 
		{
			


		}
		
	}

}