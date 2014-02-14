/* JsonMan - (c) Filippo Gregoretti - PippoFlash.com */
/* Converts Json accordin to player version */

package com.pippoflash.string {
	import									flash.geom.*;
	import									flash.display.*;
	import									flash.text.*;
	import									flash.net.*;
	import									flash.events.*;
	import 									flash.utils.*;
	import									com.adobe.serialization.json.JSON;
// 	import									com.pippoflash.utils.UText;
// 	import									com.pippoflash.utils.Debug;
	
	public dynamic class JsonMan {
		public static var encode					:Function;
		public static var decode					:Function;
		private static var _initialized					:Boolean;
// VARIABLES //////////////////////////////////////////////////////////////////////////
		// STATIC
		public static function init					():void {
			if (_initialized)						return;
			if (JSON["encode"]) {
				encode						= JSON["encode"];
				decode						= JSON["decode"];
			}
			else	{
				encode						= JSON["stringify"];
				decode						= JSON["parse"];
			}
			_initialized							= true;
		}
// INIT //////////////////////////////////////////////////////////////////////////////////////////
// RENDER //////////////////////////////////////////////////////////////////////////////////////////
// METHODS //////////////////////////////////////////////////////////////////////////////////////
// SPECIAL METHODS //////////////////////////////////////////////////////////////////////
// DATE COMPARISON ///////////////////////////////////////////////////////////////////////
// LISTENERS //////////////////////////////////////////////////////////////////////////////////////
	}
}