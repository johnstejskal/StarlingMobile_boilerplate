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

package com.bumpslide.ui 
{
	import com.bumpslide.data.type.Padding;

	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * Auto-sizing Text Box
	 * 
	 * Best practice is to make a clip in your library that uses this as a Base class.
	 * Put a text field on the stage and name it content_txt.  Line up the top left pixel
	 * of the first letter with 0,0 for best results.
	 * 
	 * Note, the height getter is overriden to return textHeight of an 
	 * autosized textfield.
	 * 
	 * This class is used inside of the TextPanel component which provides
	 * scrolling text behavior.
	 * 
	 * @see com.bumpslide.ui.TextPanel
	 *   
	 * @author David Knape
	 */
	public class TextBox extends Component 
	{

		// extra pixels added to height getter to be sure text doesn't get cut off
		public static var HEIGHT_ERROR_CORRECTION:int = 5;

		// default width of new text boxes when constructing from code
		public static var DEFAULT_WIDTH:int = 200;

		// the content text field
		public var content_txt:TextField;

		// default text format
		protected var _defaultTextFormat:TextFormat;

		// padding around text field
		protected var _padding:Padding = new Padding(0);

		// original position of content_txt 
		protected var _textOffsetX:Number = 0;

		protected var _textOffsetY:Number = 0;

		// content tet
		protected var _text:String = "";

		// whether or not we're using HTML
		protected var _html:Boolean = false;

		// max lines to display
		protected var _maxLines:uint = 0;

		// validation constants
		protected static const VALID_TEXT:String = "validText";

		
		function TextBox( txt:String = "", txtFormat:TextFormat = null):void 
		{
			if(content_txt) {
				_defaultTextFormat = content_txt.getTextFormat();
				// prevent off-pixel text
				content_txt.scaleX = content_txt.scaleY = 1; 
				content_txt.x = Math.round(content_txt.x);
				content_txt.y = Math.round(content_txt.y);
			} else {
				_defaultTextFormat = (txtFormat != null) ? txtFormat : new TextFormat('Verdana', 13, 0x8C9299,null,'italic');
			}
			
			super();
			
			if(_width == 0) _width = DEFAULT_WIDTH;
			if(txt != "") text = txt;
		}

		
		override protected function addChildren():void 
		{
			
			if(content_txt == null) {
				content_txt = new TextField();
				addChild(content_txt);
				textFormat = _defaultTextFormat;
			} else {
				_textOffsetX = content_txt.x;
				_textOffsetY = content_txt.y;
			}
			
			// Make sure text is multiline and set to autoSize
			content_txt.autoSize = TextFieldAutoSize.LEFT;
			content_txt.multiline = true;
			content_txt.wordWrap = true;	
			
			updateDelay = 0;
		}	

		
		override protected function draw():void 
		{
			content_txt.y = Math.round(_textOffsetY + padding.top);
			content_txt.x = Math.round(_textOffsetX + padding.left);
			content_txt.width = width - padding.width;	
			
			if(_html) {
				content_txt.htmlText = _text;
			} else {
				content_txt.visible = false;
				content_txt.text = _text;
				
				// check max lines			
			
				if(maxLines > 0 && content_txt.numLines > maxLines) {	
					
					// subject about 3 characters from width to allow room for '...'
					//var edgeSize:Number = (textFormat.size as Number) * 3;
					//trace('edgeSize: ' + (edgeSize));
					//content_txt.width -= edgeSize;			
					
					var txt:String = "";
					for(var n:int = 0;n < maxLines;n++) {
						txt += content_txt.getLineText(n);
					}
					if(_text.length > txt.length) {
						txt = txt.substr(0, txt.length - 3) + "...";						
					}
					// add extra space back in 
					//content_txt.width += edgeSize;
					content_txt.text = txt;
				}
				content_txt.visible = true;
			}			
			
			
			super.draw();
		}

		
		public function get textFormat():TextFormat {
			return content_txt.getTextFormat();
		}

		
		public function set textFormat( tf:TextFormat ):void {
			content_txt.defaultTextFormat = tf;
			content_txt.setTextFormat(tf);
			invalidate();
		}

		
		public function set text( s:String ):void {
			if(s == null) s = "";
			_text = s;
			_html = false;
			invalidate(VALID_TEXT);
		}

		
		public function set htmlText( s:String ):void {
			if(s == null) s = "";
			_text = s;
			_html = true;
			invalidate(VALID_TEXT);
		}

		
		public function get text():String {
			return _text;
		}

		
		public function get htmlText():String {
			return _text;
		}

		
		override public function get height():Number {
			return content_txt.textHeight + HEIGHT_ERROR_CORRECTION + padding.height;
		}

		
		public function get padding():Padding {
			return _padding;
		}

		
		public function set padding(padding:*):void {
			if(padding is Number) _padding = new Padding(padding);
			else if (padding is Padding) _padding = padding;
		}

		
		public function set wordWrap(val:Boolean):void {
			content_txt.wordWrap = val;
			content_txt.multiline = val;
		}

		
		public function get maxLines():uint {
			return _maxLines;
		}

		
		public function set maxLines(maxLines:uint):void {
			_maxLines = maxLines;
			invalidate();
		}
	}
}
