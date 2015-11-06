package view.components.gameobjects 
{

	import com.thirdsense.animation.SpriteSequence;
	import com.thirdsense.animation.TexturePack;
	import com.thirdsense.LaunchPad;
	import data.AppData;
	import data.constants.LaunchPadLibrary;
	import flash.utils.getQualifiedClassName;
	import ManagerClasses.AssetsManager;
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
	
	public class BlankComponent extends GameObject
	{
		//Launch Pad TA reference
		static public const DYNAMIC_TA_REF:String = this.getQualifiedClassName();
		
		private var _core:Core;
		
		private var _collisionArea:Image;
		
		//images
		private var _imgSomeImage:Image;
		private var _quFill:Quad;
		
		//mc's
		private var _smcSomeMoveClip:MovieClip;
		private var _arrSpriteSequenc:Array;
		

		//-----------------------------o
		//-- Constructor
		//-----------------------------o
		public function BlankComponent() 
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
			
			//------------------------------- create a launch pad sprite sequence
			mc = LaunchPad.getAsset(LaunchPadLibrary.GAME ,  "TA_linked1")
			var ss:SpriteSequence = SpriteSequence.create(mc, null, 1, 1, null, _pad);
			ss.sequence = "TA_linked1";
			_arrSpriteSequenc.push(ss);
			
			mc = LaunchPad.getAsset(LaunchPadLibrary.GAME ,  "TA_linked2")
			var ss:SpriteSequence = SpriteSequence.create(mc, null, 1, 1, null, _pad);
			ss = SpriteSequence.create(mc, null, 1, 1, null, 0);
			ss.sequence = "TA_linked2";
			_arrSpriteSequenc.push(ss);

			mc = LaunchPad.getAsset(LaunchPadLibrary.GAME ,  "TA_linked3")
			ss = SpriteSequence.create(mc, null, 1, 1, null, 0);
			ss.sequence = "TA_linked3";
			_arrSpriteSequenc.push(ss);
			//------------------------------------------------------------o

			
			var tp:TexturePack = TexturePack.createFromHelper(_arrSpriteSequenc, "CustomNameOfPool", "CustomNameOfSequence");
			_sim1 = tp.getImage(false, 0, "TA_btnJump");
			_sim1.x = AppData.usedScale * 10;
			_sim1.scaleX = _sim1.scaleY = AppData.usedScale;
			_buttonHudHolder.addChild(_simBtnJump);
			
			

			mc = null;
			this.addEventListener(Event.ENTER_FRAME, onUpdate)
			
		}
		
		private function onUpdate(e:Event):void 
		{
			
		}
		
		public function trash():void
		{
			trace(this+" trash()")
			
		}
		
		
	}

}