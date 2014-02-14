package com.gokhantank.util 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	/**
	$(CBI)* ...
	$(CBI)* @author Gokhan Tank
	$(CBI)*/
	public class Debug
	{
		static private var instance:Debug;
		
		public function Debug() 
		{
			
		}
		public function traceWithTexttField(mc:MovieClip,string:String) {
			var tf:TextField = new TextField();
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.border = true;
			mc.addChild(tf);

			tf.appendText("tracing : "+string);
		}
		public static function getInstance():Debug {
			if (instance == null) instance =  new Debug();
			return instance as Debug;
		}
	}

}