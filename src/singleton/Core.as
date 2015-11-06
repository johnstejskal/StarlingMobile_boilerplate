﻿package singleton  {		import flash.display.MovieClip;	import flash.display.Stage;	import ManagerClasses.*	import starling.animation.Juggler;	import starling.core.Starling;	import view.components.*;	import flash.events.EventDispatcher;	import view.components.ui.*;		public class Core  extends EventDispatcher{				private static var instance: Core;		private static var _privateNumber:Number = Math.random();		public var starling:Starling;				//----------------------------------------o		//------ Declare Classes 		//----------------------------------------o						//FrameWork Classes		public var main:Main;		public var nativeStage:Stage;		public var animationJuggler:Juggler; 				public var controlBus:ControlBus;										//----------------------------------------o		//------ public functions 		//----------------------------------------o				public function Core(num:Number=NaN) {			if(num !== _privateNumber){				throw new Error("An instance of Singleton already exists. Try Core.getInstance()");			}		}				public static function getInstance() : Core {			if ( instance == null ) instance = new Core(_privateNumber);			return instance as Core;		} 	}	}