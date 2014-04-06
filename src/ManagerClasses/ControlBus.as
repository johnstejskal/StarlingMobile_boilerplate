package ManagerClasses 
{

	import globalControllers.ControllerAppUI;
	import singleton.Core;
	import view.StarlingStage;
	/**
	 * ...
	 * @author John Stejskal
	 */
	public class ControlBus 
	{

		public var controller_appUI:ControllerAppUI;
		
		
		public function ControlBus(starlingStage:StarlingStage) 
		{
			controller_appUI = new ControllerAppUI(starlingStage);
		}
		
		

		

		
	}

}