package view.components.ui.nativeDisplay
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.TextLineMetrics;
	import flash.utils.Timer;
	import singleton.Core;
	import staticData.Data;

	
	/**
	 * ...
	 * @author john stejskal
	 * "Why walk when you can ride"
	 */
	public class DebugPanel extends MovieClip
	{
		static public const TOP_LEFT:String = "topLeft";
		static public const TOP_RIGHT:String = "topRight";
		static public const TOP_CENTER:String = "topCenter";
		
		static public const BOTTOM_LEFT:String = "bottomLeft";
		static public const BOTTOM_RIGHT:String = "bottomRight";
		static public const BOTTOM_CENTER:String = "bottomCenter";
		
		private var _core:Core;
		private var _backing:Sprite;
		private var _textColour:uint;
		private var _screenPos:String;
		private var _showBacking:Boolean;
		private var _w:int;
		private var _h:int;
		private var _txFormat:TextFormat;
		private var _txLabel:TextField;
		
		
		//----------------------------------------o
		//------ Constructor 
		//----------------------------------------o
		public function DebugPanel(w:int = 150, h:int = 100, screenPos:String = TOP_LEFT, showBacking:Boolean = true, textColour:uint = 0x000000):void 
		{
			_core = Core.getInstance();
			
			_textColour = textColour;
			_screenPos = screenPos;
			_showBacking = showBacking;
			_w = w;
			_h = h;
			

			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
		}
		
		
		//----------------------------------------o
		//------ Private functions 
		//----------------------------------------o		
		private function init(e:Event = null):void 
		{
			
			trace(this+" inited");
			removeEventListener(Event.ADDED_TO_STAGE, init);

			_txFormat = new TextFormat();
			_txFormat.size = 15;
			_txFormat.align = TextFormatAlign.CENTER;

			_txLabel = new TextField();
			_txLabel.defaultTextFormat = _txFormat;
			_txLabel.text = "";
			addChild(_txLabel);

			_txLabel.border = _showBacking;
			_txLabel.wordWrap = true;
			_txLabel.opaqueBackground = 0xFFFFFF;
			_txLabel.width = _w;
			_txLabel.height = _h;
			_txLabel.x = 0;
			_txLabel.y = 0;
			
			
			switch(_screenPos)
			{
				case TOP_LEFT:
				break;
				
				case TOP_RIGHT:
				_txLabel.x = Data.deviceResX - _w;
				_txLabel.y = 0;
				break;
				
				case BOTTOM_LEFT:
				_txLabel.x = 0;
				_txLabel.y = Data.deviceResY - _h;
				break;
				
				case BOTTOM_RIGHT:
				_txLabel.x = Data.deviceResX - _w;
				_txLabel.y = Data.deviceResY - _h;
				break;				
				
			}
			
		}
		
		
		//----------------------------------------o
		//------ Public functions 
		//----------------------------------------o		
		
		public function setTrace(msg:String):void
		{
			_txLabel.text = msg;
		}
		
	}
	
}