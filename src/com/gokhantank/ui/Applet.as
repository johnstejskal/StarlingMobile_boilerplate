package com.gokhantank.ui 
{
	import flash.display.Stage;
	import flash.events.Event;
	import com.gokhantank.ui.Component
	import com.gokhantank.util.StageProxy;
	/**
	$(CBI)* ...
	$(CBI)* @author Gokhan Tank
	$(CBI)*/
	public class Applet extends Component
	{
		protected var stageProxy:StageProxy;
		
		public function Applet():void {
			trace(this + ".Applet");
		}
		override protected function init():void {
			stageProxy = StageProxy.self;
			stageProxy.addEventListener(Event.RESIZE, onStageResized);
			super.init();
		}
		
		override protected function onAddedToStage(e:Event):void {
			super.onAddedToStage(e);
			stageProxy.init(stage);
		}
		
		protected function onStageResized(e:Event):void {
			debug('stageProxy resized '+stageProxy.stageWidth+','+stageProxy.stageHeight);
		}
		
	}
	
}