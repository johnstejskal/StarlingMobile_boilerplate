package view.components.screens.mvcScreen.view 
{
	import starling.display.Sprite;
	/**
	 * ...
	 * @author 
	 */
	public class MvcScreenView extends Sprite
	{
		private var model:*;
		private var controller:*;
		
		public function MvcScreenView(model:*, controller:*) 
		{
			this.model = model;
			this.controller = controller;	
		}
		
		
		
		
		public function trash():void 
		{
			this.removeFromParent();
		}
		
		public function init():void 
		{
			
		}
		
	}

}