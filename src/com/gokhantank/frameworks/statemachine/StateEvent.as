﻿package com.gokhantank.frameworks.statemachine {
	import flash.events.Event;
	
	public class StateEvent extends Event {
		
		public static const STATE_ELEMENT_INITIALIZED:String = 'state_element_initialized';
		
		public static const STATE_ELEMENT_ENTER_BEGIN:String = 'state_element_enter_begin';
		public static const STATE_ELEMENT_ENTER_COMPLETE:String = 'state_element_enter_complete';
		public static const STATE_ELEMENT_EXIT_BEGIN:String = 'state_element_exit_begin';
		public static const STATE_ELEMENT_EXIT_COMPLETE:String = 'state_element_exit_complete';
		public static const STATE_ELEMENT_CHANGE_INITIALIZED:String = 'state_element_change_initialized';
		
		public static const STATE_ENTER_BEGIN:String = 'state_enter_begin';
		public static const STATE_ENTER_COMPLETE:String = 'state_enter_complete';
		public static const STATE_EXIT_BEGIN:String = 'state_exit_begin';
		public static const STATE_EXIT_COMPLETE:String = 'state_exit_complete';
		
		public var stateName:String;
		public var stateElement:IStateElement;
		public var param:Object;
		
		public function StateEvent(type:String, $stateName:String = '', $stateElement:* = null,_param:Object=null, bubbles:Boolean=true, cancelable:Boolean=false) { 
			super(type, bubbles, cancelable);
			stateName = $stateName;
			stateElement = $stateElement
			param = _param;
		} 
		
		public override function clone():Event { 
			return new StateEvent(type, stateName, stateElement, bubbles, cancelable);
		} 
		
		public override function toString():String { 
			return formatToString("StateEvent", "stateName", "stateElement", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
}