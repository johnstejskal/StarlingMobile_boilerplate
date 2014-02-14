package view.components.ui
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import singleton.Core;

	
	/**
	 * ...
	 * @author john stejskal
	 */
	public class DevConsole extends FL_devPanel
	{
		
		
		private var _core:Core;
		private var _mobs:int = 100;
		private var _waves:int = 1;
		private var _delay:int = 5000;
		
		//----------------------------------------o
		//------ Constructor 
		//----------------------------------------o
		public function DevConsole():void 
		{
			_core = Core.getInstance();
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
		}
		
		public function trash():void 
		{
			this.$mcStart.removeEventListener(MouseEvent.CLICK, onClick_start);
			this.parent.removeChild(this);
		}
		
		
		//----------------------------------------o
		//------ Private functions 
		//----------------------------------------o		
		private function init(e:Event = null):void 
		{
			
			trace(this+" inited");
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			this.$mcStart.addEventListener(MouseEvent.CLICK, onClick_start, false, 0, true)
		}
		
		private function onClick_start(e:MouseEvent):void 
		{
			trace(this + " click");
			if(this.$txMobs.text !="")
			_mobs = int(this.$txMobs.text);
			
			if(this.$txWaves.text !="")
			_waves = int(this.$txWaves.text);
			
			if(this.$txDelay.text !="")
			_delay = int(this.$txDelay.text);
			
			//_core.cl_playScreen.spawnEnemies(_mobs, _waves, _delay);
		}
		

		//----------------------------------------o
		//------ Public functions 
		//----------------------------------------o		
		

		
	}
	
}