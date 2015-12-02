package view.components.examples 
{

	import ManagerClasses.utility.AssetsManager;
	import org.gestouch.core.Gestouch;
	import org.gestouch.events.GestureEvent;
	import org.gestouch.extensions.starling.StarlingDisplayListAdapter;
	import org.gestouch.extensions.starling.StarlingTouchHitTester;
	import org.gestouch.gestures.SwipeGesture;
	import org.gestouch.input.NativeInputAdapter;
	import singleton.Core;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.deg2rad;
	import data.settings.DeviceSettings;
	import view.components.gameobjects.superClass.GameObject;
	import data.Data;
	import data.constants.SpriteSheets;
	
	/**
	 * ...
	 * @author John Stejskal
	 * johnstejskal@gmail.com
	 * "Why walk when you can ride"
	 */
	public class GestouchExample
	{
		private var _core:Core;
		
		private var _collisionArea:Image;
		
		//images
		private var _imgSomeImage:Image;
		private var _quFill:Quad;
		
		//mc's
		private var _smcSomeMoveClip:MovieClip;
		

		//-----------------------------o
		//-- Constructor
		//-----------------------------o
		public function GestouchExample() 
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
			
			/* this code should be put  starling is initialized 
			Gestouch.inputAdapter ||= new NativeInputAdapter(stage);
			Gestouch.addDisplayListAdapter(starling.display.DisplayObject, new StarlingDisplayListAdapter());
			Gestouch.addTouchHitTester(new StarlingTouchHitTester(_starling), -1);
			*/
			
			if (DeviceSettings.ENABLE_GESTURES)
			{
			//Set the type of Gesture we want to listen for
			//------------------o
			//--  SWIPE
			//------------------o
			var swipe:SwipeGesture = new SwipeGesture(this);
			swipe.addEventListener(GestureEvent.GESTURE_RECOGNIZED, onSwipeRec);
			}
			
		}
		
		
		//----------------------------------------------------------------------o
		//------ Gesture Swipe Handlers 
		//----------------------------------------------------------------------o			
		private function onSwipeRec(e:GestureEvent):void
		{
			var swipeGesture:SwipeGesture = e.target as SwipeGesture;
			
			trace("GESTURE RECOGNIZED");
			//----- RIGHT SWIPE
			if (swipeGesture.offsetX > 6)
			{
				trace(this +	"onSwipeRec().right");
			}
			//----- LEFT SWIPE
			else if (swipeGesture.offsetX < -6)
			{
				trace(this +	"onSwipeRec().left");
			}
			//----- UP SWIPE
			else if (swipeGesture.offsetY < -6)
			{
				trace(this +	"onSwipeRec().up");				
			}
			//----- DOWN SWIPE
			else if (swipeGesture.offsetY > 6) 
			{
				trace(this +	"onSwipeRec().down");
			}
			
		}			

		
		
	}

}