package view.components.screens.mvcScreen.model 
{
	import flash.events.EventDispatcher;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author 
	 */
	public class MvcScreenModel extends EventDispatcher
	{
		public var sig_stateChange:Signal;
		public var sig_gameOver:Signal;
		
		public function MvcScreenModel() 
		{
			
		}
		
		public function evt_gameOver():void 
		{
			
		}
		
		public function bindEvents():void evt_gameOver
		{
			sig_gameOver = new Signal();
			sig_gameOver.add(evt_gameOver)
		}
		
	}

}