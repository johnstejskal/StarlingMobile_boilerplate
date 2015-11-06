package view.components.ui.buttons 
{
	import com.thirdsense.animation.TexturePack;
	import com.thirdsense.LaunchPad;
	import data.AppData;
	import data.constants.LaunchPadLibrary;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	/**
	 * ...
	 * @author John Stejskal
	 */
	public class SuperButton extends Sprite
	{
		
		private var _simButton:Image;
		private var _simContent:Image;

		private var _mcBtn:MovieClip;
		private var _ref:String;
		private var _callback:Function;
		private var _label:String;
		private var _param:String;
		
		public function SuperButton(label:String, callback:Function, ref:String = "", param:String = null)
		{
			
			_callback = callback;
			_ref = ref;
		    _mcBtn.addEventListener(TouchEvent.TOUCH, onTouch)
		    this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoved)
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		//=======================================o
		//-- init
		//=======================================o
		private function init(e:Event):void 
		{
		   trace(this + "inited");

		   var mc:* = LaunchPad.getAsset(LaunchPadLibrary.UI, "TA_genericButton");
		   mc.scaleX = mc.scaleY = AppData.deviceScaleY;
		   mc.$txLabel.text = _label;
		   TexturePack.createFromMovieClip(mc, _ref, "TA_genericButton", null, 1, 2, null, 0)
		   _mcBtn = TexturePack.getTexturePack(_ref, "TA_genericButton").getMovieClip();

		   this.addChild(_mcBtn);
		   

		}
		
		private function onRemoved(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			trash();
		}

		
		//=======================================o
		//-- On Touch Event handler
		//=======================================o		
		private function onTouch(e:TouchEvent):void 
		{
			if (!stage) return;
			
            var touch:Touch = e.getTouch(stage);
			var pt:Point = new Point();
			var bounds:Rectangle = _mcBtn.getBounds(_mcBtn);

			if (touch == null)
			return;
			
			pt = touch.getLocation(_mcBtn);
			
			
            if(touch)
            {
                if(touch.phase == TouchPhase.BEGAN)
                {				
					_mcBtn.currentFrame = 1;
					
                }
				//-------------------------------------------------------------------o
                else if(touch.phase == TouchPhase.ENDED)
                {
					_mcBtn.currentFrame = 0;

					if (bounds.containsPoint(pt))
					{
						 if (_callback != null)
						{
							if (_param != null)
							_callback(_param); 
							else
							_callback(); 
						}
						
					}
							  
                }
				//-------------------------------------------------------------------o
                else if(touch.phase == TouchPhase.MOVED)
                {
					if (!bounds.containsPoint(pt))
					{
						_mcBtn.currentFrame = 0;
							  
					 }	            
                }
            }
		}
		
		
		//=========================================o
		//------ dispose/kill/terminate/
		//=========================================o
		public function trash():void
		{
			trace(this + "trash()");
			//_tt.trash();
			//_tt = null
			this.removeEventListeners();
			TexturePack.deleteTexturePack(_ref)
			this.removeFromParent();
		}
	}

}