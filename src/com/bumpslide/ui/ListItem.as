package com.bumpslide.ui {
	import com.bumpslide.ui.GridItem;
	import com.bumpslide.util.Align;	

	/**
	 * Default Item renderer for the Grid Component
	 * 
	 * This class simply takes the grid item data and 
	 * displays it as a string.
	 * 
	 * Note that GridItem extends Button, so we can use 
	 * the _over,  _off, and selected button states.
	 * 
	 * @author David Knape
	 */
	public class ListItem extends GridItem {

		protected var textbox:TextBox;
		protected var background:Box;

		override protected function addChildren():void {
			super.addChildren();
			background = new Box(0xeeeeee);
			addChild(background);		
			textbox = new TextBox();
			textbox.x = 10;
			textbox.wordWrap = false;
			addChild(textbox);
		}

		override protected function draw():void {
			textbox.setSize(width-12, height);
			background.setSize(width, height);
			Align.middle(textbox, height);
			super.draw();
		}

		override protected function drawGridItem():void {
			if(gridItemData != null) {
				var lbl:String =  gridItemData.toString();
				try {
					lbl = gridItemData.label;
				} catch (e:Error) {}
				textbox.htmlText = lbl;
			} else textbox.htmlText = "";
		}

		override public function _over():void {
			background.alpha = .2;
		}

		override public function _off():void {
			background.alpha = .05;
		}
		
		override public function _selected():void {
			background.alpha = .3;						
		}
	}
}
