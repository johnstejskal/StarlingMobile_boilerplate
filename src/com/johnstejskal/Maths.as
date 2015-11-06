package com.johnstejskal 
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author john Stejskal	
	 * www.johnstejskal.com
	 * "Why walk when you can ride"
	 */
	public class Maths 
	{
		
		public function Maths() 
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
	
		//----------------------------------------------o
		//--- Check if Number is within a specific range
		//----------------------------------------------o			
		public static function withinRange(min:Number , value:Number , max:Number):Boolean{
			return min > value ? false : ( max < value ? false : true );
		}
		
		
		//----------------------------------------------o
		//--- returns the degree between 2 points
		//----------------------------------------------o			
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
		var distance:Number = Math.sqrt( ( point1.x - point2.x ) * ( point1.x - point2.x ) + ( point1.y - point2.y ) * ( point1.y - point2.y ) );
		return distance
		}
		//----------------------------------------------o
		//--- Faster version of above for high FPS games
		//----------------------------------------------o		
		public static function fastDist(p2:Point, p1:Point):Number
		{
		return (p2.x - p1.x) * (p2.x - p1.x) + (p2.y - p1.y) * (p2.y - p1.y);
		} 		
		
		//----------------------------------------------o
		//--- round to decimal places
		//----------------------------------------------o
		public static function roundDecimal(num:Number, precision:int):Number
		{
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
		//----------------------------------------------o
		//--- same as above with alternate short name
		//----------------------------------------------o		
		public static function rn(low:Number=0, high:Number=1):Number
		{
			return Math.floor(Math.random() * (1+high-low)) + low;
		}
		
		//----------------------------------------------o
		//--- returns a random float between a number range
		//----------------------------------------------o		
		public static function randomFloat(low:Number=0, high:Number=1):Number
		{
			return Math.random() * (1+high-low) + low;
		}
		

		//----------------------------------------------o
		//--- returns a random true or false
		//----------------------------------------------o
		public static function randomBoolean():Boolean
		{
			return Boolean( Math.round(Math.random()) );
			trace(randomBoolean());	
		}
		
		//----------------------------------------------o
		//--- returns a random 1 or 0
		//----------------------------------------------o		
		public static function randomBinary():int
		{
			return int( Math.round(Math.random()) );
			trace(randomBinary());	
		}	
		
		
		//----------------------------------------------o
		//--- returns a the point at end of radius based on a variable angle
		//----------------------------------------------o
		public static function getPointAlongRadius(centerX:int, centerY:int, radius:int, angle:int):Point
		{
			var point:Point = new Point();
			point.x = centerX + radius * Math.cos(angle)
			point.y = centerY + radius * Math.sin(angle)	
			return point;
		}	
		
		//----------------------------------------------o
		//--- check if an object is within a radius
		//----------------------------------------------o	
		public static function checkIfWhithinRadius(target:Object, center:Point, radius:Number ):Boolean
		{    
			var pnt:Point = new Point();     
          
				pnt.x = target.x;        
				pnt.y = target.y;         
				var dis:Number = Point.distance(center, pnt);  
				
				if (dis <= radius)  
				return true;
				else 
				return false;
		}	
		
		//----------------------------------------------o
		//--- check if an number is odd or even
		//----------------------------------------------o	
		static public function getParity(num:int):Boolean 
		{
			if (num % 2 == 0)
			{
				return false;
			}
			else
			{
				return true;
			}		
		}
		
		
		//----------------------------------------------o
		//--- Uses "haversine" formula to calculate and return
		//--- the distance between two latitudes and longditudes
		//----------------------------------------------o			
		public static function distanceBetweenCoordinates(lat1:Number,lon1:Number,lat2:Number,lon2:Number,units:String="miles"):Number{

			var RADIUS_OF_EARTH_IN_MILES:int = 3963;
			var RADIUS_OF_EARTH_IN_FEET:int =20925525;
			var RADIUS_OF_EARTH_IN_KM:int =6378;
			var RADIUS_OF_EARTH_IN_M:int =6378000;


			var R:int = RADIUS_OF_EARTH_IN_MILES;
			if (units == "km"){
				R = RADIUS_OF_EARTH_IN_KM;
			}
			if (units == "meters"){
				R = RADIUS_OF_EARTH_IN_M;
			}
			if (units =="feet"){
				R= RADIUS_OF_EARTH_IN_FEET;
			}

			var dLat:Number = (lat2-lat1) * Math.PI/180;
			var dLon:Number = (lon2-lon1) * Math.PI/180;

			var lat1inRadians:Number = lat1 * Math.PI/180;
			var lat2inRadians:Number = lat2 * Math.PI/180;

			var a:Number = Math.sin(dLat/2) * Math.sin(dLat/2) + 
							   Math.sin(dLon/2) * Math.sin(dLon/2) * 
							   Math.cos(lat1inRadians) * Math.cos(lat2inRadians);
				var c:Number = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a)); 
				var d:Number = R * c;

			return d;
		}
		

		public static function getAngle (x1:Number, y1:Number, x2:Number, y2:Number):Number
		{
			var dx:Number = x2 - x1;
			var dy:Number = y2 - y1;
			return Math.atan2(dy,dx);
		}
		
	}

}