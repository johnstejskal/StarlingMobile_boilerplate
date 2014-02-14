package view.components.screens
{

	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import ManagerClasses.StateMachine;
	import singleton.Core;
	import vo.*;


	/**
	 * @author John Stejskal
	 * "Why walk when you can ride"
	 */

	public class LoadingScreen extends Sprite
	{
	 /* 
	  * This is a native display component that appears during the loading of
	  * runtime asset data, ie between levels
	  */
		private var _core:Core;
		private var _bg:Shape;
		
		//----------------------------------------o
		//------ Constructor 
		//----------------------------------------o
		public function LoadingScreen():void 
		{
			
			_core = Core.getInstance();
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
			
		}
		
		//----------------------------------------o
		//------ Private functions 
		//----------------------------------------o		
		private function init(e:Event = null):void 
		{
			trace(this + " inited");

			_bg = new Shape; // initializing the variable named rectangle
			_bg.graphics.beginFill(0xFF0000); 
			_bg.graphics.drawRect(0, 0, Data.STAGE_WIDTH, Data.STAGE_HEIGHT);
			_bg.graphics.endFill();
			addChild(_bg); 
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		//----o Clean Up function
		private function onRemove(e:Event):void 
		{
			
		}

		//----------------------------------------o
		//------ Public functions 
		//----------------------------------------o		
		public function trash():void
		{
			trace(this + "trash()");
			this.parent.removeChild(this);
		}
		
	}
	
}