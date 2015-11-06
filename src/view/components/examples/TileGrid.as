package view.components.examples 
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
	import view.components.gameobjects.MapTile;
	import view.components.gameobjects.superClass.GameObject;
	import data.Data;
	import data.constants.SpriteSheets;
	
	/**
	 * ...
	 * @author John Stejskal
	 * johnstejskal@gmail.com
	 * "Why walk when you can ride"
	 */
	public class TileGrid extends Sprite
	{
		private var _core:Core;
		
		private var _collisionArea:Image;
		
		//images
		private var _imgSomeImage:Image;
		private var _quFill:Quad;
		
		//mc's
		private var _smcSomeMoveClip:MovieClip;
		private var _arrTiles:Array;
	
		
	/* generic map array,
	 * you may want to store this in some better place later, ie LevelMaps.as
	 * Binary numbers can be exchanged with String constants for a wider range of tile values
	 */

	public static const LEVEL_MAP:Array = [
											[0,0,0,0,0,0,0,0,0,0],
											[0,1,0,0,0,0,0,0,1,0],
											[0,0,0,0,0,0,0,0,0,0],
											[0,0,0,0,0,0,0,0,0,0],
											[0,0,0,0,0,0,0,0,0,0],
											[0,0,0,0,0,0,0,0,0,0],
											[0,0,0,0,0,0,0,0,0,0],
											[0,0,0,0,0,0,0,0,0,0],
											[0,0,0,0,0,0,0,0,0,0],
											[0,0,0,0,0,0,0,0,0,0]
											]	
		//-----------------------------o
		//-- Constructor
		//-----------------------------o
		public function TileGrid() 
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
			
			
			this.addEventListener(Event.ENTER_FRAME, onUpdate)
			
		}
		/* Grid generation 
		 *  creats a grid based on a map array, cols and rows are set based on the dimensions of the map array
		 * 
		 */
		 
		public function generateGrid(startX:Number, startY:Number, tileWidth:Number, tileHeight:Number, map:Array):void 
		{
			trace(this + "generateGrid()");
			_arrTiles = new Array();
			

			var i:int;
			var j:int;
			var r:Array;
			var t:MapTile;
			
			//automatically detects cols and rows based on Array dimensions
			for ( i = 0; i < map.length; i++) 
			{
				 r = map[i];
				for ( j = 0; j < r.length; j++) 
				{
					t = new MapTile(r[j], tileWidth, tileHeight);
					t.x = startX + (j*tileWidth);
					t.y = startY + (i * tileHeight);
					t.width += 1; t.height += 1;
					this.addChild(t);
					_arrTiles.push(t);	
				}
			}

			
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