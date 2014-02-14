package com.bumpslide.ui 
{

	/**
	 * A checkbox is just a toggle button
	 * 
	 * @author David Knape
	 */
	public class CheckBox extends LabelButton {

		override protected function addChildren():void {
			super.addChildren();
			autoSizeWidth = false;
			toggle = true;
		}
	}
}
