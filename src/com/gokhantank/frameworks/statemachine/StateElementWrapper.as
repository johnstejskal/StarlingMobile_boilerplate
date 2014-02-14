package com.gokhantank.frameworks.statemachine {
	
	public class StateElementWrapper extends Object {
		
		public var name:String;
		public var classDefinition:Class;
		public var instance:*;
		
		public function StateElementWrapper($name:String, $class:Class) {
			name = $name;
			classDefinition = $class;
		}
		
		public function toString():String {
			return '[State Element Wrapper] ' + classDefinition + ' ' + name;
		}
		
	}
	
}