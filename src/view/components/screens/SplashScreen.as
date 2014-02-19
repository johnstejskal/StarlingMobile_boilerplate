package view.components.screens 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import interfaces.iScreen;
	import singleton.Core;



	/**
	 * @author John Stejskal
	 * "Why walk when you can ride"
	 */
	public class SplashScreen extends Sprite implements iScreen
	{
	
	private var _core:Core;

	
		//[Embed(source = "../../../../assets/images/bg/splashbg.jpg")]

		public function SplashScreen() 
		{

			_core = Core.getInstance();

			this.addEventListener(Event.ADDED_TO_STAGE, init);
	
		}
		
		
		private function init(e:Event):void 
		{
			trace(this+ "inited");
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
		}
		

		public function trash():void 
		{
			trace(this + "trash()");
			
			this.parent.removeChild(this);
		}		
		
	}

}