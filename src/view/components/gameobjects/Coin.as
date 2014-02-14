package view.components.gameobjects 
{

	import com.johnstejskal.ArrayUtil;
	import ManagerClasses.AssetsManager;
	import singleton.Core;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.deg2rad;
	import vo.Data;
	/**
	 * ...
	 * @author John Stejskal
	 * www.johnstejskal.com
	 * johnstejskal@gmail.com
	 */
	public class Coin extends Sprite
	{

		
		private var _collisionArea:Image;
		
		//images
		private var _imgCoin:Image;
		private var _quFill:Quad;
		private var _core:Core;
		
		//mc's
		

		
		
		//-----------------------------o
		//-- Constructor
		//-----------------------------o
		public function Coin() 
		{
			trace(this + "Constructed");
			_core = Core.getInstance();
			
			if (stage) init(null);
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
			/*_quFill = new Quad(DataVO.STAGE_WIDTH, _imgSkyL.height, 0xffffff);
			_quFill.alpha = .5;
			addChild(_quFill);
			_quFill.visible = false;*/
			
			_imgCoin = new Image(AssetsManager.getAtlas(AssetsManager.SPRITE_ATLAS_ACTION_ASSETS).getTexture("TA_coin0000"));
			_imgCoin.x = -_imgCoin.width / 2;
			_imgCoin.y = -_imgCoin.height / 2;
			//_imgCoin.scaleX = _imgCoin.scaleY = .5;
			this.addChild(_imgCoin);
			_imgCoin.visible = true;

		}
		
		private function init(e:Event):void 
		{
			trace(this + "inited");
			removeEventListener(Event.ADDED_TO_STAGE, init);
			//this.addEventListener(Event.ENTER_FRAME, onUpdate)
			
		}
		
		private function onUpdate(e:Event):void 
		{
			
		}
		
		public function trash():void
		{
			
		}
		
		
	}

}