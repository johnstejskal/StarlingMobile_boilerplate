package com.gokhantank.ui
{
	import caurina.transitions.Tweener;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	/**
	$(CBI)* ...
	$(CBI)* @author Gokhan Tank
	$(CBI)*/
	public class Button extends Sprite
	{
		public static const MOUSE_OVER:String = "mouse_over";
		public static const MOUSE_OUT:String = "mouse_out";
		public static const MOUSE_UP:String = "mouse_up";
		public static const MOUSE_CLICK:String = "mouse_clicked";
		
		public var $over:MovieClip;
		public var $btn:MovieClip;
		
		public function Button() 
		{
			buttonMode = true;
			mouseChildren = false;
			focusRect = false;
			$over.alpha = 0;
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseClicked);
		}
		
		private function onMouseUp(e:MouseEvent):void 
		{
			dispatchEvent(new Event(MOUSE_UP));
		}
		
		private function onMouseClicked(e:MouseEvent):void
		{
			dispatchEvent(new Event(MOUSE_CLICK));
			
		}
		private function onMouseOut(e:MouseEvent):void 
		{
			Tweener.addTween( $over,{ alpha:0,time:.7,transition:"easeOutCubic" } );
			dispatchEvent(new Event(MOUSE_OUT));
		}
		
		private function onMouseOver(e:MouseEvent):void 
		{
			Tweener.addTween( $over,{ alpha:1,time:.7,transition:"easeOutCubic" } );
			dispatchEvent(new Event(MOUSE_OVER));
			
		}
		public function get enabled():Boolean { return _enabled; }
		public function set enabled(b:Boolean) { 
			if (_enabled != b) {
				_enabled = b;
				if (_enabled) {
					mouseChildren = false;
					buttonMode = true;
					$btn.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
					$btn.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
					$btn.addEventListener(MouseEvent.MOUSE_UP, onMouseRelease);
				} else {
					buttonMode = false;
					mouseChildren = true;
					$btn.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
					$btn.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
					$btn.removeEventListener(MouseEvent.MOUSE_UP, onMouseRelease);
				};
			};
		}
	}

}