package view.components.ui.slideOutMenu
{
	
	import com.greensock.easing.Back;
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;
	import com.johnstejskal.Delegate;
	import com.johnstejskal.SharedObjects;
	import com.thirdsense.animation.TexturePack;
	import com.thirdsense.LaunchPad;
	import data.AppData;
	import data.constants.LaunchPadLibrary;
	import data.constants.SharedObjectKeys;
	import data.settings.PublicSettings;
	import ManagerClasses.utility.AssetsManager;
	import ManagerClasses.StateMachine;
	import singleton.Core;
	import singleton.EventBus;
	import starling.core.Starling;
	import starling.display.Image;
	import flash.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.utils.deg2rad;
	import starling.utils.HAlign;
	import starling.utils.VAlign;


	/**
	 * ...
	 * @author John Stejskal
	 * johnstejskal@gmail.com
	 * "Why walk when you can ride"
	 */
	public class SlideMenuItem extends Sprite
	{
		
		private var _displayName:String;
		private var _stateRef:String;
		private var _core:Core;
		private var _textureRef:String;
		private var _w:int;
		
		//-----------------------------o
		//-- Constructor
		//-----------------------------o
		public function SlideMenuItem(displayName:String, stateRef:String, dynamicVariant:int)
		{
			//trace(this + "Constructed");
			_core = Core.getInstance();
			
			_displayName = displayName;
			_stateRef = stateRef;
			
			if (stage)
				init(null);
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
			
			_textureRef = "TA_slideMenuItem" + dynamicVariant;
		
		}
		
		private function init(e:Event):void
		{
			//trace(this + "inited");
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			var mc:MovieClip = new TA_slideMenuItem();
			mc.$mcIcon.gotoAndStop(1);
			//determin which screens are considered 'new' for this verison
			if (PublicSettings.NEW_SECTIONS.indexOf(_stateRef) != -1)
			mc.$mcNotif.visible = true;
			else
			mc.$mcNotif.visible = false;
			
			//now determine which of the above screens has been seen by user
/*			var arrNewSectionsSeen:Array = SharedObjects.getProperty(SharedObjectKeys.NEW_SECTIONS_SEEN, true);
			
			if (arrNewSectionsSeen)
			{
				if (arrNewSectionsSeen.indexOf(_stateRef) != -1)
				{
					//state has been seen, hide icon
					mc.$mcNotif.visible = false;
				}
			}*/
			
			mc.$txLabel.text = _displayName;
			TexturePack.createFromMovieClip(mc, LaunchPadLibrary.SLIDE_MENU_DA, _textureRef, null, 1, 1, null, 0)
			
			var simMenuItem:Image = TexturePack.getTexturePack(LaunchPadLibrary.SLIDE_MENU_DA, _textureRef).getImage();
			this.addChild(simMenuItem);
			
			mc = null;
			
			this.addEventListener(TouchEvent.TOUCH, onTouch);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoved)
			
			this.scaleX = this.scaleY = AppData.deviceScale;
		}
		
		private function onTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(stage);
			if (touch)
			{
				if (touch.phase == TouchPhase.BEGAN)
				{
					EventBus.getInstance().sigSlideMenuAction.dispatch(SlideOutMenu.STATE_CLOSE);
					TweenLite.delayedCall(PublicSettings.SLIDE_MENU_OUT_SPEED, buttonAction)
					
				}
				
			}
		}
		
		private function buttonAction():void
		{
			trace("buttonAction :" + buttonAction);
			_core.controlBus.appUIController.changeScreen(_stateRef);
			
		}
		
		private function onRemoved(e:Event):void
		{
			//trace(this + "removed()");
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			trash();
		
		}
		
		public function trash():void
		{
			//trace(this + " trash()")
			this.removeFromParent();
			this.removeEventListeners();
			TexturePack.deleteTexturePack(LaunchPadLibrary.UI, _textureRef);
		
		}
		
		public function get w():int
		{
			return _w;
		}
	
	}

}