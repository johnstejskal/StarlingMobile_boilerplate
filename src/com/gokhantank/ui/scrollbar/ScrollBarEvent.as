package com.gokhantank.ui.scrollbar{
	import flash.events.*;
	public class ScrollBarEvent extends Event{
		public static const VALUE_CHANGED = "valueChanged";
		public var scrollPercent:Number;
		public function ScrollBarEvent(sp:Number):void{
			super(VALUE_CHANGED);
			scrollPercent = sp;
		}
	}
}