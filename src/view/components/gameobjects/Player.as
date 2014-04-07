package view.components.gameobjects 
{

	import com.johnstejskal.Delegate;
	import ManagerClasses.AssetsManager;
	import singleton.Core;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.deg2rad;
	import staticData.settings.PublicSettings;
	import view.components.gameobjects.GameObject;
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
		
		//Player State types
		static public const STATE_DEFAULT:String = "stateDefault";
		static public const STATE_COLLISION:String = "stateCollision";

		
		
		
		private var _core:Core;
		private var _scaleWithDevice:Boolean;
		
		private var _collisionArea:Image;
		
		//images
		private var _imgPlayer:Image;
		private var _quFill:Quad;
		

		private var _quCollisionArea:Quad;
		
		//player state objects
		private var _smcDefault:MovieClip;
		private var _smcCollision:MovieClip;
		
		private var _currState:String;
		private var _currStateObject:MovieClip;
		private var _isGod:Boolean;

		

		//===========================================o
		//-- Constructor
		//===========================================o
		public function Player(scaleWithDevice:Boolean = true) 
		{
			trace(this + "Constructed");
			_core = Core.getInstance();
			_scaleWithDevice = scaleWithDevice;
			
			if (stage) init(null);
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
		}
		
		//===========================================o
		//-- init
		//===========================================o
		private function init(e:Event):void 
		{
			trace(this + "inited");
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			this.scaleX = this.scaleY = Data.deviceScaleX; 			
			
			//create collision box
			_quCollisionArea = new Quad(30, 120, 0x00FF00);
			_quCollisionArea.alpha = 1;
			_quCollisionArea.pivotX = _quCollisionArea.width/2;
			_quCollisionArea.pivotY = 0;
			addChild(_quCollisionArea);
			
			if(PublicSettings.SHOW_COLLISION_BOX)
			_quCollisionArea.visible = true;
			else
			_quCollisionArea.visible = false;

			_isGod = PublicSettings.ENABLE_GOD_MODE;
			
			//create default player state
			_smcDefault = new MovieClip(AssetsManager.getAtlas(SpriteSheets.SPRITE_ATLAS_ACTION_ASSETS).getTextures("TA_playerDefault"), 20);
			_smcDefault.pause();
			_smcDefault.loop = true;
			_smcDefault.pivotX = _smcDefault.width/2;
			_smcDefault.pivotY = _smcDefault.height;
			
			//create collision player state
			_smcCollision = new MovieClip(AssetsManager.getAtlas(SpriteSheets.SPRITE_ATLAS_ACTION_ASSETS).getTextures("TA_playerCollision"), 20);
			_smcCollision.pause();
			_smcCollision.loop = true;
			_smcCollision.pivotX = _smcCollision.width/2;
			_smcCollision.pivotY = _smcCollision.height;
			
			
			changeState(STATE_DEFAULT);
			
		}
		
		
		//===========================================o
		//-- Change player State
		//===========================================o		
		public function changeState(newState:String):void 
		{
			if (_currState == newState)
			return;
			
			if (_currState != null)
			{
			this.removeChild(_currStateObject);
			_core.animationJuggler.remove(_currStateObject);	
			}
			
			switch(newState)
			{
				//-----------------------------o
				case STATE_DEFAULT:
				_currStateObject = _smcDefault
				break;
				//-----------------------------o
				case STATE_COLLISION:
				_currStateObject = _smcCollision
				break;
				//-----------------------------o
			}
			
			this.addChild(_currStateObject);
			_core.animationJuggler.add(_currStateObject);


		}
		
		
		//===========================================o
		//-- kill/dispose/destroy
		//===========================================o
		public override function trash():void
		{
			this.removeEventListeners();
			this.removeFromParent();
			
		}
		
		
	}

}