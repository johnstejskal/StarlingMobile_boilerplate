package view.components.ui 
{

	import com.greensock.TweenLite;
	import com.johnstejskal.Maths;
	import com.thirdsense.animation.TexturePack;
	import com.thirdsense.LaunchPad;
	import data.AppData;
	import data.constants.HexColours;
	import data.constants.LaunchPadLibrary;
	import data.settings.PublicSettings;
	import data.settings.UISettings;
	import flash.utils.getQualifiedClassName;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.deg2rad;
	import view.components.EntityObject;

	
	/**
	 * ...
	 * @author John Stejskal
	 * johnstejskal@gmail.com
	 * "Why walk when you can ride"
	 */
	public class Background extends EntityObject
	{
		private const DYNAMIC_TA_REF:String = getQualifiedClassName(this);
		private var _imgBG:Image;
		private var _dynamicRef:String;
		private var _quBGFill:Quad;
		
		
		//====================================o
		//-- Constructor
		//====================================o
		public function Background() 
		{
			trace(this + "Constructed");
			
			if (stage) init(null);
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
		}
		
		private function init(e:Event):void 
		{
			
		   trace(this + "inited");
		   removeEventListener(Event.ADDED_TO_STAGE, init);
		  
		   if (UISettings.BACKGROUND_TYPE == "fill")
		   {
				_quBGFill = new Quad(AppData.deviceResX, AppData.deviceResY, UISettings.BACKGROUND_FILL_COLOUR);
				_quBGFill.alpha = 0;
				this.addChild(_quBGFill);			   
		   }
		   else
		   {
			   var mc:* = new TA_uiBG();
			   mc.scaleX = mc.scaleY = AppData.deviceScale;
			  
			   TexturePack.createFromMovieClip(mc, DYNAMIC_TA_REF, "TA_uiBG", null, 1, 1, null, 0)
			   _imgBG = TexturePack.getTexturePack(DYNAMIC_TA_REF, "TA_uiBG").getImage();
			   this.addChild(_imgBG);
		   }

		}

		public  function trash():void
		{
			trace(this + " trash()")
			this.removeEventListeners();
			this.removeFromParent();
			TexturePack.deleteTexturePack(DYNAMIC_TA_REF);
			
		}

		
		
	}

}