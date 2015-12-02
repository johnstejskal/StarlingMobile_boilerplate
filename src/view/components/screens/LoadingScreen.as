package view.components.screens
{

	import com.greensock.easing.Linear;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.johnstejskal.StringFunctions;
	import com.thirdsense.animation.TexturePack;
	import com.thirdsense.LaunchPad;
	import flash.display.MovieClip;
	import mx.utils.StringUtil;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;


	import interfaces.iScreen;
	import ManagerClasses.StateMachine;
	import singleton.Core;



	/**
	 * @author John Stejskal
	 * "Why walk when you can ride"
	 */

	public class LoadingScreen extends Sprite implements iScreen
	{
		static public const DYNAMIC_TA_REF:String = "LoadingScreen";

	 /* 
	  * This is a native display component that appears during the loading of
	  * runtime asset data, ie between levels
	  */
		private var _core:Core;
		private var _bg:Quad;
		private var _showProgress:Boolean;
		private var _isGameState:Boolean = false;
		private var _label:String;
		private var _stf:TextField;
		private var _quProgress:Quad;
		private var _hexColour:Quad;
		private var _animatableObj:Image;
		private var _quTongue:Quad;
		private var _simLogo:Image;
		private var _showBG:Boolean;
		private var _simWheel:Image;
		
		//----------------------------------------o
		//------ Constructor 
		//----------------------------------------o
		public function LoadingScreen(label:String, showProgress:Boolean = true, showBG:Boolean = true):void 
		{
			_core = Core.getInstance();
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
			
		}
		
		//----------------------------------------o
		//------ Private functions 
		//----------------------------------------o		
		private function init(e:Event = null):void 
		{
			trace(this + " inited");
			
		
			_core.controlBus.appUIController.hideStageText();
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function onUpdate(e:Event):void 
		{

		}
		
		public function animateOut():void 
		{
			TweenLite.to(this, 1,{alpha:0, onComplete:trash})
		}		
		
		//----o Clean Up function
		private function onRemove(e:Event):void 
		{
			
		}

		//----------------------------------------o
		//------ Public functions 
		//----------------------------------------o		
		public function trash():void
		{
			trace(this + "trash()");
			TexturePack.deleteTexturePack(DYNAMIC_TA_REF)
			
			//_core.controlBus.appUIController.showStageText();
			
			this.removeEventListeners();
			this.removeFromParent();


		}
		

		
	}
	
}