package com.thirdsense.animation 
{
	import com.thirdsense.utils.getClassVariables;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * A class that converts a classic display list MovieClip in to a sprite sequence (a vector of BitmapData snapshots) to be used with blitting or Starling texture packs
	 * @author Ben Leffler
	 */
	
	public class SpriteSequence 
	{
		/**
		 * The pool group name for this object
		 */
		public var pool:String;
		
		/**
		 * The sequence name for this object.
		 */
		public var sequence:String = "";
		
		/**
		 * The vector of BitmapData snapshots of each frame of the source MovieClip
		 */
		public var sprites:Vector.<BitmapData>;
		
		/**
		 * The cell width of the BitmapData instances that populate the <i>sprites</i> object
		 */
		public var cell_width:Number;
		
		/**
		 * The cell height of the BitmapData instances that populate the <i>sprites</i> object
		 */
		public var cell_height:Number;
		
		/**
		 * The offset to calculate the resulting sprite's pivot point
		 */
		public var cell_offset:Point;
		
		/**
		 * The total number of cells in the sprite sequence
		 */
		public var total_cells:int;
		
		/**
		 * The maximum number of cells in the width of a single spritesheet
		 */
		public var max_width:int;
		
		/**
		 * The source MovieClip's originally reported width value
		 */
		public var source_width:Number;
		
		/**
		 * The source MovieClip's originally reported height value
		 */
		public var source_height:Number;
		
		public function SpriteSequence() 
		{
			
		}
		
		/**
		 * Creates a sprite sequence object from a MovieClip by analysing and taking a bitmapdata snapshot of each frame, placing each in to a vector for use in blitting and texture packing in Starling
		 * @param	clip	The movieclip to capture frame-by-frame
		 * @param	timeline	If a sub-clip needs it's timeline to advance with the clip timeline, pass it through in this parameter
		 * @param	start_frame	The number of the first frame
		 * @param	end_frame	The number of the final frame. Leaving this as 0 will capture the every frame in the clip
		 * @param	crop	A rectangle object that will act as a clipping box for the resulting texture atlas
		 * @param	filter_pad	Allows a 'bleed' area around the movieclip bounds to account for any filters that may exceed the bounds area (like a glow filter or drop shadow for example)
		 * @param	onNewFrame	A function to call as the playhead advances through the clip timeline. If you have clip children that require calculations to be made on each frame, you can use this method.
		 * @param	onNewFrameArgs	An array of arguments to pass through to onNewFrame function.
		 * @return	The resulting spritesequence object
		 */
		
		public static function create( clip:MovieClip, timeline:MovieClip = null, start_frame:int = 0, end_frame:int = 0, crop:Rectangle = null, filter_pad:int = 5, onNewFrame:Function=null, onNewFrameArgs:Array=null ):SpriteSequence
		{
			if ( !timeline ) {
				timeline = clip;
			}
			
			if ( !checkIfUsingDefaultMatrix(clip) )
			{
				var cont:MovieClip = new MovieClip();
				cont.addChild( clip );
				clip = cont;
			}
			
			if ( !end_frame ) {
				end_frame = timeline.totalFrames;
			}
			
			if ( !start_frame ) {
				start_frame = 1;
			}
			
			var rect:Rectangle = new Rectangle();
			var new_mc:MovieClip = new MovieClip();
			
			var totalframes:int = end_frame - start_frame + 1;
			var bmpdata_array:Array = new Array();
			var bmd:BitmapData;
			var matrix:Matrix;
			var rect2:Rectangle;
			
			for ( var i:uint = start_frame; i <= end_frame; i++ )
			{
				timeline.gotoAndStop( i );
				
				if ( onNewFrame != null )
				{
					if ( onNewFrameArgs )
					{
						onNewFrame.apply(null, onNewFrameArgs);
					}
					else
					{
						onNewFrame();
					}
				}
				
				if ( !crop )
				{
					rect2 = clip.getBounds( new_mc );
					rect = rect.union( rect2 );
					rect2.inflate( filter_pad, filter_pad );
				}
				else
				{
					rect2 = crop;
				}
				
				var dx:Number = rect2.x - Math.floor( rect2.x );
				var dy:Number = rect2.y - Math.floor( rect2.y );
				rect2.x = Math.floor( rect2.x );
				rect2.y = Math.floor( rect2.y );
				rect2.width = Math.ceil( rect2.width + dx );
				rect2.height = Math.ceil( rect2.height + dy );
				
				matrix = new Matrix();
				matrix.translate( -rect2.x, -rect2.y);
				
				bmd = new BitmapData( rect2.width, rect2.height, true, 0 );
				bmd.draw( clip, matrix, clip.transform.colorTransform, null, null, true );
				bmpdata_array.push( { bmd:bmd, rect:rect2 } );
				
				if ( timeline.currentFrame == end_frame )
				{
					break;
				}
			}
			
			if ( crop )
			{
				rect = crop;
			}
			
			rect.x = Math.floor(rect.x);
			rect.y = Math.floor(rect.y);
			rect.width = Math.ceil(rect.width);
			rect.height = Math.ceil(rect.height);
			
			var twidth:Number = rect.width;
			var theight:Number = rect.height;
			
			rect.inflate( filter_pad, filter_pad );
			
			var sprite_sequence:SpriteSequence = new SpriteSequence();
			sprite_sequence.source_width = twidth;
			sprite_sequence.source_height = theight;
			sprite_sequence.sprites = new Vector.<BitmapData>;
			
			twidth = rect.width;
			theight = rect.height;
			
			var counter:int = 0;
			var len:int = bmpdata_array.length;
			
			for ( i = 0; i < len; i++ )
			{
				rect2 = bmpdata_array[counter].rect;
				bmd = bmpdata_array[counter].bmd;
				
				var offset:Point = new Point( rect2.x - rect.x, rect2.y - rect.y );
				
				if ( bmd.rect.x == rect.x && bmd.rect.y == rect.y && bmd.rect.width == rect.width && bmd.rect.height == rect.height && !offset.x && !offset.y )
				{
					sprite_sequence.sprites.push( bmd );
				}
				else
				{
					var bmd2:BitmapData = new BitmapData( twidth, theight, true, 0 );
					sprite_sequence.sprites.push( bmd2 );
					bmd2.copyPixels( bmd, bmd.rect, offset, null, null, true );
					bmd.dispose();
				}
				
				counter++;
			}
			
			sprite_sequence.cell_width = rect.width;
			sprite_sequence.cell_height = rect.height;
			sprite_sequence.cell_offset = new Point( rect.x, rect.y );
			sprite_sequence.total_cells = counter;
			
			return sprite_sequence;
			
		}
		
		/**
		 * @private	Checks if the clip is using default values (unaltered transformation matrix)
		 * @param	clip	The clip to examine
		 * @return	Boolean value if the clip is using the default transformation matrix
		 */
		
		private static function checkIfUsingDefaultMatrix( clip:DisplayObject ):Boolean
		{
			var dMatrix:Matrix = new MovieClip().transform.matrix;
			var matrix:Matrix = clip.transform.matrix;
			
			var arr:Array = getClassVariables(matrix);
			while ( arr.length )
			{
				if ( dMatrix[arr[0]] != matrix[arr[0]] )
				{
					arr = new Array();
					return false;
				}
				else
				{
					arr.shift();
				}
			}
			
			return true;
		}
		
		/**
		 * Compiles the vector of bitmapdata snapshots in to a single spritesheet
		 * @return	The bitmapdata grid of the spritesequence
		 */
		
		public function getSpriteSheet( usePowerOfTwo:Boolean = false ):BitmapData
		{
			if ( this.sprites ) {
				if ( this.sprites.length > 1 ) {
					
					var max_width:int = Math.floor( this.getBestPowerOfTwo() / this.cell_width );
					
					var w:Number = this.cell_width * Math.min(this.total_cells, max_width);
					var h:Number = this.cell_height * Math.ceil(this.total_cells / max_width);
					
					if ( usePowerOfTwo )
					{
						var p2:int = this.getNextPowerOfTwo( Math.max(w, h) );
						var bmpdata:BitmapData = new BitmapData( p2, p2, true, 0 );
					}
					else
					{
						bmpdata = new BitmapData( w, h, true, 0 );
					}
					
					for ( var i:uint = 0; i < this.sprites.length; i++ ) {
						var row:int = Math.floor(i / max_width);
						var col:int = i - (row * max_width);
						bmpdata.copyPixels( this.sprites[i], this.sprites[i].rect, new Point(col * this.cell_width, row * this.cell_height), null, null, true );
					}
					return bmpdata;
					
				} else if ( this.sprites.length == 1 ) {
					
					if ( usePowerOfTwo )
					{
						p2 = this.getNextPowerOfTwo( Math.max(sprites[0].width, sprites[0].height) );
						bmpdata = new BitmapData( p2, p2, true, 0 );
					}
					else
					{
						bmpdata = new BitmapData( sprites[0].width, sprites[0].height, true, 0 );
					}
					
					bmpdata.copyPixels( sprites[0], sprites[0].rect, new Point() );
					return bmpdata;
					
				}
			}
			
			return null;
		}
		
		/**
		 * @private	Borrowed from Starling utils
		 */
		
		private function getNextPowerOfTwo(number:int):int
		{
			if (number > 0 && (number & (number - 1)) == 0) // see: http://goo.gl/D9kPj
				return number;
			else
			{
				var result:int = 1;
				while (result < number) result <<= 1;
				return result;
			}
		}
		
		/**
		 * @private	
		 */
		
		private function getBestPowerOfTwo():int
		{
			var heur:int = 1;
			
			while ( heur < Math.max(this.cell_height, this.cell_width) )
			{
				heur *= 2;
			}
			
			var cells:int = this.total_cells;
			var rows:int = 0;
			var cols:int = 0;
			
			var complete:Boolean = false;
			
			while ( !complete )
			{
				var tr:Rectangle = new Rectangle();
				var br:Rectangle = new Rectangle(0, 0, 0, this.cell_height);
				
				for ( var i:uint = 0; i < cells; i++ )
				{
					br.width += this.cell_width;
					if ( br.width > heur )
					{
						br.width -= this.cell_width;
						tr = tr.union(br);
						br = new Rectangle(0, tr.height, this.cell_width, this.cell_height);
					}
				}
				tr = tr.union(br);
				if ( tr.width > heur || tr.height > heur )
				{
					heur *= 2;
				}
				else
				{
					complete = true;
				}
			}
			
			return heur;
		}
		
		/**
		 * Formats an XML object to Sparrow specifications for use with the Starling Framework
		 * @return	An Sparrow XML object
		 */
		
		public function getSparrowXML():XML
		{
			var str:String = "<TextureAtlas imagePath=''>";
			var max_width:int = Math.floor( this.getBestPowerOfTwo() / this.cell_width );
			
			for ( var i:uint = 0; i < this.total_cells; i++ ) {
				
				var num:String = String(i);
				while ( num.length < 4 ) {
					num = "0" + num;
				}
				
				var row:int = Math.floor( i / (max_width) );
				var col:int = i - ( row * (max_width) );
				
				var name:String;
				if ( this.sequence == "" ) {
					name = this.pool;
				} else {
					name = this.pool + "__" + this.sequence;
				}
				
				str += "<SubTexture name='" + name + num + "' x='" + (col * this.cell_width) +"' y='" + (row * this.cell_height) +"' width='"+ this.cell_width +"' height='"+this.cell_height+"'/>"
			}
			
			str += "</TextureAtlas>";
			
			return new XML( str );
			
		}
		
		/**
		 * Disposes the bitmapdata sprites from memory.
		 */
		
		public function dispose():void
		{
			if ( this.sprites ) {
				
				while( this.sprites.length ) {
					this.sprites[0].dispose();
					this.sprites[0] = null;
					this.sprites.shift();
				}
			}
		}
		
		/**
		 * When passed as the onNewFrame parameter during a SpriteSequence create call, it propogates all nested movieclip timelines
		 * @param	mc	The MovieClip to focus on
		 * @param	isRoot	Used in the propogation process to determine what is the root timeline of the movieclip
		 * @param	progress	Used in the propogation process to determine what frame to adhere to the movieclip
		 * @param	scaleNestedTimelines	Determines if child clips of the root timeline should scale to the length of the root, or remain native (potential clipping to the length of the root timeline may occur)
		 */
		
		public static function propagateNestedClips( mc:MovieClip, isRoot:Boolean = false, progress:Number = -1, scaleNestedTimelines:Boolean = true, rootTimelineScale:int = 1 ):void 
		{
			rootTimelineScale = Math.max( 1, rootTimelineScale );
			
			if ( isRoot )
			{
				if ( mc.currentFrame == 1 )
				{
					return void;
				}
				else
				{
					progress = mc.currentFrame / mc.totalFrames;
					
					if ( rootTimelineScale > 1 )
					{
						mc.gotoAndStop( Math.round((progress * rootTimelineScale) * mc.totalFrames) );
						progress = mc.currentFrame / mc.totalFrames;
					}
				}
			}
			
			for ( var i:uint = 0; i < mc.numChildren; i++ )
			{
				var mc2:MovieClip = mc.getChildAt(i) as MovieClip;
				if ( mc2 )
				{
					if ( !scaleNestedTimelines )
					{
						// No-scaling of nested timelines
						if ( mc2.currentFrame < mc2.totalFrames ) mc2.nextFrame();
						else mc2.gotoAndStop(1);
					}
					else
					{
						// Scale nested timelines
						mc2.gotoAndStop( Math.ceil(progress * mc2.totalFrames) );
					}
					
					propagateNestedClips( mc2, false, progress, scaleNestedTimelines );
				}
			}
		}
		
		
	}

}