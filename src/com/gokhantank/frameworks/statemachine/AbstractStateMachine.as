package com.gokhantank.frameworks.statemachine {
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class AbstractStateMachine extends EventDispatcher {
		
		public var states:Object = {};
		public var currentState:String;
		public var nextState:String;
		public var stateLock:Boolean = false;
		public var exitingStateElementCount:int;
		public var enteringStateElementCount:int;
		public var nextScreen:String;
		public var nextParam:Object;
		
		public function AbstractStateMachine() {
			/* if ($states) { states = $states }; */
		}
		
		public override function toString():String {
			if (currentState == null) {
				return '[State Machine] uninitialized state machine.';
			} else {
				return '[State Machine] in state "' + currentState + '"';
			}
		}
		
		public function addState(state:State):void {
			states[state.name] = state;
			state.addEventListener(StateEvent.STATE_ELEMENT_INITIALIZED, onStateElementInitialized);
		}
		
		public function getState(stateName:String):State {
			return states[stateName];
		}
		
		public function changeState(stateName:String, screenName:String, param:Object):Boolean {
			
			if (stateLock == true) {
				trace('STATE_MACHINE: State is locked. State change failed');
				return false
			};
			
			if (states[stateName] == null) {
				trace('STATE_MACHINE: [ERROR] Can not change to an unknown state: ' + stateName);
				return false;
			};
			
			stateLock = true;
			
			trace('STATE_MACHINE: ----------------------------------');
			
			if (currentState != null) {
				trace('STATE_MACHINE: Changing state from "' + currentState + '" to "' + stateName + '"');
				nextState = stateName;
				nextScreen = screenName
				nextParam = param;
				exitState(currentState);
			} else {
				trace('STATE_MACHINE: Initializing to state "' + stateName + '" (change state)');
				enterState(stateName,screenName,param);
			};
				
			return true;
		}
		
		public function enterState(stateName:String,screenName:String=null,param:Object=null):Boolean {
			
			var state:State = getState(stateName);
			
			if (state == null) {
				trace('STATE_MACHINE: [ERROR] Can not enter an unknown state: ' + stateName);
				return false;
			};
			
			trace('STATE_MACHINE: ----------------------------------');
			trace('STATE_MACHINE: Entering state "' + stateName + '"');
			
			currentState = stateName;
			nextState = null;
			nextScreen = null;
			nextParam = {};
			nextParam = null;
			
			enteringStateElementCount = state.elementCount;
			
			// Go over elements in the relevant state.
			for	(var elementName:String in state.elements) {
				var element:IStateElement = state.getElementInstance(elementName);
				
				element.addEventListener(StateEvent.STATE_ELEMENT_ENTER_COMPLETE, onStateElementEnterComplete);
				dispatchEvent(new StateEvent(StateEvent.STATE_ELEMENT_ENTER_BEGIN, stateName, element));
				element.enter(screenName,param);
				
			};
			
			dispatchEvent(new StateEvent(StateEvent.STATE_ENTER_BEGIN, stateName));
			
			return true;
		}
		
		public function exitState(stateName:String):Boolean {
			
			var state:State = getState(stateName);
			if (state == null) {
				trace('STATE_MACHINE: [ERROR] Can not exit an unknown state: ' + stateName);
				return false;
			};
			
			exitingStateElementCount = state.elementCount;
			// Go over elements in the relevant state.
			for	(var elementName:String in state.elements) {
				var element:IStateElement = state.getElementInstance(elementName);
				
				// Initialize if not yet initialized.
				element.addEventListener(StateEvent.STATE_ELEMENT_EXIT_COMPLETE, onStateElementExitComplete);
				dispatchEvent(new StateEvent(StateEvent.STATE_ELEMENT_EXIT_BEGIN, stateName, element));
				element.exit();
			};
			dispatchEvent(new StateEvent(StateEvent.STATE_EXIT_BEGIN, stateName));
			
			return true;
		}
		
		public function walkThroughStateElements(state:Object, methodName:String):void {
			for	(var elementName:String in state.elements) {
				var element:IStateElement = state.getElementInstance(elementName);
				element[methodName]();
			};
		}
		
		public function onStateElementEnterComplete(e:Event):void {
			trace('STATE_MACHINE: State element finished entering. (' + e.target + ')');
			
			var stateElement:Object = e.target;
			
			
			stateElement.addEventListener(StateEvent.STATE_ELEMENT_CHANGE_INITIALIZED, onStateElementChangeInitialized);
			
			stateElement.removeEventListener(StateEvent.STATE_ELEMENT_ENTER_COMPLETE, onStateElementEnterComplete);
			dispatchEvent(new StateEvent(StateEvent.STATE_ELEMENT_ENTER_COMPLETE, currentState, e.target));
			
			enteringStateElementCount--;
			if (enteringStateElementCount == 0) {
				trace('STATE_MACHINE: All state elements finished entering.');
				dispatchEvent(new StateEvent(StateEvent.STATE_ENTER_COMPLETE, currentState));
				stateLock = false;
			};
		}
		
		private function onStateElementChangeInitialized(e:StateEvent):void
		{
			trace(this+"e.param: "+e.param.wineId);
			dispatchEvent(new StateEvent(StateEvent.STATE_ELEMENT_CHANGE_INITIALIZED,null,null,e.param));
		}
		
		public function onStateElementExitComplete(e:Event):void {
			trace('STATE_MACHINE: State element finished exiting. (' + e.target + ')');
			
			var stateElement:Object = e.target;
			
			stateElement.removeEventListener(StateEvent.STATE_ELEMENT_EXIT_COMPLETE, onStateElementExitComplete);
			dispatchEvent(new StateEvent(StateEvent.STATE_ELEMENT_EXIT_COMPLETE, currentState, e.target));
			
			exitingStateElementCount--;
			if (exitingStateElementCount == 0) {
				trace('STATE_MACHINE: All state elements finished exiting.');
				dispatchEvent(new StateEvent(StateEvent.STATE_EXIT_COMPLETE, currentState));
				if (nextState != null) { 
					enterState(nextState, nextScreen, nextParam); 
				};
			};
		}
		
		private function onStateElementInitialized(e:StateEvent):void {
			// Just a bubbling mechanism really.
			dispatchEvent(new StateEvent(StateEvent.STATE_ELEMENT_INITIALIZED, e.stateName, e.stateElement));
		}
		
		public function getStateElementCount(stateName:String):uint {
			var count:uint = 0;
			for (var se:String in states[stateName].elements) {
				count++;
			};
			return count;
		}
		
	}
}