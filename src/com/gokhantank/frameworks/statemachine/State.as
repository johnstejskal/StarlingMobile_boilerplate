package com.gokhantank.frameworks.statemachine {
	import flash.events.EventDispatcher;
	
	public class State extends EventDispatcher {
		
		public var name:String;
		public var elements:Object = {};
		public var elementCount:int = 0;
		
		public function State($name:String, ... rest) {
			// Rest should be all state elements.
			for (var i:uint = 0; i < rest.length; i++) {
				name = $name;
				elements[rest[i].name] = rest[i];
				elementCount++;
			};
		}
		
		public override function toString():String {
			return '[State Object] ' + name;
		}
		
		public function createElementInstance(elementName:String):* {
			trace('STATE_OBJECT: Creating state element "' + elementName + '" as ' + elements[elementName].classDefinition);
			var elementInstance:* = new elements[elementName].classDefinition();
			elements[elementName].instance = elementInstance;
			trace("elementInstance: "+elementInstance);
			dispatchEvent(new StateEvent(StateEvent.STATE_ELEMENT_INITIALIZED, name, elements[elementName].instance));
			trace('STATE_OBJECT:2');
			return elementInstance;
		}
		
		public function getElementInstance(elementName:String):IStateElement {
			// Initialize if not yet initialized.
			if (elements[elementName].instance == null) {
				elements[elementName].instance = createElementInstance(elementName);
			};
			
			return elements[elementName].instance;
		}
	}
	
}