package view.components.screens
{

	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import interfaces.iScreen;
	import ManagerClasses.StateMachine;
	import singleton.Core;
	import staticData.*;


	/**
	 * @author John Stejskal
	 * "Why walk when you can ride"
	 */

	public class LoadingScreen extends Sprite implements iScreen
	{
	 /* 
	  * This is a native display top level component that appears during the loading of
	  * starling runtime asset data, ie between levels
	  */
		private var _core:Core;
		private var _bg:Shape;
		
		
		//=========================================o
		//------ Constructor 
		//=========================================o
		public function LoadingScreen():void 
		{
			_core = Core.getInstance();
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
			
		}
		
		//=========================================o
		//------ Init 
		//=========================================o	
		private function init(e:Event = null):void 
		{
			trace(this + " inited");
			_bg = new Shape; // initializing the variable named rectangle
			_bg.graphics.beginFill(0xFF0000); 
			_bg.graphics.drawRect(0, 0, Data.deviceResX, Data.deviceResY);
			_bg.graphics.endFill();
			addChild(_bg); 
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
		}
		
		//=========================================o
		//------ On Remove 
		//=========================================o
		private function onRemove(e:Event):void 
		{
			
		}

		//=========================================o
		//------ kill/dispose/destroy 
		//=========================================o
		public function trash():void
		{
			trace(this + "trash()");
			this.parent.removeChild(this);
		}
		
	}
	
}