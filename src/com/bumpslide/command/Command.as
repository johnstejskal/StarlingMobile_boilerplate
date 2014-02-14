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
	import com.bumpslide.command.ICommand;
	import com.bumpslide.net.IResponder;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getQualifiedClassName;	

	/**
	 * This is similar to a Cairngorm Command 
	 * 
	 * We've added some callback functionality
	 * that was inspired by the UM Cairngorm extensions 
	 * 
	 * Basically, a CommandEvent can also be a responder which gives
	 * view components a way to get called back directly when 
	 * a service call finishes or failts (result and fault, respoectively)
	 * 
	 * The notifyComplete and notifyError methods here facilitate these 
	 * callback notifications.  They also dispatch Event.COMPLETE events
	 * which are used to advance the CommandQueue if it is being used.
	 * 
	 * If you are not using the CommandEvent as a responder, and are not using 
	 * the command queue, you can safely ignore the notify methods and all 
	 * references to the callback responder. 
	 * 
	 * @author David Knape
	 */
	public class Command extends EventDispatcher implements ICommand {

		
		public var debugEnabled:Boolean=false;
		
		protected var _callback:IResponder;		
		
		public function execute(event:CommandEvent):void {
			debug('execute() eventData=' + event.data );
			callback = event;
			notifyComplete();
		}
		
		public function cancel() : void {
			debug('cancel()');
			notifyComplete();
		}
		
		/**
		 * Notifies callback of successful completion
		 */
		public function notifyComplete(data:Object=null) : void {
			debug('notifyComplete()');
			dispatchEvent( new Event(Event.COMPLETE) ); // used by CommandQueue to know when to advance
			if(callback) callback.result( data );
		}	
		
		/**
		 * Notifies callback of error
		 */
		public function notifyError(info:Object) : void {
			dispatchEvent( new Event(Event.COMPLETE) ); // used by CommandQueue to know when to advance
			if(callback) callback.fault( info );
		}
		
		public function debug( s:String ) : void {
			if(debugEnabled) trace( this + " " + s ); 
		}
		
		override public function toString():String {
			return "[Command:"+getQualifiedClassName(this).split('::').pop()+"]";
		}
		
		public function get callback():IResponder {
			return _callback;
		}
		
		public function set callback(callback:IResponder):void {
			_callback = callback;
		}
	}
}
