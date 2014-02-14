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
 package com.bumpslide.ui {
	import flash.events.MouseEvent;	
	
	import com.bumpslide.ui.behavior.DragZoomBehavior;

	import flash.display.DisplayObject;	

	/**
	 * Provides pan and zoom functionality for 'zoomable' content
	 * 
	 * @author David Knape
	 */
	public class ZoomPanel extends Panel {

		public var zoomTweenEnabled:Boolean=true;
		public var dragZoomControl:DragZoomBehavior;
		

		override protected function addChildren():void {
			super.addChildren();
			updateDelay = 0;
			addEventListener( MouseEvent.MOUSE_WHEEL, handleMouseWheel);
		}
		
		protected function handleMouseWheel(event:MouseEvent):void {
			var n:Number = Math.round( event.delta / 2 ); // tame that bitch	
			if(n>0) while(n--) zoomIn();
			else while(n++) zoomOut();
		}

		override protected function initContent():void {
			super.initContent();
			_holder.scrollRect = null;
		}
		
		override protected function setContentSize(w:Number, h:Number):void {	
			if(zoomContent) {
				zoomContent.setSize(w, h);
			}
		}

		override public function set content( c:DisplayObject ):void {
						
			if(dragZoomControl) dragZoomControl.remove();			
									
			var zoomableContent:ZoomableContent = new ZoomableContent();
			zoomableContent.content = c;
			
			super.content = zoomableContent;
			
			if(zoomableContent) {
				dragZoomControl = DragZoomBehavior.init(this, zoomContent);
			}
			
			zoomableContent.updateNow();
		}

		public function get zoomContent():ZoomableContent {
			return content as ZoomableContent;
		}	

		public function zoomIn():void {
			if(dragZoomControl) dragZoomControl.zoomIn();
		}

		public function zoomOut():void {
			if(dragZoomControl) dragZoomControl.zoomOut();
		}

		public function panTo( panX:Number, panY:Number ):void {
			if(dragZoomControl) dragZoomControl.panTo(panX, panY);
		}

		public function panLeft(dist:Number = 64):void {
			if(dragZoomControl) dragZoomControl.panLeft(dist);
		}

		public function panRight(dist:Number = 64):void {
			if(dragZoomControl) dragZoomControl.panRight(dist);
		}

		public function panUp(dist:Number = 64):void {
			if(dragZoomControl) dragZoomControl.panUp(dist);
		}

		public function panDown(dist:Number = 64):void {
			if(dragZoomControl) dragZoomControl.panDown(dist);
		}

		public function get zoom():Number {
			if(zoomContent) return zoomContent.zoom;
			else return 1;
		}

		public function set zoom(zoom:Number):void {
			if(dragZoomControl) dragZoomControl.zoomTo(zoom, zoomTweenEnabled);
		}

		public function refresh():void {
			if(zoomContent) zoomContent.refreshContentSize();
			invalidate();
		}
		
		public function reset() : void {
			if(zoomContent) zoomContent.reset();
		}
	}
}
