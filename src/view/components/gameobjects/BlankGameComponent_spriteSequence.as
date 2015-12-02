package view.components.gameobjects 
{

	import com.thirdsense.animation.SpriteSequence;
	import com.thirdsense.animation.TexturePack;
	import com.thirdsense.LaunchPad;
	import data.AppData;
	import data.constants.LaunchPadLibrary;
	import flash.utils.getQualifiedClassName;
	import ManagerClasses.utility.AssetsManager;
	import singleton.Core;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.deg2rad;
	import view.components.gameobjects.superClass.GameObject;
	import data.Data;
	import data.constants.SpriteSheets;
	
	/**
	 * @author John Stejskal
	 * "Why walk when you can ride"
	 */
	
	public class BlankGameComponent_spriteSequence extends GameObject
	{
		//Launch Pad TA reference
		static public const DYNAMIC_REF:String = getQualifiedClassName(this);
		
		private var _core:Core;
		
		//sprite sequence
		private var _arrSpriteSequence:Array;
		

		//============================================o
		//-- Constructor
		//============================================o
		public function BlankGameComponent_spriteSequence() 
		{
			trace(this + "Constructed");
			_core = Core.getInstance();
			
			if (stage) init(null);
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
		}
		
		private function init(e:Event):void 
		{
			trace(this + "inited");
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			var mc:*;
			
			//create a launch pad sprite sequence
			mc = LaunchPad.getAsset(LaunchPadLibrary.GAME ,  "TA_linked1");
			var ss:SpriteSequence = SpriteSequence.create(mc, null, 1, 1, null, _pad);
			ss.sequence = "TA_linked1";
			_arrSpriteSequence.push(ss);
			
			mc = LaunchPad.getAsset(LaunchPadLibrary.GAME ,  "TA_linked2");
			var ss:SpriteSequence = SpriteSequence.create(mc, null, 1, 1, null, _pad);
			ss = SpriteSequence.create(mc, null, 1, 1, null, 0);
			ss.sequence = "TA_linked2";
			_arrSpriteSequence.push(ss);

			mc = LaunchPad.getAsset(LaunchPadLibrary.GAME ,  "TA_linked3");
			ss = SpriteSequence.create(mc, null, 1, 1, null, 0);
			ss.sequence = "TA_linked3";
			_arrSpriteSequence.push(ss);
			

			//define texture pack from sequence
			var tp:TexturePack = TexturePack.createFromHelper(_arrSpriteSequence, DYNAMIC_TA_REF, "CustomNameOfSequence");
			
			//create spites from texture pack
			_sim1 = tp.getImage(false, 0, "TA_linked1");
			_sim1.x = AppData.usedScale * 10;
			_sim1.scaleX = _sim1.scaleY = AppData.usedScale;
			_buttonHudHolder.addChild(_sim1);
			
			
			mc = null;
			this.addEventListener(Event.ENTER_FRAME, onUpdate);
			
		}
		
		
		//============================================o
		//-- Enter Frame / Update Loop
		//============================================o
		private function onUpdate(e:Event):void 
		{
			
		}
		
		
		//============================================o
		//-- Kill/Terminate/Destroy
		//============================================o
		public function trash():void
		{
			trace(this + " trash()");
			TexturePack.deleteTexturePack(DYNAMIC_TA_REF);
			this.removeFromParent();
			
		}
		
		
	}

}