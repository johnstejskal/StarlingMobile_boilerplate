package view.components.examples 
{

	import ManagerClasses.AssetsManager;
	import singleton.Core;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.deg2rad;
	import staticData.settings.DeviceSettings;
	import view.components.gameobjects.superClass.GameObject;
	import staticData.Data;
	import staticData.SpriteSheets;
	
	/**
	 * ...
	 * @author John Stejskal
	 * johnstejskal@gmail.com
	 * "Why walk when you can ride"
	 */
	public class TouchEventsExample
	{
		private var _core:Core;
		
		private var _collisionArea:Image;
		
		//images

		private var _imgButton:Image;
		

		//-----------------------------o
		//-- Constructor
		//-----------------------------o
		public function TouchEventsExample() 
		{
			trace(this + "Constructed");
			_core = Core.getInstance();
			
			if (stage) init(null);
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
		}
		
		private function init(e:Event):void 
		{
			trace(this + "inited");
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			this.addEventListener(TouchEvent.TOUCH, onTouch)
			
		}
		
		
		//----------------------------------------------------------------------o
		//------ Event Handlers 
		//----------------------------------------------------------------------o			
		//----------------------------------------------------------------------o
		//------ Touch Handlers 
		//----------------------------------------------------------------------o	
		private function onTouch(e:TouchEvent):void 
		{
			var touch:Touch = e.getTouch(stage);
            if(touch)
            {
				//trace(this + "onTouch(" + touch.phase + ")");
				
                if(touch.phase == TouchPhase.BEGAN)
                {				
					if (e.target == _imgButton)
					{
						
					}
					
                }
 
                else if(touch.phase == TouchPhase.ENDED)
                {

                }
 
                else if(touch.phase == TouchPhase.MOVED)
                {
                            
                }
            }
		}
				

		
		
	}

}