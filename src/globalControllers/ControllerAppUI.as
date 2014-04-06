package globalControllers 
{
	import com.greensock.TweenLite;
	import starling.display.Quad;
	import staticData.Data;
	import view.components.ui.popup.Popup;
	import view.StarlingStage;
	/**
	 * ...
	 * @author 
	 */
	public class ControllerAppUI 
	{
		var _popup:Popup;
		var _stage:StarlingStage;
		
		public function ControllerAppUI(stage:StarlingStage) 
		{
			_stage = stage;
		}
		
		public function showPopup():void
		{
			_popup = new Popup();
			
		}
		
		//==============================================o
		//------ Add Fill to darken screen
		//==============================================o		
		public function addFillOverlay(fadeSpeed:Number = .3, opacity:Number = .5, callback:Function = null):void
		{
			trace(this + "addFillOverlay()");
			if (!_quDimScreen)
			{
			_quDimScreen = new Quad(Data.deviceResX, Data.deviceResY, 0x000000);
			_quDimScreen.alpha = 0;
			_stage.addChildAt(_quDimScreen, _stage.numChildren - 1);
			TweenLite.to(_quDimScreen, fadeSpeed, { alpha:opacity, onComplete:function():void {
				if (callback != null)
				callback();
				}})
			}

			
		}	
		
		
	}

}