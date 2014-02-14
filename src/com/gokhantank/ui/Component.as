package com.gokhantank.ui
{
	import caurina.transitions.Tweener;
	import flash.display.MovieClip;
	import flash.events.Event;
	import org.flashdevelop.utils.FlashConnect;
	/**
	$(CBI)* ...
	$(CBI)* @author Gokhan Tank
	$(CBI)*/
	
	public class Component extends MovieClip
	{
		public  var debugEnabled:Boolean = false;
		public function Component():void {
			init();
		}
		protected function init():void {
			addChildren();
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		protected function addChildren():void{

		}
		
		protected function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		public function show():void {
			if(!this.visible) this.visible = true;
		}
		public function hide():void {
			if (this.visible) this.visible = false;
		}
		public function sleep():void {
			
		}
		public function moveTo(xPos:Number,yPos:Number):void {
			this.x = xPos;
			this.y = yPos;
		}
		protected function debug( s:* ) : void {
			if (debugEnabled) trace( this + ' ' + s );
		}
		public function trace(s:*):void {
			
			FlashConnect.trace(s);
		}
	}

}