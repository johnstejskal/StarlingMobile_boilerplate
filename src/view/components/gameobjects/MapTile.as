package view.components.gameobjects 
{

	import com.johnstejskal.ArrayUtil;
	import singleton.Core;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.deg2rad;

	/**
	 * ...
	 * @author John Stejskal
	 * www.johnstejskal.com
	 * johnstejskal@gmail.com
	 */
	public class MapTile extends Sprite
	{
		//some generic types, update as required
		public static const TYPE_RED:int = 0;
		public static const TYPE_BLUE:int = 1;
		
		private var _collisionArea:Image;
		private var _type:int;
		
		//images

		private var _quFill:Quad;
		private var _core:Core;
		private var _imgTile:Image;

		
		//mc's
		
		//-----------------------------o
		//-- Constructor
		//-----------------------------o
		public function MapTile(type:int, w:Number, h:Number) 
		{
			_type = type;
			_core = Core.getInstance();
			
			if (stage) init(null);
			else addEventListener(Event.ADDED_TO_STAGE, init);

			var hex:uint;
			
			if (type == TYPE_BLUE)
			hex = 0x0000FF;
			else
			hex = 0xFF0000;
			
			_quFill = new Quad(w, h, hex);
			_quFill.alpha = 1;
			addChild(_quFill);


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
		
		public function get type():int 
		{
			return _type;
		}
		
		public function set type(value:int):void 
		{
			_type = value;
		}
		
		
	}

}