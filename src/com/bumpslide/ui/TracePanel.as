package com.bumpslide.ui 
{
	import com.bumpslide.data.type.Padding;

	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;

	/**
	 * Panel for displaying messages in your app.  
	 * 
	 * By default, this panel will be collapsed and right aligned. 
	 * It is designed to fit nicely with the framerate monitor.
	 * 
	 * For most apps, using external logging tools is ideal, but 
	 * every now and then you just need a quick on-screen tracer.
	 * This does the trick.
	 * 
	 * Double-clicking on the panel background clears the log.
	 * 
	 * root.addChild( new TracePanel() );
	 * TracePanel.trace( "Hello" );
	 * 
	 * @author David Knape
	 */
	public class TracePanel extends Sprite {
		
		static public const ALIGN_RIGHT:String = "right";
		static public const ALIGN_LEFT:String = "left";
		
		static private var instance:TracePanel;
		
		public var panel:TextPanel;

		private var _open:Boolean = true;
		private var _alignment:String = "right";
		
		/**
		 * Add a message to the trace panel
		 */
		static public function log( s:String ):void {
			if(!instance) return;
			instance.panel.text += "\n" + s;
			instance.panel.updateNow();
			instance.panel.scrollPosition = Number.MAX_VALUE;
		}

		/**
		 * Clear the trace panel
		 */
		static public function clear(e:Event = null):void {
			if(!instance) return;
			instance.panel.text = "";
		}

		function TracePanel(textColor:Number = 0xeeeeee, backgroundColor:Number = 0x000000, backgroundAlpha:Number = .5, align:String = "right") {
			
			if(instance) throw new Error('You can only have one TracePanel');
			instance = this;
			
			// set alignment
			_alignment = align;
			
			// default position (under framerate monitor)
			y = 30;
			
			// create a text panel
			panel = new TextPanel();
			panel.padding = new Padding(22, 1, 1, 1);
			panel.setSize(200, 300);
			
			// set colors
			panel.backgroundBox.color = backgroundColor;
			panel.backgroundBox.fillAlpha = backgroundAlpha;
			panel.textFormat = new TextFormat( "Verdana", 9, textColor );
			
			// style
			panel.scrollbarWidth = 12;
			panel.gap = 2;
			panel.scrollbar.alpha = .5;
			panel.scrollbar.background.blendMode = BlendMode.ADD;
			panel.scrollbar.handle.blendMode = BlendMode.ADD;
			panel.tweenEnabled = false;
						
			// 'tracelog' button
			var btn:GenericButton = new GenericButton(48, 16, 150, 2, "tracelog", togglePanel);
			btn.label_txt.defaultTextFormat = new TextFormat( "Verdana", 9, textColor );
			btn.autoSizeWidth = true;
			btn.blendMode = BlendMode.ADD;
			btn.alpha = .5;
			
			addChild(panel);
			addChild(btn);
			
			// clear panel on background double-click
			panel.backgroundBox.mouseChildren = false;
			panel.backgroundBox.doubleClickEnabled = true;
			panel.backgroundBox.addEventListener(MouseEvent.DOUBLE_CLICK, clear);
			
			panel.updateNow();			
			togglePanel();
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		private function togglePanel():void {
			_open = !_open;			
			if(_open) {
				panel.scrollRect = new Rectangle(0,0,200,300);
				panel.x = 0;
			} else {
				panel.x = 148;
				panel.scrollRect = new Rectangle(148,0,52,20);
			}
		}

		private function onAddedToStage(e:Event):void {
			stage.addEventListener(Event.RESIZE, onStageResize);
			onStageResize();
		}

		private function onStageResize(e:Event = null):void {
			if( _alignment==ALIGN_RIGHT ) {
				x = (stage.stageWidth - 200) - 3;
			}        	
		}
	}
}
