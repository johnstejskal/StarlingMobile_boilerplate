package
{
	
	import com.Stats;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display3D.Context3D;
	import flash.geom.Rectangle;
	import staticData.Data;
	import staticData.settings.DeviceSettings;
	import staticData.settings.PublicSettings;
	import view.components.ui.nativeDisplay.DebugPanel;
	
	import org.gestouch.core.Gestouch;
	import org.gestouch.extensions.starling.StarlingDisplayListAdapter;
	import org.gestouch.extensions.starling.StarlingTouchHitTester;
	import org.gestouch.input.NativeInputAdapter;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.ResizeEvent;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	import view.components.screens.PlayScreen;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import singleton.Core;
	import ManagerClasses.*;
	
	import view.*
	
	import staticData.Constants;
	
	/**
	 * @author John Stejskal
	 * www.johnstejskal.com
	 * johnstejskal@gmail.com
	 */
	public class Main extends Sprite
	{
		private var _core:Core;
		private var context3D:Context3D;
		private var _starling:Starling;
		[SWF(frameRate="60")]
		
		public function Main():void
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			trace(this + "init()");
			_core = Core.getInstance();
			_core.main = this;
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.align = StageAlign.TOP_LEFT;
			//stage.scaleMode = StageScaleMode.SHOW_ALL;
			stage.scaleMode = StageScaleMode.NO_BORDER;
			
			Starling.multitouchEnabled = true;
			Starling.handleLostContext = true;
			_starling = new Starling(StarlingStage, stage);
			_starling.simulateMultitouch = true;
			_starling.antiAliasing = 1;
			_starling.enableErrorChecking = false;
			_starling.start();
			_starling.stage.stageWidth = stage.stageWidth;
			_starling.stage.stageHeight = stage.stageHeight;
			
			//-------------------------------------------------o
			//-- Setup Gestouch for Starling Based Gesture Support
			if (DeviceSettings.ENABLE_GESTURES)
			{
				Gestouch.inputAdapter ||= new NativeInputAdapter(stage);
				Gestouch.addDisplayListAdapter(starling.display.DisplayObject, new StarlingDisplayListAdapter());
				Gestouch.addTouchHitTester(new StarlingTouchHitTester(_starling), -1);
			}
			
			if (PublicSettings.SHOW_STARLING_STATS)
			{
				_starling.showStats = true;
				_starling.showStatsAt(HAlign.RIGHT, VAlign.TOP);
			}
			
			_starling.addEventListener(ResizeEvent.RESIZE, onResize);
			_core.starling = _starling;
			
			//set app configuration
			var config:Config = new Config();
		
		}
		
		private function onResize(e:ResizeEvent):void
		{
			trace(this + "onResize()");
			return;
			var viewPortRectangle:Rectangle = new Rectangle();
			viewPortRectangle.width = stage.stageWidth;
		    viewPortRectangle.height = stage.stageHeight;
		
		   _starling.stage.stageWidth = stage.stageWidth;
		   _starling.stage.stageHeight = stage.stageHeight;
		   //Starling.current.viewPort = viewPortRectangle;
		   _starling.viewPort = viewPortRectangle;
		   _starling.stage.stageWidth = stage.stageWidth;
		  _starling.stage.stageHeight = stage.stageHeight;
		  Data.deviceResX = stage.stageWidth;
		  Data.deviceResY = stage.stageHeight;
		  
		  //currentScreen.resize();
		}
	
	}

}