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
	public class TrueSwipe 
	{
		private var _ptStartTouch:Point;
		private var _ptEndTouch:Point;
		private var _fnCallBack:Function;
		private var _touchTolerance:int = 50; //radius in which touch end must be from touch begin
		private var _maxTouchTime:int = 1000; // how long is allowed between touch begin and end 
		private var _gestureType:String;
		private var _isSingleMode:Boolean;
		private var _tmrTouchTime:Timer;
		private var _target:DisplayObject;
		
		public static const GESTURE_TOUCH:String = "touch";
		public static const GESTURE_SWIPE:String = "swipe";
		static public const RIGHT:String = "right";
		static public const LEFT:String = "left";
		
		public function TrueSwipe()
		{
			_tmrTouchTime = new Timer(_maxTouchTime, 1);
			_tmrTouchTime.addEventListener(TimerEvent.TIMER, onTouchTime_tick)
		}
		

		public function mapSwipe(touch:Touch):void 
		{
			_ptStartTouch = new Point(touch.globalX, touch.globalY)
			_tmrTouchTime.reset();
			_tmrTouchTime.start();
			
		}	
		
		public function checkSwipe(touch:Touch):String
		{
			var direction:String;
			_tmrTouchTime.stop();
			_ptEndTouch = new Point(touch.globalX, touch.globalY)
					
			if (dbp(_ptStartTouch, _ptEndTouch) > _touchTolerance && _tmrTouchTime.currentCount < 1)
			{
				if (_ptEndTouch.x > _ptStartTouch.x && dbp(new Point(0, _ptStartTouch.y), new Point(0, _ptEndTouch.y)) < 50)
				direction = RIGHT;
				else if (_ptEndTouch.x < _ptStartTouch.x && dbp(new Point(0, _ptStartTouch.y), new Point(0, _ptEndTouch.y)) < 50)
				direction = LEFT;
							
			}
				
			return direction

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
			_tmrTouchTime.removeEventListener(TimerEvent.TIMER, onTouchTime_tick);
			_tmrTouchTime = null;
			
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