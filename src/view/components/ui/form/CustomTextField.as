package view.components.ui.form 
{
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	import staticData.AppFonts;
	import staticData.HexColours;
	/**
	 * ...
	 * @author John Stejskal
	 */
	public class CustomTextField extends TextField
	{
		private var _width:Number = 100;
		private var _height:Number = 100;
		private var _text:String = "default";
		private var _fontName:String = AppFonts.FONT_ARIAL;
		private var _fontSize:Number = 20;
		private var _color:uint = HexColours.WHITE;
		private var _bold:Boolean = false;
		private var _vAlign:String = VAlign.TOP;
		private var _hAlign:String = HAlign.CENTER;
		private var _autoSize:String = TextFieldAutoSize.VERTICAL;
		private var _autoScale:Boolean = false;
		private var _border:Boolean = false;
		private var _textField:TextField;
		
		//=========================================o
		//-- Constuct
		//=========================================o		
		public function CustomTextField(width:int, height:int, text:String, fontName:String="Verdana",
                                  fontSize:Number=12, color:uint=0x0, bold:Boolean=false) 
		{
			super(width, height, text, fontName, fontSize, color, bold)
			addEventListener(Event.ADDED_TO_STAGE, init)
		}
		
		//=========================================o
		//-- init
		//=========================================o		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		
			this.vAlign = _vAlign;
			this.hAlign = _hAlign;
			this.autoSize = _autoSize;
			this.autoScale = _autoScale;
			this.border = _border;

		}
		
		
		//=========================================o
		//-- Getters and Setters
		//=========================================o
		
		public override function set width(value:Number):void 
		{
			_width = value;
		}
		
		public override function set height(value:Number):void 
		{
			_height = value;
		}
		
		public override function set text(value:String):void 
		{
			_text = value;
		}
		
		public override function set fontName(value:String):void 
		{
			_fontName = value;
		}
		
		public override function set fontSize(value:Number):void 
		{
			_fontSize = value;
		}
		
		public override function set color(value:uint):void 
		{
			_color = value;
		}
		
		public override function set bold(value:Boolean):void 
		{
			_bold = value;
		}
		
		public override function set vAlign(value:String):void 
		{
			_vAlign = value;
		}
		
		public override function set hAlign(value:String):void 
		{
			_hAlign = value;
		}
		
		public override function set autoSize(value:String):void 
		{
			_autoSize = value;
		}
		
		public override function set autoScale(value:Boolean):void 
		{
			_autoScale = value;
		}
		
		public override function set border(value:Boolean):void 
		{
			_border = value;
		}
		
	}

}