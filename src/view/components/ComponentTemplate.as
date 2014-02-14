package view.components
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
	public class ComponentTemplate extends MovieClip
	{
		
		
		private var _core:Core;
		
		
		//----------------------------------------o
		//------ Constructor 
		//----------------------------------------o
		public function ComponentTemplate():void 
		{
			_core = Core.getInstance();
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
		}
		
		
		//----------------------------------------o
		//------ Private functions 
		//----------------------------------------o		
		private function init(e:Event = null):void 
		{
			
			trace(this+" inited");
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
		}
		

		//----------------------------------------o
		//------ Public functions 
		//----------------------------------------o		
		

		
	}
	
}