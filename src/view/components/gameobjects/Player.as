package view.components.gameobjects 
{

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
	import staticData.Data;
	import staticData.SpriteSheets;
	
	/**
	 * ...
	 * @author John Stejskal
	 * johnstejskal@gmail.com
	 * "Why walk when you can ride"
	 */
	public class Player extends GameObject
	{
		private var _core:Core;
		private var _scaleWithDevice:Boolean;
		
		private var _collisionArea:Image;
		
		//images
		private var _imgPlayer:Image;
		private var _quFill:Quad;
		
		//mc's
		private var _smcSomeMoveClip:MovieClip;
		

		//-----------------------------o
		//-- Constructor
		//-----------------------------o
		public function Player(scaleWithDevice:Boolean = true) 
		{
			trace(this + "Constructed");
			_core = Core.getInstance();
			_scaleWithDevice = scaleWithDevice;
			
			if (stage) init(null);
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
		}
		
		private function init(e:Event):void 
		{
			trace(this + "inited");
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			this.scaleX = this.scaleY = Data.deviceScaleX; 
			
			/*_quFill = new Quad(DataVO.STAGE_WIDTH, _imgSkyL.height, 0xffffff);
			_quFill.alpha = .5;
			addChild(_quFill);
			_quFill.visible = false;*/
			
			_imgPlayer = new Image(AssetsManager.getAtlas(SpriteSheets.SPRITE_ATLAS_ACTION_ASSETS).getTexture("TA_player0000"));
			_imgPlayer.x = -_imgPlayer.width / 2;
			_imgPlayer.y = -_imgPlayer.height / 2;
			this.addChild(_imgPlayer);
			_imgPlayer.visible = true;
			
			
			/*_smcSomeMoveClip = new MovieClip(AssetsManager.getAtlas(SpriteSheets.SPRITE_ATLAS_ACTION_ASSETS).getTextures("TA_blinker"), 12);
			_smcSomeMoveClip.pause();
			_smcSomeMoveClip.loop = true;
			_smcSomeMoveClip.x = -_smcSomeMoveClip.width / 2;
			_smcSomeMoveClip.y = -_smcSomeMoveClip.height / 2;
			_core.animationJuggler.add(_smcSomeMoveClip)
			addChild(_smcSomeMoveClip);*/	
			
			this.addEventListener(Event.ENTER_FRAME, onUpdate)
			
			
			
			
		}
		
		private function onUpdate(e:Event):void 
		{
			
		}
		
		public override function trash():void
		{
			trace(this+" trash()")
			
		}
		
		
	}

}