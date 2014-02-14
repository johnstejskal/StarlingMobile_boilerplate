package ManagerClasses 
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	import singleton.Core;
	import com.Stats;

	/**
	 * ...
	 * @author john
	 */
	public class DebugManager 
	{
		
		private var _core:Core;
		private var _oStatsConsol:Stats;
		private var _textfield:TextField;
		private var _msgbox:Sprite;
		
		
		
		//----------------------------------------o
		//------ Constructor
		//----------------------------------------o				
		public function DebugManager() 
		{
			_core = Core.getInstance();
			
			
			
		}

		//----------------------------------------o
		//------ Private functions 
		//----------------------------------------o	
		
		
		//----------------------------------------o
		//------ Public functions 
		//----------------------------------------o		
		public function setUp_stats():void
		{
			
			 _oStatsConsol = new Stats();
			 _core.main.stage.addChild(_oStatsConsol);
			 MessageBox();
			
			var timer:Timer = new Timer(1000);
			timer.addEventListener(TimerEvent.TIMER, timer_tick)
			timer.start();
			
		}

		private function MessageBox():void
		{

			_msgbox = new Sprite();

			 // drawing a white rectangle
			_msgbox.graphics.beginFill(0xFFFFFF); // white
			_msgbox.graphics.drawRect(0,0,300,20); // x, y, width, height
			_msgbox.graphics.endFill();
		 
			// drawing a black border
			_msgbox.graphics.lineStyle(2, 0x000000, 100);  // line thickness, line color (black), line alpha or opacity
			_msgbox.graphics.drawRect(0,0,300,20); // x, y, width, height
				
			_textfield = new TextField()
			_textfield.text = "Debug Consol"

			 _core.main.stage.addChild(_msgbox)   
		     _msgbox.addChild(_textfield)
		}
		
		private function timer_tick(e:TimerEvent):void 
		{
			_core.main.stage.setChildIndex(_oStatsConsol, _core.main.stage.numChildren -1)
			_core.main.stage.setChildIndex(_msgbox, _core.main.stage.numChildren -1)
		}
		
		
		//--------------------------------------o
		//------ Setters
		//--------------------------------------o
		
		public function setTrace(outPut:String):void
		{
			_textfield.text = outPut;
		}
		
	
		
	}

}