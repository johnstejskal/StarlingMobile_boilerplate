/**
 * This code is part of the Bumpslide Library by David Knape
 * http://bumpslide.com/
 * 
 * Copyright (c) 2006, 2007, 2008 by Bumpslide, Inc.
 * 
 * Released under the open-source MIT license.
 * http://www.opensource.org/licenses/mit-license.php
 * see LICENSE.txt for full license terms
 */
 package com.bumpslide.command {
	import com.bumpslide.net.IResponder;
	
	import flash.events.Event;	

	/**
	 * This is like a CairngormEvent.  It triggers an application command.
	 * 
	 * We've added built a responder interface for notifying views directly
	 * when an asynchronous process has finished.  
	 * 
	 * Commands must store the event as it's callback in order to make this work.
	 *  
	 * @author David Knape
	 */
	public class CommandEvent extends Event implements IResponder {

		public var data:*;
		public var resultHandler:Function=null;		public var faultHandler:Function=null;

		public function CommandEvent(type:String, data:Object=null, resultHandler:Function=null, faultHandler:Function=null ) {
			super(type, true);
			this.data = data;
			this.resultHandler = resultHandler;
			this.faultHandler = faultHandler;
		}

		override public function clone():Event {
			return new CommandEvent(type, data);
		}

		/**
		 * Dispatch the command via the command event dispatcher
		 */
		public function dispatch():Boolean {
			return CommandEventDispatcher.getInstance().dispatchEvent(this);
		} 

		override public function toString():String {
			return '[CommandEvent] "' + type + '" data=' + data;
		}
		
		public function fault(info:Object):void {
			if(faultHandler != null) {
				try {
					faultHandler.call(null, data);
				} catch (e:ArgumentError) {
					faultHandler.call(null);
				}
			}
		}

		public function result(data:Object):void {
			if(resultHandler != null) {
				try {
					resultHandler.call(null, data);
				} catch (e:ArgumentError) {
					resultHandler.call(null);
				}
			}
		}
		
		// Send Generic Command Event
        static public function send( type:String, data:Object=null, resultHandler:Function=null, faultHandler:Function=null) : void {
        	var cmd:CommandEvent = new CommandEvent( type, data, resultHandler, faultHandler );
        	cmd.dispatch();
        } 
	}
}
