package ManagerClasses 
{
	import flash.display.Stage;
	import flash.display.StageAlign;
	//import flash.display.StageOrientation;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	/*
	 * import flash.events.StageOrientationEvent
	*/
	 import singleton.Core;
	/**
	 * ...
	 * @author john
	 */
	public class StageResizeManager 
	{
		
		private var _core:Core;
		private var _stage:Stage;
		private var _rescaleRatio:Number;
		private var _gameStageWidth:Number;
		private var _gameStageHeight:Number;

		//all graphic objects were created for 800 x 480
		//so I save this details as my base resolution
		public static const GAME_ORG_WIDTH:uint = 800;
		public static const GAME_ORG_HEIGHT:uint = 480;

		
		//----------------------------------------o
		//------ Constructor
		//----------------------------------------o				
		public function StageResizeManager() 
		{
			_core = Core.getInstance();
			_stage = _core.main.stage;
		}
		
		private function init(e:Event):void
		{
		   _stage.scaleMode = StageScaleMode.NO_SCALE;
		   _stage.align = StageAlign.TOP_LEFT;
		   _stage.addEventListener(Event.RESIZE, setUpScreen);
		}

		protected function setUpScreen(e:Event):void
		{
		   _stage.removeEventListener(Event.RESIZE, setUpScreen);
		 
		   if (_stage.fullScreenWidth > _stage.fullScreenHeight)
		   {
			  _gameStageWidth = _stage.fullScreenWidth;
			  _gameStageHeight = _stage.fullScreenHeight;
		   }
		   else
		   {
			  _gameStageWidth = _stage.fullScreenHeight;
			  _gameStageHeight = _stage.fullScreenWidth;
		   }
		 
		   _rescaleRatio = _gameStageWidth / GAME_ORG_WIDTH;
		 
		   //I use ratio to rescale every object, ie:
		   //gameHolder.scaleX = gameHolder.scaleY = _rescaleRatio;
		}
		public function setup_stageOrientationHandler():void
		{
			/*AirOnly
			//_stage.addEventListener(StageOrientationEvent.ORIENTATION_CHANGING, orientationChangeListener);
			*/
		
		}
		
		
		//----------------------------------------o
		//------ Private Methods 
		//----------------------------------------o		
		

		
		//----------------------------------------o
		//------ Public Methods 
		//----------------------------------------o	
		public function setupResizeListener():void 
		{
			trace(this + "setupResizeListener");
			
			_stage.align = StageAlign.TOP_LEFT;
			_stage.scaleMode = StageScaleMode.NO_SCALE;
			_stage.addEventListener(Event.RESIZE, stageResized)
		
			//managerComponent.onStageResize();
			
		}
		

		
		//----------------------------------------o
		//------ Event Handlers
		//----------------------------------------o		
		
		/* AIR ONLY
		private function orientationChangeListener(e:StageOrientationEvent):void
		{
            if(e.afterOrientation == StageOrientation.UPSIDE_DOWN || e.afterOrientation == StageOrientation.DEFAULT)
               e.preventDefault();
        }	
		*/
		
		private function stageResized(e:Event):void 
		{
			

		}
		
	}

}