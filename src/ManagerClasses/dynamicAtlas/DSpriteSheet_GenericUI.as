package ManagerClasses.dynamicAtlas {
	import com.xtdstudios.DMT.DMTBasic;
	import flash.events.Event;
	import data.AppData;
	import data.settings.PublicSettings;
	/**
	 * ...
	 * @author 
	 */
	public class DSpriteSheet_GenericUI 
	{
		static public var dtm:DMTBasic;
		static private var ref:String = "genericUI";
		static public var onComplete:Function;
		
		public function DSpriteSheet_GenericUI() 
		{
			
		}
		
		public static function init(complete:Function = null):void {
			
			trace(DSpriteSheet_GenericUI + "init()");
			onComplete = complete;
			var distanceHud:MC_distanceHUD = new MC_distanceHUD();
			distanceHud.scaleX = distanceHud.scaleY = AppData.deviceScale;
				
			var hudBacking:MC_hudBacking = new MC_hudBacking();
			hudBacking.scaleX = hudBacking.scaleY = AppData.deviceScale;
							
			var pauseButton:MC_pauseIcon = new MC_pauseIcon();
			pauseButton.scaleX = pauseButton.scaleY = AppData.deviceScale;
					
		//	var coinHud:MC_ = new MC_hudBacking();
			//coinHud.scaleX = coinHud.scaleY = AppData.deviceScale;
						
			var infoHud:MC_infoHud = new MC_infoHud();
			infoHud.scaleX = infoHud.scaleY = AppData.deviceScale;
							
			var numberSeries:MC_numberSeries = new MC_numberSeries();
			numberSeries.scaleX = numberSeries.scaleY = AppData.deviceScale;
	
			var scoreFade:MC_scoreFadeUp = new MC_scoreFadeUp();
			scoreFade.scaleX = scoreFade.scaleY = AppData.offsetScaleX;	
					
			
			dtm = new DMTBasic(ref, false);
			dtm.addItemToRaster(pauseButton, "pauseButton");
			dtm.addItemToRaster(numberSeries, "numberSeries");
			dtm.addItemToRaster(distanceHud, "distanceHud");
			dtm.addItemToRaster(infoHud, "infoHud");
			dtm.addItemToRaster(hudBacking, "hudBacking");
			dtm.addItemToRaster(scoreFade, "scoreFade");
			
			dtm.addEventListener(flash.events.Event.COMPLETE, onProcessComplete);
			dtm.process(true, 1, PublicSettings.FLASH_IDE_COMPILE);	
			
			
			trace("DSpriteSheet_GenericUI: cache exists:"+dtm.cacheExist())

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