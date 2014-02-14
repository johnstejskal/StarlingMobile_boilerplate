package com.gokhantank.ui.scrollbar{
	import flash.events.*;
	import flash.display.*;
	import caurina.transitions.*;
	
	public class ScrollBox extends MovieClip {
		public var mc:MovieClip;
		
		public var $mc:MovieClip;
		public var $mask:MovieClip;
		public var $up:MovieClip;
		public var $down:MovieClip;
		public function ScrollBox(_mc:MovieClip):void {
			mc = _mc;
			mc.hello_mc.x =150;
			mc.scrollBox.sb.addEventListener(ScrollBarEvent.VALUE_CHANGED, sbChange);
		}
		private function sbChange(e:ScrollBarEvent){
			Tweener.addTween(mc.scrollBox.content,{x:-e.scrollPercent*(mc.scrollBox.content.width-mc.scrollBox.masker.width),time:1});
		}

	}
}
