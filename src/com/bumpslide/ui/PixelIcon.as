package com.bumpslide.ui {
	import flash.display.Sprite;
	
	/**
	 * Quite ridiculous, actually
	 * 
	 * 
	 * example:
	 * 
	 * // arrow
	 * addChild( new PixelIcon( ['  * ', 
	 *                           ' *', 	 *                           '********', 	 *                           ' *', 
	 *                           '  * '] ) );
	 * 
	 * @author David Knape
	 */
	public class PixelIcon extends Sprite {

		public function PixelIcon(icon_data:Array=null, color:Number=0x000000) {
			graphics.beginFill(color, 1);
			var num_rows:int = icon_data.length;
			for ( var row:int=0; row<num_rows; ++row) {
				var num_columns:int = icon_data[row].length;
				for(var col:int=0; col<num_columns; ++col) {
					if((icon_data[row] as String).charAt(col)!=" ") graphics.drawRect(col, row, 1, 1);
				}
			}
			graphics.endFill();
			cacheAsBitmap = true;
		}
		
		static public function Demo() : Sprite {
			return new PixelIcon( [ '  * ', 
		                            ' *', 
		                            '********', 
		                            ' *', 
		                            '  * ' ] );
		}
	}
}
