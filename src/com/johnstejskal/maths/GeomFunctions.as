package com.johnstejskal.maths 
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author jihn
	 */
	public class GeomFunctions 
	{
		
		public function GeomFunctions() 
		{
			
		}
	//def in_circle(center_x, center_y, radius, x, y):
   // square_dist = (center_x - x) ** 2 + (center_y - y) ** 2
   // return square_dist <= radius ** 2	
		
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
	}

}