package view.components.ui.form 
{

	import com.greensock.easing.Back;
	import com.greensock.easing.Cubic;
	import com.greensock.text.SplitTextField;
	import com.greensock.TweenLite;
	import com.johnstejskal.Delegate;
	import com.thirdsense.animation.TexturePack;
	import com.thirdsense.LaunchPad;
	import data.constants.AppFonts;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.engine.FontWeight;
	import flash.text.ReturnKeyLabel;
	import flash.text.SoftKeyboardType;
	import flash.text.StageText;
	import flash.text.TextFormatAlign;
	import ManagerClasses.utility.AssetsManager;
	import ManagerClasses.StateMachine;
	import singleton.Core;
	import singleton.EventBus;
	import starling.core.Starling;
	import starling.display.Image;
	import flash.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.utils.deg2rad;
	import starling.utils.HAlign;


	
	/**
	 * ...
	 * @author John Stejskal
	 * johnstejskal@gmail.com
	 * "Why walk when you can ride"
	 */
	public class CustomStageText extends Sprite
	{
		private const DYNAMIC_TA_REF:String = "CustomCheckBox";
		
		private var _h:int;
		private var _w:int;
		private var _yOffset:int;
		private var _xOffset:int;
		public var _mapToClip:Sprite;
		
		public var st:StageText;
		public var viewPort:Rectangle;
		
		public var autoCorrect:Boolean = false;
		public var editable:Boolean = true;
		public var fontFamily:String = AppFonts.FONT_ARIAL;
		public var fontSize:int = 32;
		public var color:uint = 0x7E7E7E;//HexColours.FONT_GREY;
		public var textAlign:String = TextFormatAlign.LEFT;
		public var returnKeyLabel:String = ReturnKeyLabel.SEARCH;
		public var softKeyboardType:String = SoftKeyboardType.CONTACT;
		public var trackPos:Boolean = true;
		public var text:String = "";
		private var _globalContext:Sprite;
		


		//=======================================o
		//-- Constructor
		//=======================================o
		public function CustomStageText(xOffset:int, yOffset:int, w:int, h:int, mapToClip:Sprite, globalContext:Sprite = null) 
		{
			trace(this + "Constructed");
			st = new StageText();
			//st.stage = Starling.current.nativeStage;
			
			
			_globalContext = globalContext; 
			
			_mapToClip = mapToClip
			_xOffset = xOffset;
			_yOffset = yOffset;
			_w = w;
			_h = h;
		}

		//=======================================o
		//-- init
		//=======================================o
		public function init():void 
		{
			trace(this + "inited()");
			
			st.color = color;
			st.autoCorrect = autoCorrect;
			st.editable = editable;
			st.fontFamily = "Futura Std Medium";
			st.fontSize = fontSize;
			st.text = text;
			st.textAlign = textAlign;
			st.returnKeyLabel = returnKeyLabel;
			st.softKeyboardType = softKeyboardType;
			
			
			
			if (_globalContext == null)
			_globalContext = Sprite(_mapToClip.parent);
			
			viewPort = new Rectangle(_mapToClip.x + _xOffset, _mapToClip.y + _globalContext.y + _yOffset, _w, _h)
		    st.viewPort = viewPort;	
			

			if (trackPos)
			{
				_mapToClip.addEventListener(Event.ENTER_FRAME, onUpdate)
			}
		}
		
		private function onUpdate(e:Event):void 
		{
			trace("updating:" + _globalContext.y);
			_mapToClip.removeEventListener(Event.ENTER_FRAME, onUpdate)
			//if(_globalContext.y 
/*			var lPos:Point = new Point(_mapToClip.x + _xOffset, _mapToClip.y + _yOffset);
			var gPos:Point = _globalContext.localToGlobal(lPos)
			viewPort = new Rectangle(gPos.x, gPos.y, _w, _h)	
			st.viewPort = viewPort;*/
			
		   viewPort = new Rectangle(_globalContext.x + _mapToClip.x + _xOffset, _mapToClip.y + _globalContext.y + _yOffset, _w, _h)
		   st.viewPort = viewPort;	
			
		}


		//=========================================o
		//------ dispose/kill/terminate/
		//=========================================o
		public function trash():void
		{
			if (_mapToClip.hasEventListener(Event.ENTER_FRAME))
			_mapToClip.removeEventListener(Event.ENTER_FRAME, onUpdate)
			
			
			st.dispose();
			st = null;
		}
		
		
	}

}