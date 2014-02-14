package com.johnstejskal.maths 
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author john
	 */
	public class Maths_
	{
		
		public function Maths_() 
		{
			
		}
		
		//----------------------------------------------o
		//--- Fast Math -  Abs
		//----------------------------------------------o		
		public static function fastAbs( value:Number ):Number
		{
			return value < 0 ? -value : value;
		}	
		public static function fastAbs2( value:Number ):Number
		{
			return value *-1;
		}			
	
		
		public static function withinRange(min:Number , value:Number , max:Number):Boolean{
			return min > value ? false : ( max < value ? false : true );
		}
		
		public static function direction_to_point(x1:int,y1:int,x2:int,y2:int):Number
		{
		  var dx:Number = x1 - x2;
		  var dy:Number = y1 - y2;
		  var dir:Number = Math.atan2(dy,dx)*180/Math.PI;
		  return dir;
		}		
		//----------------------------------------------o
		//--- Distance Between 2 Points
		//----------------------------------------------o
		
		public static function distanceBetweenPoints(point1:Point, point2:Point):Number
		{
		//distance = Math.sqrt( ( firstObject.x - secondObject.x ) * ( firstObject.x - secondObject.x ) + ( firstObject.y - secondObject.y ) * ( firstObject.y - secondObject.y ) );
		var distance:Number = Math.sqrt( ( point1.x - point2.x ) * ( point1.x - point2.x ) + ( point1.y - point2.y ) * ( point1.y - point2.y ) );
		return distance
		}
		
		public static function fastDist(p2:Point, p1:Point):Number
		{
		return (p2.x - p1.x) * (p2.x - p1.x) + (p2.y - p1.y) * (p2.y - p1.y);
		} 		
		//----------------------------------------------o
		//--- round to decimal places
		//----------------------------------------------o
		public static function roundDecimal(num:Number, precision:int):Number{

		var decimal:Number = Math.pow(10, precision);

		return Math.round(decimal* num) / decimal;

		}
		//----------------------------------------------o
		//--- Random Number Generator, Truely Random
		//----------------------------------------------o
		
		public static function randomNumber(low:Number=0, high:Number=1):Number
		{
			return Math.floor(Math.random() * (1+high-low)) + low;
		}
		
		public static function randomBoolean():Boolean
		{
			return Boolean( Math.round(Math.random()) );
			trace(randomBoolean());	
		}
		
		public static function randomBinary():int
		{
			return int( Math.round(Math.random()) );
			trace(randomBinary());	
		}	
		
		public static function getPointAlongRadius(centerX:int, centerY:int, radius:int, angle:int):Point
		{
			var point:Point = new Point();
			point.x = centerX + radius * Math.cos(angle)
			point.y = centerY + radius * Math.sin(angle)	
			return point;
		}			
 

		
	}

}