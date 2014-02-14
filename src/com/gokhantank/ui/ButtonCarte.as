package com.gokhantank.ui
{
	import caurina.transitions.Tweener;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	/**
	$(CBI)* ...
	$(CBI)* @author Gokhan Tank
	$(CBI)*/
	public class ButtonCarte extends Component
	{
		public static const MOUSE_OVER:String = "mouse_over";
		public static const MOUSE_OUT:String = "mouse_out";
		public static const MOUSE_UP:String = "mouse_up";
		public static const MOUSE_CLICK:String = "mouse_clicked";
		
		public var $over:MovieClip;
		
		public function ButtonCarte() 
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
			Tweener.addTween($over, {alpha:0,time:.7,transition:"easeOutCubic" } );
			dispatchEvent(new Event(MOUSE_OUT));
		}
		
		private function onMouseOver(e:MouseEvent):void 
		{
			onMouseOverA();
			dispatchEvent(new Event(MOUSE_OVER));
			
		}
		private function onMouseOverA():void {
			Tweener.addTween($over, {alpha:1,time:.5,transition:"easeOutCubic",onComplete:onMouseOverB } );
		}
		private function onMouseOverB():void
		{
			Tweener.addTween($over, {alpha:0,time:.5,transition:"easeInCubic",onComplete:onMouseOverA } );
		}
		override public function set enabled( buttonEnabled:Boolean ):void {
			useHandCursor = buttonEnabled;
			mouseEnabled = buttonEnabled;
		}
		public function set isEnabled(b:Boolean):void {
			$over.alpha = 0;
			(b)? this.filters = [] : this.filters = [new BlurFilter(2, 2, 5)];

		}
		public function set isSelected(b:Boolean):void {
			if(b){
				enabled = false;
				removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
				$over.alpha = 1;
			}else{
				enabled = true;
				addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
				$over.alpha = 0;
			}
		}
	}

}