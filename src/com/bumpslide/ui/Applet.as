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
	import com.bumpslide.ui.Component;
	import com.bumpslide.util.StageProxy;
	
	import flash.events.Event;	
	/**
	 * Basic Applet with stage proxy
	 * 
	 * @author Default
	 */
	public class Applet extends Component {

		protected var stageProxy:StageProxy;

		override protected function init():void {
			debugEnabled = true;						
			stageProxy = StageProxy.getInstance();
			stageProxy.addEventListener(Event.RESIZE, onStageResize);					
			super.init();	
		}

		override protected function onAddedToStage(e:Event):void {
			super.onAddedToStage(e);
			stageProxy.init(stage); // <-- only need to do this once per app
		}

		protected function onStageResize(e:Event ):void {
			debug('stageProxy resized '+stageProxy.width+','+stageProxy.height);
			setSize(stageProxy.width, stageProxy.height);
		}
	}
}