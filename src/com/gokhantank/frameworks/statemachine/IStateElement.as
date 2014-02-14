package com.gokhantank.frameworks.statemachine {
	
	import flash.events.IEventDispatcher;
	
	public interface IStateElement extends IEventDispatcher {
		function integrate(objects:Array):void;
		function enter(screenName:String,params:Object):void;
		function exit():void;
	}
}