package com.gokhantank.ui.scrollbar{
	import flash.events.*;
	import flash.display.*;

	public class ScrollBar extends MovieClip {
		private var xOffset:Number;
		private var xMin:Number;
		private var xMax:Number;

		public function ScrollBar():void {
			xMin=0;
			xMax= track.width - thumb.width;

			thumb.addEventListener(MouseEvent.MOUSE_DOWN,thumbDown);
			stage.addEventListener(MouseEvent.MOUSE_UP,thumbUp);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL,mouseWheel);
			track.addEventListener(MouseEvent.CLICK,trackClick);
		}

		private function thumbDown(e:MouseEvent):void {
			stage.addEventListener(MouseEvent.MOUSE_MOVE,thumbMove);
			xOffset = mouseX - thumb.x;
		}

		private function thumbUp(e:MouseEvent):void {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,thumbMove);
		}

		private function thumbMove(e:MouseEvent):void {
			thumb.x = mouseX - xOffset;
			scrollContent(e);
		}

		private function mouseWheel(e:MouseEvent):void {
			thumb.x -= e.delta*2;
			scrollContent(e);
		}

		private function trackClick(e:MouseEvent):void {
			thumb.x =mouseX - thumb.height / 2;
			scrollContent(e);
		}

		private function scrollContent(e:MouseEvent):void {
			if (thumb.x >=xMax) {
				thumb.x = xMax;
			}
			if (thumb.x <=xMin) {
				thumb.x = xMin;
			}
			dispatchEvent(new ScrollBarEvent(thumb.x / xMax));
			e.updateAfterEvent();
		}
	}
}