package ManagerClasses.dynamicAtlas {
	import com.xtdstudios.DMT.DMTBasic;
	import flash.events.Event;

	import data.AppData;
	import staticData.dataObjects.PlayerData;
	import data.settings.PublicSettings;

	/**
	 * ...
	 * @author  John Stejskal
	 * "Why walk when you can ride"
	 */
	
	//=====================================================o
	// Dynamic sprite sheet manager
	// used to setup the Dynamic 'Action' sprite sheet
	//=====================================================o
	
	public class DSpriteSheet_action 
	{
		static public var dtm:DMTBasic;
		static private var ref:String = "action";
		static public var _onComplete:Function;

		}
		
		public static function init(complete:Function = null):void {
			
			_onComplete = complete;
			trace(DSpriteSheet_action + "init()");
			dtm = new DMTBasic(ref, false);
			
			
/*			var carCl:Class = arrUpgrades[carIndex];
			car.scaleX = car.scaleY = AppData.offsetScaleX;		*/	
																								
			

			dtm.addItemToRaster(car, "car");

			
			dtm.addEventListener(flash.events.Event.COMPLETE, onProcessComplete);
			dtm.process( true, 1, PublicSettings.FLASH_IDE_COMPILE);	
			
			trace("DSpriteSheet_action: cache exists:"+dtm.cacheExist())
		}
		
		static private function onProcessComplete(e:Event):void 
		{
			dtm.removeEventListener(flash.events.Event.COMPLETE, onProcessComplete);
			
			if (_onComplete != null)
			_onComplete();
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