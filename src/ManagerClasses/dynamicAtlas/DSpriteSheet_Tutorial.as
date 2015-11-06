package ManagerClasses.dynamicAtlas {
	import com.xtdstudios.DMT.DMTBasic;
	import flash.events.Event;
	import staticData.data.AppData;
	/**
	 * ...
	 * @author 
	 */
	public class DSpriteSheet_Tutorial 
	{
		static public var dtm:DMTBasic;
		static private var ref:String = "tutorial";
		static public var onComplete:Function;
		
		public function DSpriteSheet_Tutorial() 
		{
			
			
		}
		
		public static function init():void {
			
			trace(DSpriteSheet_Tutorial + "init()");
			
			var tuteScreen1:TA_tutorial1 = new TA_tutorial1();
			var tuteScreen2:TA_tutorial2 = new TA_tutorial2();
			var tuteScreen3:TA_tutorial3 = new TA_tutorial3();
			var tuteScreen4:TA_tutorial4 = new TA_tutorial4();
			
			tuteScreen1.scaleX = tuteScreen1.scaleY = AppData.offsetScale;
			tuteScreen2.scaleX = tuteScreen2.scaleY = AppData.offsetScale;
			tuteScreen3.scaleX = tuteScreen3.scaleY = AppData.offsetScale;
			tuteScreen4.scaleX = tuteScreen4.scaleY = AppData.offsetScale;
	
			dtm = new DMTBasic(ref, false);
			dtm.addItemToRaster(tuteScreen1, "tutorial1");
			dtm.addItemToRaster(tuteScreen2, "tutorial2");
			dtm.addItemToRaster(tuteScreen3, "tutorial3");
			dtm.addItemToRaster(tuteScreen4, "tutorial4");

			dtm.addEventListener(flash.events.Event.COMPLETE, onProcessComplete);
			dtm.process();	

			tuteScreen1 = null;
			tuteScreen2 = null;
			tuteScreen3 = null;
			tuteScreen4 = null;
			
		}

		static private function onProcessComplete(e:Event):void 
		{
			dtm.removeEventListener(flash.events.Event.COMPLETE, onProcessComplete);
			
			if (onComplete != null)
			onComplete();
		}
		
		
		public static function trash():void
		{
			if (dtm != null)
			{
				dtm.dispose();
				dtm = null;
			}
		}

		
	}

}