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
	import vo.Constants;
	import vo.Data;
	/**
	 * ...
	 * @author John Stejskal
	 * www.johnstejskal.com
	 * johnstejskal@gmail.com
	 */
	public class MapTile extends Sprite
	{
		static public const TYPE_ROAD:String = "r";
		static public const TYPE_FRONT_LEFT:String = "fl";
		static public const TYPE_FRONT_RIGHT:String = "fr";
		static public const TYPE_FRONT_DOOR:String = "fd";
		static public const TYPE_FRONT_MIDDLE:String = "fm";
		
		static public const TYPE_BACK_LEFT:String = "bl";
		static public const TYPE_BACK_RIGHT:String = "br";
		static public const TYPE_BACK_DOOR:String = "bd";
		static public const TYPE_BACK_MIDDLE:String = "bm";		


		
		private var _collisionArea:Image;
		private var _type:String;
		
		//images

		private var _quFill:Quad;
		private var _core:Core;
		private var _imgTile:Image;
		private var _arrColours:Array;
		
		//mc's
		
		//-----------------------------o
		//-- Constructor
		//-----------------------------o
		public function MapTile(type:String, w:Number, h:Number) 
		{
			
			_type = type;
			_core = Core.getInstance();
			
			if (stage) init(null);
			else addEventListener(Event.ADDED_TO_STAGE, init);

			
			/*_quFill = new Quad(79, 77, 0x000000);
			_quFill.alpha = 1;
			addChild(_quFill);*/
			

			trace("_type :" + "TA_"+_type+"0000");
			_imgTile = new Image(AssetsManager.getAtlas(AssetsManager.SPRITE_ATLAS_ACTION_ASSETS).getTexture("TA_"+_type+"0000"));

			_imgTile.width = w;
			_imgTile.height = h;
			
			this.addChild(_imgTile);
			_imgTile.visible = true;

		}
		
		private function init(e:Event):void 
		{
			//trace(this + "inited");
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			
			this.addEventListener(Event.ENTER_FRAME, onUpdate)
			
		}
		
		private function onUpdate(e:Event):void 
		{
			
		}
		
		public function trash():void
		{
			
		}
		
		public function get type():String 
		{
			return _type;
		}
		
		public function set type(value:String):void 
		{
			_type = value;
		}
		
		
	}

}