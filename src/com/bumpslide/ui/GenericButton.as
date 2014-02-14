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
	import flash.filters.BevelFilter;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;	

	/**
	 * Labeled Button with Background
	 * 
	 * This is a code-only LabelButton implementation.
	 * 
	 * @author David Knape
	 */
	public class GenericButton extends LabelButton {

		private var _backgroundColor:Number = 0xaaaaaa;		private var _backgroundOverColor:Number = 0x888888;		private var _textColor:Number = 0x333333;		private var _textOverColor:Number = 0x000000;
		private var _backgroundSelectedColor:Number = 0x666666;
		private var _textSelectedColor:Number = 0xeeeeee;

		// optional children 
		public var background:Box;
		
		public function GenericButton(w:Number=200, h:Number=20,x:Number = 0, y:Number = 0, label_text:String = "", clickHandler:Function = null) {
			super();
			if(clickHandler != null) {
				addEventListener(MouseEvent.CLICK, eventDelegate(clickHandler));
			}			
			setSize( w, h);
			move(x, y);
			label = label_text;
		}

		override protected function addChildren():void {
			createBackground();
			createLabel();
			super.addChildren();
		}
		
		private function createBackground():void {
			background = new Box(backgroundColor);
			background.alpha = .9;
			background.cornerRadius = 4;
			background.filters = [new GlowFilter(0x000000, .3, 2, 2, 1, 2), new BevelFilter(1, 45, 0xffffff, .5, 0x000000, .5, 1, 1, 1, 2)];
			
			// make this clip the autosized background clip
			autosize_background = background;
			
			addChild(background);
		}

		private function createLabel():void {
			label_txt = new TextField();
			label_txt.defaultTextFormat = new TextFormat("Helvetica Neue", 10, textColor, true);
			addChild(label_txt);
			autoSizeWidth = true;
		}
				override public function _over():void {
			background.color = backgroundOverColor;
			label_txt.textColor = textOverColor;
		}

		override public function _off():void {
			background.color = backgroundColor;
			label_txt.textColor = textColor;
		}

		override public function _selected():void {
			background.color = backgroundSelectedColor;
			label_txt.textColor = textSelectedColor;
		}

		public function get backgroundColor():Number {
			return _backgroundColor;
		}

		public function set backgroundColor(backgroundColor:Number):void {
			_backgroundColor = backgroundColor;
			invalidate();
		}

		public function get backgroundOverColor():Number {
			return _backgroundOverColor;
		}

		public function set backgroundOverColor(backgroundOverColor:Number):void {
			_backgroundOverColor = backgroundOverColor;
			invalidate();
		}

		public function get textColor():Number {
			return _textColor;
		}

		public function set textColor(textColor:Number):void {
			_textColor = textColor;
			invalidate();
		}

		public function get textOverColor():Number {
			return _textOverColor;
		}

		public function set textOverColor(textOverColor:Number):void {
			_textOverColor = textOverColor;
			invalidate();
		}

		public function get backgroundSelectedColor():Number {
			return _backgroundSelectedColor;
		}

		public function set backgroundSelectedColor(backgroundSelectedColor:Number):void {
			_backgroundSelectedColor = backgroundSelectedColor;
		}

		public function get textSelectedColor():Number {
			return _textSelectedColor;
		}

		public function set textSelectedColor(textSelectedColor:Number):void {
			_textSelectedColor = textSelectedColor;
		}

	}
}
