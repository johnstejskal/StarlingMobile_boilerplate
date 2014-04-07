package view.components.gameobjects 
{

	import ManagerClasses.AssetsManager;
	import singleton.Core;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.deg2rad;
	import staticData.Data;
	import staticData.SpriteSheets;
	
	/**
	 * ...
	 * @author John Stejskal
	 * johnstejskal@gmail.com
	 * "Why walk when you can ride"
	 */
	public class GameObject extends Sprite
	{
		public var isActive:Boolean = false;
		private var _core:Core;
		private var _collisionArea:Image;
		


		//======================================o
		//-- Constructor
		//======================================o
		public function GameObject() 
		{
			//trace(this + "Constructed");
			_core = Core.getInstance();
			
			if (stage) init(null);
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
		}
		
		//======================================o
		//-- init
		//======================================o		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			
		}
		
		//======================================o
		//-- Event Handler
		//======================================o
		public function onUpdate(e:Event = null):void 
		{
			//trace(this + "onUpdate()");
		}
		
		//-----------------------------o
		//-- Event Handler
		//-----------------------------o
		public function initialize():void 
		{
			//trace(this + "onUpdate()");
		}
		
		//======================================o
		//-- Activate - wake up object
		//======================================o
		public function activate():void
		{
			isActive = true;
			
		}
		
		//======================================o
		//-- Deactivate - put object to sleep
		//======================================o
		public function deactivate():void
		{
			isActive = false;
			
		}
		
		//======================================o
		//-- trash/dispose/anihliate
		//======================================o		
		public function trash():void
		{
			trace(this+" trash()")
			this.removeEventListeners();
		}
		
		
		//======================================o
		//-- Getters | Setters
		//======================================o			
		public function get collisionArea():Image 
		{
			return _collisionArea;
		}
		
		
	}

}