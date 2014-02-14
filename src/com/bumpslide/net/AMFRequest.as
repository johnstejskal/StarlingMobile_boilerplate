package com.bumpslide.net 
{
	import flash.events.AsyncErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;
	import flash.net.Responder;
	import flash.utils.Dictionary;
	
	/**
	 * Flash Remoting method call
	 * 
	 * @author David Knape
	 */
	public class AMFRequest extends AbstractRequest implements IRequest
	{
		protected var _netConnection:NetConnection;
		protected var _gatewayUrl:String;		protected var _commandName:String;
		protected var _objectEncoding:uint=ObjectEncoding.AMF3;
		protected var _commandArgs:Array;
		protected var _amfResponder:Responder;
		
		// Active connections
		static protected var activeConnections:Dictionary=new Dictionary();
		

		
		/**
		 * Get exisiting NetConnection for a given URL
		 */
		static protected function getActiveConnection( url:String ):NetConnection {
			if(activeConnections[url]==null) {
				var nc:NetConnection = new NetConnection();
				nc.connect(url);
				activeConnections[url] = nc;
			}
			return activeConnections[url];
		}
	
		static protected function closeActiveConnection(url:String):void
		{
			var nc:NetConnection = activeConnections[url];
			if(nc!=null && nc.connected) {
				nc.close();
				delete activeConnections[url];
			}
		}
		
		
		/**
		 * Create a new AMF request that can be called/loaded
		 */
		public function AMFRequest(gateway_url:String, command_name:String, command_args:Array=null, responder:IResponder = null)
		{
			_commandArgs = command_args;
			_gatewayUrl = gateway_url;
			_commandName = command_name;	
			super(responder);
		}

		/**
		 * Setup event listeners and make the method call
		 */	
		override protected function initRequest():void
		{
			if(_netConnection==null) {
				_netConnection = AMFRequest.getActiveConnection( _gatewayUrl );
				netConnection.objectEncoding = objectEncoding;
			} 
			
			netConnection.addEventListener( NetStatusEvent.NET_STATUS, handleNetStatusEvent );
			netConnection.addEventListener( SecurityErrorEvent.SECURITY_ERROR, handleSecurityError );
			netConnection.addEventListener( IOErrorEvent.IO_ERROR, handleIOError );
			netConnection.addEventListener( AsyncErrorEvent.ASYNC_ERROR, handleAsyncErrorEvent );
			
			_amfResponder = new Responder( finishCompletedRequest, handleError);
			var args:Array = [commandName, _amfResponder].concat( commandArgs );
			netConnection.call.apply( netConnection, args ); 
		}
		
		
		private function handleError(error:Object):void
		{
			raiseError( String(error) );
		}

		
		private function handleAsyncErrorEvent(event:AsyncErrorEvent):void
		{
			raiseError( event.text );
		}

		
		private function handleIOError(event:IOErrorEvent):void
		{
			raiseError( event.text );
		}

		
		private function handleSecurityError(event:SecurityErrorEvent):void
		{
			raiseError( event.text );
		}

		
		private function handleNetStatusEvent(event:NetStatusEvent):void
		{
			if(event.info.level=='error') {
				raiseError( event.info.code );
			} else {
				trace( "NetStatus Event: " + event.info.code );
			}
		}

		
		override public function cancel():void
		{
			AMFRequest.closeActiveConnection( gatewayUrl );
			super.cancel();
		}
		
		
		
		
		override protected function killRequest():void
		{
			netConnection.removeEventListener( NetStatusEvent.NET_STATUS, handleNetStatusEvent );
			netConnection.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, handleSecurityError );
			netConnection.removeEventListener( IOErrorEvent.IO_ERROR, handleIOError );
			netConnection.removeEventListener( AsyncErrorEvent.ASYNC_ERROR, handleAsyncErrorEvent );
		}
		
		public function get gatewayUrl():String {
			return _gatewayUrl;
		}		
		
		public function get commandName():String {
			return _commandName;
		}
		
		
		public function get netConnection():NetConnection {
			return _netConnection;
		}
		
		
		public function get objectEncoding():uint {
			return _objectEncoding;
		}
		
		
		public function set objectEncoding(objectEncoding:uint):void {
			_objectEncoding = objectEncoding;
		}
		
		public function get commandArgs():Array {
			return _commandArgs;
		}
		
		
		public function set commandArgs(commandArgs:Array):void {
			_commandArgs = commandArgs;
		}

		
		override public function toString():String
		{
			return '[AMFRequest] ('+commandName+') '; 
		}
	}
}
