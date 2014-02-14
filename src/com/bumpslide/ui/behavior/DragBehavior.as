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
 
package com.bumpslide.ui.behavior 
{
	import flash.utils.Timer;

	import com.bumpslide.util.Delegate;
	import com.bumpslide.events.DragEvent;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;	

	/**
	 * Draggable Behavior
	 * 
	 * @author David Knape
	 */
	public class DragBehavior {

		// track instances locally to aid in event management
		static private var _targets:Dictionary = new Dictionary(true);
		
		private var dragTarget:InteractiveObject;
		private var mouseStart:Point;
		private var spriteStart:Point;
		private var previousLoc:Point;
		private var velocity:Point;
		
		protected var _doDrag:Boolean = true;				protected var _isDragging:Boolean=false;
		protected var _dragBounds:Rectangle;
		protected var _justDragged:Boolean=false;
		protected var _validDragDistance:Number = 5;
		protected var _enabled:Boolean = true;
		protected var _trackVelocity:Boolean = false;
		
		private var velocityCheck:Timer;

		
		/**
		 * Attaches behavior to a button
		 */
		static public function init( drag_target:InteractiveObject, bounds:Rectangle = null, do_drag:Boolean = true):DragBehavior {
			return new DragBehavior(drag_target, bounds, do_drag);	
		}

		/**
		 * Removes behavior from a button
		 */
		static public function destroy(target:InteractiveObject):void {
			if(_targets[target] != null) (_targets[target] as DragBehavior).remove();
		}		

		/**
		 * Adds drag behavior to an interactive object 
		 */
		function DragBehavior( drag_target:InteractiveObject, bounds:Rectangle = null, do_drag:Boolean = true ) {		
			DragBehavior.destroy(drag_target);			
			dragTarget = drag_target;
			dragTarget.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
			_dragBounds = bounds;		
			_doDrag = do_drag;	
			_targets[dragTarget] = this;
		}

		/**
		 * removes event listeners, thus removing behavior
		 */
		public function remove():void {
			stopDragging();
			dragTarget.removeEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
			delete _targets[dragTarget];
		}

		/**
		 * Used to initiate drag from click on something other than the drag target
		 * 
		 * This was added so we could start dragging a scroll handle
		 * by clicking on the scrollbar background.  This requires a mouse event.
		 */
		public function startDragging(event:MouseEvent):void {
			handleMouseDown(event);
		}
		
		protected function handleMouseDown(event:MouseEvent):void {
			//trace(this + ' MOUSE DOWN ' +event.target );
			if(!enabled) return;
			if(event) event.stopPropagation();
			mouseStart = new Point(event.stageX, event.stageY);
			spriteStart = new Point(dragTarget.x, dragTarget.y);
			previousLoc = spriteStart.clone();	
			_justDragged = false;		
			dragTarget.stage.addEventListener(MouseEvent.MOUSE_MOVE, whileDragging);
			dragTarget.stage.addEventListener(MouseEvent.MOUSE_UP, stopDragging);
			dragTarget.stage.addEventListener(Event.MOUSE_LEAVE, stopDragging);			
			dragTarget.dispatchEvent(new DragEvent(DragEvent.EVENT_DRAG_START, spriteStart, spriteStart));			
		}

		protected function whileDragging(event:Event=null, velocityUpdate:Boolean=false):void {		
			
			Delegate.cancel( velocityCheck );
			
			var delta:Point = getDragDelta();
			
			// add delta to the starting location
			var targetLoc:Point = spriteStart.add(delta);			
			
			_isDragging = true;
			if(delta.length>_validDragDistance) {
				_justDragged = true;
			}
			if(_doDrag) {
				if(_dragBounds != null) {
					targetLoc.x = Math.min(Math.max(targetLoc.x, _dragBounds.left), _dragBounds.right);					targetLoc.y = Math.min(Math.max(targetLoc.y, _dragBounds.top), _dragBounds.bottom);
				}	
				dragTarget.x = targetLoc.x;				dragTarget.y = targetLoc.y;
			}
			velocity = targetLoc.subtract(previousLoc);			
			dragTarget.dispatchEvent(new DragEvent(DragEvent.EVENT_DRAG_MOVE, spriteStart, targetLoc, velocity));
			if(dragTarget is DisplayObjectContainer) { 
				(dragTarget as DisplayObjectContainer).mouseChildren=false;
			}
			previousLoc = targetLoc.clone();
			velocityCheck = Delegate.callLater( 100, resetVelocity );
		}
		
		
		private function getDragDelta():Point
		{
			//trace( this + ' whileDragging() ' );		
			var delta:Point = new Point(dragTarget.stage.mouseX - mouseStart.x, dragTarget.stage.mouseY - mouseStart.y);

			// get concatenated matrix and use it to transform the delta vector
			// to support dragging inside things that have been rotated
			var m:Matrix = dragTarget.transform.concatenatedMatrix;
			m.invert(); // MAP global-to-local, not local-to-global
			return m.deltaTransformPoint( delta ); // ignore tx and ty 
		}

		
		protected function resetVelocity():void
		{
			Delegate.cancel( velocityCheck );
			velocity = new Point(0,0);
			dragTarget.dispatchEvent(new DragEvent(DragEvent.EVENT_DRAG_MOVE, spriteStart, previousLoc, velocity));			
		}

		
		public function stopDragging(event:Event = null):void {		
			Delegate.cancel( velocityCheck );	
			if(velocity==null) velocity=new Point();
			_isDragging = false;
			dragTarget.stage.removeEventListener(MouseEvent.MOUSE_MOVE, whileDragging);
			dragTarget.stage.removeEventListener(MouseEvent.MOUSE_UP, stopDragging);
			dragTarget.stage.removeEventListener(Event.MOUSE_LEAVE, stopDragging);			
			dragTarget.dispatchEvent(new DragEvent(DragEvent.EVENT_DRAG_STOP, spriteStart, getDragDelta(), velocity));
			
			mouseStart = null;
			spriteStart = null;
			if(dragTarget is DisplayObjectContainer) { 
				(dragTarget as DisplayObjectContainer).mouseChildren=true;
			}
		}				public function get dragBounds():Rectangle {
			return _dragBounds;		}				public function set dragBounds(dragBounds:Rectangle):void {
			_dragBounds = dragBounds;		}
		
		/**
		 * Whether or not we are currently dragging
		 */
		public function get isDragging():Boolean {
			return _isDragging;
		}
		
		/**
		 * whether or not to actually update the x/y position of the drag target
		 */
		public function get doDrag():Boolean {
			return _doDrag;
		}
		
		/**
		 * whether or not to actually update the x/y position of the drag target
		 */
		public function set doDrag(doDrag:Boolean):void {
			_doDrag = doDrag;
		}
		
		/**
		 * Whether or not we just dragged more than the validDragDistance
		 */
		public function get justDragged():Boolean {
			return _justDragged;
		}
		
		/**
		 * drag distance required to make justDragged be true
		 */
		public function get validDragDistance():Number {
			return _validDragDistance;
		}
		
		/**
		 * drag distance required to make justDragged be true
		 */
		public function set validDragDistance(validDragDistance:Number):void {
			_validDragDistance = validDragDistance;
		}
		
		public function toString():String {
			return '[DragBehavior] (dragTarget:' + dragTarget +')';
		}
		
		public function get enabled():Boolean {
			return _enabled;
		}
		
		public function set enabled(enabled:Boolean):void {
			_enabled = enabled;
		}
	}
}
