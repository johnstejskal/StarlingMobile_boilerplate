package view.components.ui.buttons 
{
	import com.thirdsense.animation.TexturePack;
	import com.thirdsense.LaunchPad;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;
	import ManagerClasses.StateMachine;
	import singleton.Core;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	import staticData.dataObjects.AppData;
	import staticData.settings.PublicSettings;

	//=======================================o
	/**
	 * @author Terry Simms
	 * 
	 * "why code when you can spaghetti"
	 */
	//=======================================o
	public class ButtonType1 extends SuperButton
	{
		private const DYNAMIC_TA_REF:String = getQualifiedClassName(this);

		private var _core:Core;
		private var _simTop:Image;
		private var _simButton:Image;
		private var _simContent:Image;

		private var _mcBtn:MovieClip;
		private var _ref:String;
		private var _callback:Function;
		private var _label:String;
		private var _param:String;


		//=======================================o
		//-- Constructor
		//=======================================o
		public function ButtonType1(label:String, callback:Function, ref:String = "", param:String = null) 
		{
			trace(this + "Constructed");
			_ref = DYNAMIC_TA_REF + ref;
			_core = Core.getInstance();
			_label = label;
			_param = param;
			_callback = callback;


			
			
			super(ref, 
		}

		//=======================================o
		//-- init
		//=======================================o
		private function init(e:Event):void 
		{
		   trace(this + "inited");

		   var mc:* = LaunchPad.getAsset(PublicSettings.DYNAMIC_LIBRARY_UI, "TA_genericButton");
		   mc.scaleX = mc.scaleY = AppData.deviceScaleY;
		   mc.$txLabel.text = _label;
		   TexturePack.createFromMovieClip(mc, _ref, "TA_genericButton", null, 1, 2, null, 0)
		   _mcBtn = TexturePack.getTexturePack(_ref, "TA_genericButton").getMovieClip();

		   this.addChild(_mcBtn);
		   
		}
		
		
	}

}