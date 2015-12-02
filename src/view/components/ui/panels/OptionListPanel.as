package view.components.ui.panels
{
	
	import com.greensock.easing.Back;
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;
	import com.johnstejskal.Delegate;
	import com.thirdsense.animation.TexturePack;
	import com.thirdsense.LaunchPad;
	import data.AppData;
	import data.constants.LaunchPadLibrary;
	import view.components.ui.buttons.ButtonType1;
	import view.components.ui.form.FormField;
	import view.components.ui.form.FormFieldDropDown;

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
	import starling.text.TextFieldAutoSize;
	import starling.utils.deg2rad;
	import starling.utils.HAlign;
	import starling.utils.VAlign;


	
	/**
	 * ...
	 * @author John Stejskal
	 * johnstejskal@gmail.com
	 * "Why walk when you can ride"
	 */
	public class OptionListPanel extends Sprite
	{

		private const DYNAMIC_TA_REF:String = "OptionListPanel";
		
		private var _core:Core;
		private var _titleText:String = "";

		private var _list:Array;
		private var _targetField:FormFieldDropDown;
		
		//=======================================o
		//-- Constructor
		//=======================================o
		public function OptionListPanel(list:Array = null, targetField:FormFieldDropDown = null)
		{
			trace(this + "Constructed");
			_core = Core.getInstance();
			_targetField = targetField;
			_list = list;
			if (stage)
				init(null);
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		
		}
		
		//=======================================o
		//-- init
		//=======================================o
		private function init(e:Event):void
		{
			trace(this + "inited");
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			//content area
			var mc:MovieClip = LaunchPad.getAsset(LaunchPadLibrary.UI, "MC_optionsListPanel") as MovieClip;
			mc.scaleX = mc.scaleY = AppData.deviceScale;
			//mc.$txTitle.text = "";
			TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "MC_optionsListPanel", null, 1, 1, null, 0)
			var simPanel:Image = TexturePack.getTexturePack(DYNAMIC_TA_REF, "MC_optionsListPanel").getImage();
			this.addChild(simPanel);
			
			for (var i:int = 0; i < _list.length; i++) 
			{
				var orangeButton:ButtonType1 = new ButtonType1(_list[i], onSelectItem, _list[i], _list[i]);
				orangeButton.y = Math.floor((AppData.deviceScale * -320) + i * AppData.deviceScale * 85); 
				this.addChild(orangeButton);
			}
			
	
			mc = null;

		
		}
		
		private function onSelectItem(value:String):void 
		{
			
			_targetField.changeState(FormField.STATE_ON, value);
			_core.controlBus.appUIController.removeNotification();
		}
		
		
		//=======================================o
		//-- trash/dispose/kill
		//=======================================o
		public function trash():void
		{
			trace(this + " trash()")
			TexturePack.deleteTexturePack(DYNAMIC_TA_REF)
			this.removeFromParent();
			this.removeEventListeners();
		
		}
		
	
	}

}