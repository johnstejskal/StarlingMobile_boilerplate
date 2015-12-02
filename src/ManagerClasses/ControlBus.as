package ManagerClasses 
{

	import ManagerClasses.controllers.AppUIController;
	import singleton.Core;
	import view.components.ui.form.FormFieldDropDown;
	import view.components.ui.toolbar.TitleBar;
	import view.StarlingStage;
	/**
	 * ...
	 * @author John Stejskal
	 */
	public class ControlBus 
	{

		public var appUIController:AppUIController;
		
		
		public function ControlBus(starlingStage:StarlingStage) 
		{
			appUIController = new AppUIController(starlingStage);
		}
		
		public function hideStageText():void 
		{
			
		}
				
		public function showStageText():void 
		{
			
		}
		
		public function showOptionList(optionsList:Array, formFieldDropDown:FormFieldDropDown):void 
		{
			
		}
		
		public function removeNotification():void 
		{
			
		}
		
		public function removeLoadingScreen():void 
		{
			
		}
		

		
		
	}

}