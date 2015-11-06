package com.johnstejskal 
{
	import com.greensock.loading.core.DisplayObjectLoader;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import starling.display.DisplayObject;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	/**
	 * ...
	 * @author John Stejskal
	 */
	public class TrueTouch 
	{
		private var _ptStartTouch:Point;
		private var _ptEndTouch:Point;
		private var _fnCallBack:Function;
		private var _touchTolerance:int = 20; //radius in which touch end must be from touch begin
		private var _maxTouchTime:int = 500; // how long is allowed between touch begin and end 
		private var _gestureType:String;
		private var _isSingleMode:Boolean;
		private var _tmrTouchTime:Timer;
		private var _target:DisplayObject;
		
		public static const GESTURE_TOUCH:String = "touch";
		public static const GESTURE_SWIPE:String = "swipe";
		
		public function TrueTouch()
		{
			_tmrTouchTime = new Timer(_maxTouchTime, 1);
			_tmrTouchTime.addEventListener(TimerEvent.TIMER, onTouchTime_tick)
		}
		
		
/*		public function TrueTouch(target:DisplayObject, fnCallBack:Function, gestureType:String = GESTURE_TOUCH, isSingleMode:Boolean = false) 
		{
			_target = target;
			_fnCallBack = fnCallBack;
			_gestureType = gestureType;
			_isSingleMode = isSingleMode;
			
			//init()
		}*/
		
		public function mapTouch(touch:Touch):void 
		{
			_ptStartTouch = new Point(touch.globalX, touch.globalY)
			_tmrTouchTime.reset();
			_tmrTouchTime.start();
			
		}	
		
		public function checkTouch(touch:Touch):Boolean
		{
			var b:Boolean = false;
			
			_tmrTouchTime.stop();
			_ptEndTouch = new Point(touch.globalX, touch.globalY)
			
			if (_tmrTouchTime != null && _ptStartTouch != null)
			{
				if (dbp(_ptStartTouch, _ptEndTouch) < _touchTolerance && _tmrTouchTime.currentCount < 1)
				b = true;
			}
					
			return b

		}
		
		//===========================================o	
		//------ Touch Handlers 
		//===========================================o	
		public function init():void
		{
			
			_tmrTouchTime = new Timer(_maxTouchTime, 1);
			_tmrTouchTime.addEventListener(TimerEvent.TIMER, onTouchTime_tick)
			
			switch(_gestureType)
			{
				case GESTURE_TOUCH:
				_target.addEventListener(TouchEvent.TOUCH, onTouch)
				break;
								
				case GESTURE_SWIPE:
				break;
				
			}
			
		}
		
		private function onTouchTime_tick(e:TimerEvent):void 
		{
			
		}
		
		//===========================================o	
		//------ Touch Handlers 
		//===========================================o		
		private function onTouch(e:TouchEvent):void 
		{
			var touch:Touch = e.getTouch(_target.stage);
            if(touch)
            {
				//------------------------------------------------o
                if(touch.phase == TouchPhase.BEGAN)
                {	
					trace("Touch began");
					_ptStartTouch = new Point(touch.globalX, touch.globalY)
					_tmrTouchTime.reset();
					_tmrTouchTime.start();

                }
				//------------------------------------------------o
                else if(touch.phase == TouchPhase.ENDED)
                {	
					_tmrTouchTime.stop();
					_ptEndTouch = new Point(touch.globalX, touch.globalY)
					
					switch(_gestureType)
					{
						//-------------------------------o	
						case GESTURE_TOUCH:
						if (dbp(_ptStartTouch, _ptEndTouch) < _touchTolerance && _tmrTouchTime.currentCount < 1)
						{
							_fnCallBack();
							if (_isSingleMode)
							trash();
						}
						break;
						//-------------------------------o			
						case GESTURE_SWIPE:
						break;
						//-------------------------------o	
						
					}

              
				}
				//------------------------------------------------o
                else if(touch.phase == TouchPhase.MOVED)
                {	
					

				}
            }
		}
		
		
		//===========================================o	
		//--- distance between Points
		//===========================================o	
		private function dbp(point1:Point, point2:Point):Number
		{
		var distance:Number = Math.sqrt( ( point1.x - point2.x ) * ( point1.x - point2.x ) + ( point1.y - point2.y ) * ( point1.y - point2.y ) );
		return distance
		}
		
		
		//===========================================o	
		//------ trash
		//===========================================o		
		public function trash():void
		{
			if(_tmrTouchTime != null)
			{
			_tmrTouchTime.removeEventListener(TimerEvent.TIMER, onTouchTime_tick);
			_tmrTouchTime = null;
			}
			
			if(_target != null)
			_target.removeEventListener(TouchEvent.TOUCH, onTouch);
			
		}
		

		
		
		//===========================================o	
		//------ Getter and setters 
		//===========================================o		
		public function get touchTolerance():int 
		{
			return _touchTolerance;
		}
		
		public function set touchTolerance(value:int):void 
		{
			_touchTolerance = value;
		}
		
		public function get maxTouchTime():int 
		{
			return _maxTouchTime;
		}
		
		public function set maxTouchTime(value:int):void 
		{
			_maxTouchTime = value;
		}
		
		
	}

}