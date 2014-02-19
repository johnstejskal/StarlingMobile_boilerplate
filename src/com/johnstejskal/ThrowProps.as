package com.johnstejskal {
	
	
    import flash.display.MovieClip;
    import flash.display.Shape;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import flash.utils.getTimer;
    import com.greensock.TweenLite;
    import com.greensock.easing.Strong;
    import com.greensock.plugins.TweenPlugin;
    import com.greensock.plugins.ThrowPropsPlugin;
	import flash.events.TouchEvent;	
    import flash.geom.Rectangle;
	import staticData.DataVO;
	
     
    public class ThrowProps extends MovieClip {
        private var bounds : Rectangle;
		private var _dragBounds : Rectangle;
        private var mc : MovieClip;
        private var t1:uint, t2:uint, y1:Number, y2:Number, x1:Number, x2:Number;
        private var _targetMC:MovieClip; 
		
        public function ThrowProps(targetMC:MovieClip) {
            TweenPlugin.activate([ThrowPropsPlugin]);
			_targetMC = targetMC;
            initialize();
        }
         
        private function initialize():void {
			 mc = _targetMC;
			// mc.cacheAsBitmap = true;
           // bounds = new Rectangle(-128, 0, 768+128, 1024);
			//bounds = new Rectangle( 0, 0, 768 + 128, 400);
			bounds = new Rectangle( 0, 0, mc.stage.width, 400);
			_dragBounds = new Rectangle( -1908, 30, 2000, 0);
           
            setUpTPBounds(mc, bounds);
            
			
			if (!DataVO.DEVICE_RELEASE)
			{
			mc.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			}
			else
			{
			mc.addEventListener(TouchEvent.TOUCH_BEGIN, touchDownHandler);
			}			
			
        }
 
         private function touchDownHandler(e:TouchEvent):void 
		 {
            TweenLite.killTweensOf(mc);
            x1 = x2 = mc.x;
           // y1 = y2 = mc.y;
            t1 = t2 = getTimer();
			
			mc.startTouchDrag(e.touchPointID, false, _dragBounds);
			mc.stage.addEventListener(TouchEvent.TOUCH_END, touchUpHandler);
            mc.addEventListener(TouchEvent.TOUCH_MOVE, touchMove);
            
        }   
		
        private function mouseDownHandler(e:MouseEvent):void 
		{
            TweenLite.killTweensOf(mc);
            x1 = x2 = mc.x;
           // y1 = y2 = mc.y;
            t1 = t2 = getTimer();
			
            mc.startDrag(false, _dragBounds);
			mc.stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
            mc.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
            
        }
 
        private function enterFrameHandler(event:Event):void {
                x2 = x1;
                y2 = y1;
                t2 = t1;
                x1 = mc.x;
                y1 = mc.y;
                t1 = getTimer();
				
        }
        private function touchMove(event:TouchEvent):void {
                x2 = x1;
                y2 = y1;
                t2 = t1;
                x1 = mc.x;
                y1 = mc.y;
                t1 = getTimer();
				
        }		
        private function touchUpHandler(e:TouchEvent):void {
            mc.stopTouchDrag(e.touchPointID);
            mc.stage.removeEventListener(TouchEvent.TOUCH_END, touchUpHandler);
			
            mc.removeEventListener(TouchEvent.TOUCH_MOVE, touchMove);
            var time:Number = (getTimer() - t2) / 1000;
            var xVelocity:Number = (mc.x - x2) / time;
           // var xOverlap:Number = Math.max(0, mc.width - bounds.width);
			var xOverlap:Number = Math.max(0, mc.width - 800);
           // var yVelocity:Number = (mc.y - y2) / time;
          //  var yOverlap:Number = Math.max(0, mc.height - bounds.height);
            ThrowPropsPlugin.to(mc, {throwProps:{
                                       //  y:{velocity:yVelocity, max:bounds.top, min:bounds.top - yOverlap, resistance:300},
                                         x:{velocity:xVelocity, max:bounds.left, min:bounds.left - xOverlap, resistance:300}
                                     }, ease:Strong.easeOut
									 }, 10, 0.3, 1);
		}   
		
        private function mouseUpHandler(e:MouseEvent):void {
            mc.stopDrag();
            mc.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			
            mc.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
            var time:Number = (getTimer() - t2) / 1000;
            var xVelocity:Number = (mc.x - x2) / time;
           // var xOverlap:Number = Math.max(0, mc.width - bounds.width);
			var xOverlap:Number = Math.max(0, mc.width - 800);
           // var yVelocity:Number = (mc.y - y2) / time;
          //  var yOverlap:Number = Math.max(0, mc.height - bounds.height);
            ThrowPropsPlugin.to(mc, {throwProps:{
                                       //  y:{velocity:yVelocity, max:bounds.top, min:bounds.top - yOverlap, resistance:300},
                                         x:{velocity:xVelocity, max:bounds.left, min:bounds.left - xOverlap, resistance:300}
                                     }, ease:Strong.easeOut
                                    }, 10, 0.3, 1);
        }
 
        private function setUpTPBounds(container : MovieClip, bounds : Rectangle):void {
            var crop:Shape = new Shape();
            crop.graphics.beginFill(0xFF0000, 1);
            crop.graphics.drawRect(bounds.x, bounds.y, bounds.width, bounds.height);
            crop.graphics.endFill();
            container.x = bounds.x;
           // container.y = bounds.y;
            container.parent.addChild(crop);
            container.mask = crop;
        }
 
 
    }
     
}