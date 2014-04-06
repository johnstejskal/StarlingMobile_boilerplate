package view
{
	import interfaces.iScreen;
	import ManagerClasses.StateMachine;
	import singleton.EventBus;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;


	
	/**
	 * ...
	 * @author john stejskal
	 * "Why walk when you can ride"
	 */
	public class StarlingStage extends Sprite implements iScreen
	{
		

		//========================================o
		//------ Constructor
		//========================================o
		public function StarlingStage():void 
		{
			trace(this + " StarlingStage()");

			StateMachine.oStarlingStage = this;

			if (stage) EventBus.getInstance().sigStarlingStageReady.dispatch();
			else addEventListener(Event.ADDED_TO_STAGE, function(e:Event = null):void{StateMachine.evtStarlingStageReady()});
		}
		

		//========================================o
		//-- Screen Touch events
		//========================================o
		private function onTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(stage);
			if(touch)
			{
				//trace(this + "onTouch(" + touch.phase + ")");
				
				if(touch.phase == TouchPhase.BEGAN)
				{
					
				}
 
				else if(touch.phase == TouchPhase.ENDED)
				{
					
				}
 
				else if(touch.phase == TouchPhase.MOVED)
				{
					
				}
			}
 
		}
		
		//========================================o
		//-- Enter Frame - Main Game Loop
		//========================================o
		private function update_gameLoop(e:Event):void 
		{

		}


		//========================================o
		//-- Trash/Dispose/Kill/Anihliate
		//========================================o	
		public function trash():void
		{
		  this.removeEventListeners();
			
		}

	
		

		

		


		


		

			
		
		
	}
	
}