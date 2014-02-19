package view.components.gameobjects.superClass 
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
		private var _core:Core;
		private var _collisionArea:Image;
		


		//-----------------------------o
		//-- Constructor
		//-----------------------------o
		public function GameObject() 
		{
			trace(this + "Constructed");
			_core = Core.getInstance();
			
			if (stage) init(null);
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
		}
		//-----------------------------o
		//-- init
		//-----------------------------o		
		private function init(e:Event):void 
		{
			trace(this + "inited");
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			this.addEventListener(Event.ENTER_FRAME, onUpdate)
			
		}
		//-----------------------------o
		//-- Event Handler
		//-----------------------------o
		private function onUpdate(e:Event):void 
		{
			
		}
		
		//-----------------------------o
		//-- trash/dispose/anihliate
		//-----------------------------o		
		public function trash():void
		{
			trace(this+" trash()")
			
		}
		
		
		//-----------------------------o
		//-- Getters | Setters
		//-----------------------------o			
		public function get collisionArea():Image 
		{
			return _collisionArea;
		}
		
		
	}

}