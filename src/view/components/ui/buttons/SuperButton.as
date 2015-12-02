package view.components.ui.buttons 
{
	import com.johnstejskal.Position;
	import com.thirdsense.animation.TexturePack;
	import com.thirdsense.LaunchPad;
	import data.AppData;
	import data.constants.LaunchPadLibrary;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;
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
		private var _skin:Class;
		private var _pivotPos:String;
		private var _w:Number;
		private var _h:Number;
		
		public function SuperButton(skin:Class, label:String, callback:Function, ref:String = "", param:String = null, pivotPos:String = null)
		{
			_callback = callback;
			_ref = ref;
			_skin = skin;
			_label = label;
			_param = param;
			_pivotPos = pivotPos;

			this.addEventListener(Event.ADDED_TO_STAGE, init);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoved)
		}
		
		//=======================================o
		//-- init
		//=======================================o
		private function init(e:Event):void 
		{
		   trace(this + "inited");
		
		   var mc:* = new _skin();
		   mc.scaleX = mc.scaleY = AppData.deviceScaleY;
		   mc.$txLabel.text = _label;
		   TexturePack.createFromMovieClip(mc, _ref, getQualifiedClassName(_skin), null, 1, 2, null, 0);
		   _mcBtn = TexturePack.getTexturePack(_ref, getQualifiedClassName(_skin)).getMovieClip();
    
		   _mcBtn.addEventListener(TouchEvent.TOUCH, onTouch)
		   _w = _mcBtn.width;
		   _h = _mcBtn.height;
			
			this.addChild(_mcBtn);
		   
			//set buttons pivot pos
			if (_pivotPos)
			{
				switch(_pivotPos)
				{
					case Position.CENTER:
					_mcBtn.pivotX = _w / 2;  _mcBtn.pivotY = _h / 2;
					break;
					//--------------------o
					case Position.TOP_LEFT:
					_mcBtn.pivotX = _mcBtn.pivotY = 0;
					break;
					//--------------------o
					case Position.TOP_CENTER:
					_mcBtn.pivotX = _w/2; _mcBtn.pivotY = 0;
					break;
					//--------------------o
					case Position.TOP_RIGHT:
					_mcBtn.pivotX = _w; _mcBtn.pivotY = 0;
					break;
					//--------------------o
					case Position.BOTTOM_LEFT:
					_mcBtn.pivotX = 0; _mcBtn.pivotY = _h;
					break;
					//--------------------o
					case Position.BOTTOM_CENTER:
					_mcBtn.pivotX = _w/2; _mcBtn.pivotY = _h;
					break;
					//--------------------o
					case Position.BOTTOM_RIGHT:
					_mcBtn.pivotX = _w; _mcBtn.pivotY = _h;
					break;
					
				}
			}
			
			

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