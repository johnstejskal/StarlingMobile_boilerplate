package com.thirdsense.utils
{
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.geom.Point;
		
	/**
	 * Math, Array and Trigonometry toolset.
	 * 
	 * @author Ben Leffler
	 * @version 1.0.0
	 * @date 04/08/2010
	 * 
	 */
	
	public class Trig {
		
		// ==============================================================================================
		
		/**
		 * Finds an angle based on the location of two points.
		 * @param	Target	The destination point.
		 * @param	Origin	The origin point.
		 * @return	The angle in degrees. Will be a value between -180 and 180 (with 0 indicating an angle heading directly upwards).
		 */
		
		public static function findAngle(Target:Point, Origin:Point):Number {
			
			// Returns angle in degrees based on the target in relation to origin (straight up returns 0)
			
			var myPoint:Point = Target.subtract(Origin);
			var hypotenuse:Number = Math.sqrt((myPoint.x*myPoint.x)+(myPoint.y*myPoint.y));
			var angle:Number = (Math.asin((myPoint.y/hypotenuse)))+((Math.PI/180)*90);
			
			angle = angle * (180 / Math.PI);
			
			if (myPoint.x < 0) {
				angle *= -1;
			}
			
			if ( isNaN(angle) ) {
				angle = 0;
			}
			
			return angle;
		}
		
		// ==============================================================================================
		
		/**
		 * Finds a point based on a distance travelled from Point(0,0) at the passed angle.
		 * @param	angle	Angle to travel in degrees.
		 * @param	distance	Distance to travel.
		 * @return	A point containing 2D co-ordinate data at a distance and angle from Point(0,0).
		 */
		
		public static function findPoint(angle:Number, distance:Number, result:Point = null ):Point {
			
			// Returns a co-ordinate of a point [distance] at [angle] from point 0,0
			
			if ( !result ) result = new Point();
			
			result.x = Math.sin((Math.PI / 180) * angle) * distance;
			result.y = (Math.cos((Math.PI / 180) * angle) * -1) * distance;
			
			return result;
			
		}
		
		// ==============================================================================================
		
		/**
		 * Finds the distance between Point 1 and Point 2 (using Pythagoras Theorum).
		 * @param	DO1	First Point of measurement.
		 * @param	DO2 Second Point of measurement.
		 * @return	Distance between Point 1 and Point 2.
		 */
		
		public static function findDistance(DO1:Point, DO2:Point):Number {
			
			// Returns the distance between point A and point B
			
			return Math.sqrt(((DO1.x - DO2.x) * (DO1.x - DO2.x)) + ((DO1.y - DO2.y) * (DO1.y - DO2.y)));
			
		}
		
		// ==============================================================================================
		
		/**
		 * Returns if a passed integer is odd or even.
		 * @param	num	Integer to evaluate.
		 * @return	Will return true if the passed integer is even, and false if it is odd.
		 */
		
		public static function isEven(num:int):Boolean {
			
			// Returns if a value is odd or even
			
			if ((num / 2) - Math.round(num / 2) != 0) {
				return false;
			} else {
				return true;
			}
			
		}		
		
		
		// ===============================================================================================
		
		/**
		 * Returns a random value between a minimum and a maximum value.
		 * @param	min	Minimum value in the random range.
		 * @param	max Maximum value in the random range.
		 * @return A randomized value within the range requested.
		 */
		
		public static function randBetween(min:Number, max:Number):Number
		{
			return Math.round(Math.random()*(max-min))+min;
			
		}
		
		// ===============================================================================================
		
		/**
		 * Rounds a number to a designated number of decimal places
		 * @param	num
		 * @param	decimals
		 * @return	Rounded number to the designated number of decimal places
		 */
		
		public static function roundTo(num:Number, decimals:uint):Number
		{
			return Math.round(num * (Math.pow(10,decimals)))/(Math.pow(10,decimals));
			
		}
		
		// ===============================================================================================
		
		/**
		 * Provides the square of a number
		 * @param	Num	The value to be squared
		 * @return	The square of the passed value
		 */
		
		public static function sqr(num:Number):Number
		{
			return num * num;
			
		}
		
		// ===============================================================================================
		
		/**
		 * Limits a number to a passed minimum and maximum value
		 * @param	val	Value to be evaluated
		 * @param	min	Minimum that the value is to be limited to
		 * @param	max Maximum that the value is to be limited to
		 * @return	The limit applied result
		 */
		
		public static function lim(val:Number, min:Number, max:Number):Number
		{
			// Returns a value that is limited to the range dictated by [min] and [max]
			
			if (val < min) {
				val = min;
			}
			
			if (val > max) {
				val = max;
			}
			
			return val;
			
		}
		
		// ================================================================================================
		
		/**
		 * Converts a number to a formatted string split every 3 digits with a comma
		 * @param	value	The number to apply the formatting to
		 * @return	A string formatted with comma dividers every 3 digits.
		 */
		
		public static function formatNumber( value:Number, monetary:Boolean = false ):String
		{
			var val:String = value.toString();
			var str:String = "";
			var end_str:String = "";
			
			if ( val.charAt(0) == "-" ) {
				str += val.charAt(0);
				val = val.substr(1);
			}
			
			if ( monetary ) {
				str += "$";
			}
			
			if ( val.indexOf(".") >= 0 ) {				
				var dot:uint = val.indexOf(".");
				end_str = val.substr(dot);
				val = val.substring(0, dot);				
			}
			
			var val2:String = String( val );
			
			while ( val.length ) {
				if ( val.length / 3 == Math.floor(val.length / 3) && val2.length != val.length) {
					str += ",";
				}
				str += val.charAt(0);
				
				if ( val.length > 1 ) {
					val = val.substr(1);
				} else {
					val = "";
				}				
			}
			
			str += end_str;
			
			return str;
		}
		
		// ==============================================================================================
		
		/**
		 * Shuffles values within an array in to random order
		 * @param	arr	The array to apply the shuffle to...
		 * @return	The shuffled array.
		 */
		
		public static function shuffle(arr:Array):Array
		{
			var arr2:Array = new Array();
			while( arr.length ) {
				var ran:uint = Math.floor(Math.random() * arr.length);
				arr2.push( arr[ran] );
				arr.splice(ran, 1);
			}
			
			for ( var i:uint = 0; i < arr2.length; i++ )
			{
				arr.push(arr2[i]);
			}
			
			return arr2;
			
		}
		
		// ==============================================================================================
		
		/**
		 * Copies an array to a new instance
		 * @param	arr	The array to apply the replication of.
		 * @return	The new instance of an array.
		 */
		
		public static function copyArray(arr:Array):Array
		{
			var arr2:Array = new Array();
			
			for ( var i:uint = 0; i < arr.length; i++ ) {
				arr2.push( arr[i] );
			}
			
			return arr2;
			
		}
		
		// ==============================================================================================
		/**
		 * Converts from degrees to radians
		 * @param	degrees	The degrees value to convert
		 * @return	Radians
		 */
		
		public static function toRadians( degrees:Number ):Number
		{
			return degrees * (Math.PI / 180);
			
		}
		
		// ==============================================================================================
		/**
		 * Converts from radians to degrees
		 * @param	radians	The radian value to convert from
		 * @return	Degrees
		 */
		
		public static function toDegrees( radians:Number ):Number
		{
			return radians * (180 / Math.PI );
			
		}
		
		// ==============================================================================================
		/**
		 * Returns a random number either 0 or 1
		 * @return	A random integer either 0 or 1
		 */
		
		public static function flipCoin():int
		{
			return Math.round(Math.random());
			
		}

	}
	
}