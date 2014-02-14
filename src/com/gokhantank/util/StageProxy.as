package com.gokhantank.util
{
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	/**
	$(CBI)* ...
	$(CBI)* @author Gokhan Tank
	$(CBI)*/
	public class StageProxy extends EventDispatcher
	{
		
		public function StageProxy() 
		{
			
		}
		static private var instance:StageProxy;
		private var _stage:Stage;
		public static const EVENT_RESIZE:String = "event_resize";
		public static const STAGE_UP:String = "stage_up";
		public static const STAGE_MOVE:String = "stage_move";
		public static const STAGE_LEAVE:String = "stage_leave";
        private var _width:Number;
        private var _height:Number;
    
        public static function get self() : StageProxy {
            if(instance==null) instance = new StageProxy();
            return instance;
		}
		public function init(inStage:Stage) : void { 
			if (_stage) return;
			_stage = inStage;
			trace("_stage: " + _stage);
			_width = stage.stageWidth;
			_height = stage.stageHeight;
            // ---------------------------------------------------
            _stage.scaleMode = StageScaleMode.NO_SCALE;
            _stage.align = StageAlign.TOP_LEFT;
            _stage.stageFocusRect = false;
           _stage.addEventListener(Event.RESIZE, onStageResized );
		   _stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
		   _stage.addEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove);
		   _stage.addEventListener(Event.MOUSE_LEAVE, onStageLeave);
        }
		
		private function onStageLeave(e:Event):void 
		{

			dispatchEvent(new Event(STAGE_LEAVE));
		}
		
		private function onStageMouseMove(e:MouseEvent):void 
		{
			dispatchEvent(new Event(STAGE_MOVE));
			e.updateAfterEvent();
		}
		
		private function onStageMouseUp(e:MouseEvent):void 
		{
			//trace(this + ".onStageMouseUp");
			dispatchEvent(new Event(STAGE_UP));
		}
		
		public function onStageResized(e:Event = null):void
		{
			_width = stage.stageWidth;
			_height = stage.stageHeight;
			dispatchEvent(new Event(EVENT_RESIZE));
		}
		
		public function get stage():Stage { 
			return _stage; 
		}
		
		public function get stageWidth():Number { return _stage.stageWidth; }
		
		public function set width(value:Number):void 
		{
			_width = value;
		}
		
		public function get stageHeight():Number { return _stage.stageHeight; }
		
		public function set height(value:Number):void 
		{
			_height = value;
		}
	}

}