package com.thirdsense.animation
{
	import com.thirdsense.animation.atf.Encoder;
	import com.thirdsense.animation.atf.EncodingOptions;
	import com.thirdsense.animation.SpriteSequence;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.events.Event;
	import starling.textures.RenderTexture;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.getNextPowerOfTwo;
	
	/**
	 * The TexturePack class enables you to convert during runtime a MovieClip to a texture packed object primarily for use with the Starling Framework. This class also
	 * acts as a psuedo-asset management sytem for textures, texture atlases, source bitmapdata and render textures.
	 * @author Ben Leffler
	 */
	
	public class TexturePack 
	{
		private var _spritesheet:BitmapData;
		private var _sparrow_xml:XML;
		
		/**
		 * The pool name of the TexturePack object
		 */
		public var pool:String = "";
		
		/**
		 * The sequence name of the TexturePack object
		 */
		public var sequence:String = "";
		
		/**
		 * The texture object representation of the source sprite sheet
		 */
		public var texture:Texture;
		
		/**
		 * The dynamic render texture object if the TexturePack object has been slated to use it
		 */
		public var render_texture:RenderTexture;
		
		/**
		 * The texture atlas to be used by the Starling framework
		 */
		public var atlas:TextureAtlas;
		
		/**
		 * The x/y co-ordinate offset of the source sprite. Use the to correctly calculate the pivot point. If a helper was used to
		 * create the Texture Pack, it is best to use the getOffset function to retrieve this data
		 */
		public var offset:Point;
		
		/**
		 * The original MovieClip's source width
		 */
		public var source_width:Number;
		
		/**
		 * The original MovieClip's source height
		 */
		public var source_height:Number;
		
		/**
		 * Dynamic metadata that can be configured to carry any kind of data to be attached with this specific TexturePack object
		 */
		public var metadata:Object;
		
		/**
		 * If a helper was used to create the Texture Pack, it will be stored here
		 */
		private var helper:SpriteSheetHelper;
		
		private static var texture_packs:Vector.<TexturePack>;
		
		/**
		 * Indicates if mipmaps are to be generated when converting from a MovieClip/SpriteSequence to a TexturePack object
		 */
		public static var generate_mipmaps:Boolean = false;
		
		/**
		 * Utilises runtime ATF generation (especially handy for minimal iPad 1 memory footprint)
		 */
		public static var generate_atf:Boolean = false;
		
		/**
		 * Overrides any call to dispose a spritesheet upon import if Starling context handling is enabled
		 */
		public static var context_controls_disposal:Boolean = false;
		
		/**
		 * Constructor class for a Texture Pack
		 * @param	sprite_sequence	The SpriteSequence object that the Texture Pack is to be generated from.
		 * @param	disposeOnImport	Dispose the spritesheet bitmapData from the Texture Pack upon import.
		 */
		
		public function TexturePack( sprite_sequence:SpriteSequence=null, disposeOnImport:Boolean = true )
		{
			if ( sprite_sequence ) {
				this.spritesheet = sprite_sequence.getSpriteSheet( generate_atf );
				this.sparrow_xml = sprite_sequence.getSparrowXML();
				this.pool = sprite_sequence.pool;
				this.sequence = sprite_sequence.sequence;
				this.offset = new Point( sprite_sequence.cell_offset.x, sprite_sequence.cell_offset.y );
				this.source_width = sprite_sequence.source_width;
				this.source_height = sprite_sequence.source_height;
			}
			else
			{
				this.offset = new Point(0, 0);
			}
			
			if ( !context_controls_disposal || !Starling.handleLostContext )
			{
				if ( disposeOnImport && sprite_sequence ) {
					this.kill(true);
				}
			}
			
		}
		
		/**
		 * Creates a new Texture from a bitmapdata object
		 * @param	bmpdata	The bitmapdata object to convert from
		 * @param	asRenderTexture	Creates a texture as a render texture for runtime alteration
		 * @param	retainBitmapData	Retains the bitmapdata object in the TexturePack object for collision detection etc.
		 * @param	disposeOnComplete	Disposes of the bitmapdata object at the close of the function
		 */
		
		public function fromBitmapData(bmpdata:BitmapData, asRenderTexture:Boolean = false, retainBitmapData:Boolean = false, disposeOnComplete:Boolean = true ):void
		{
			if ( !Starling.context )
			{
				trace( "LaunchPad", TexturePack, "Unable to convert to a Texture. You must establish a Stage3D context first by starting a Starling session." );
				throw ( new Error("Unable to convert to a Texture. You must establish a Stage3D context first by starting a Starling session.") );
				return void;
			}
			
			if ( !generate_atf )
			{
				this.texture = Texture.fromBitmapData(bmpdata, generate_mipmaps, asRenderTexture);
				if ( context_controls_disposal && Starling.handleLostContext )
				{
					this.texture.root.onRestore = function() {
						texture.root.uploadBitmapData( this._spritesheet );
						trace( "Texture Restored:", pool, "-", sequence );
					}
				}
			}
			else
			{
				var options:EncodingOptions = new EncodingOptions();
				options.mipmap = generate_mipmaps;
				var max:Number = Math.max( bmpdata.width, bmpdata.height );
				var p2:int = getNextPowerOfTwo(max);
				var bmd:BitmapData = new BitmapData(p2, p2, bmpdata.transparent, 0 );
				bmd.copyPixels( bmpdata, bmpdata.rect, new Point(), null, null, false );
				var data:ByteArray = Encoder.encode( bmd, options, null );
				this.texture = Texture.fromAtfData( data, 1, generate_mipmaps );
			}
			
			if ( asRenderTexture ) {
				this.render_texture = new RenderTexture(bmpdata.width, bmpdata.height);
				this.render_texture.draw( new Image(this.texture) );
				this.texture.dispose();
				this.texture = null;
			}
			
			if ( retainBitmapData || (context_controls_disposal && Starling.handleLostContext) ) {
				if ( bmd )
				{
					this._spritesheet = bmd;
				}
				else
				{
					this._spritesheet = bmpdata;
				}
			}
			else if ( disposeOnComplete )
			{
				bmpdata.dispose();
				if ( bmd ) bmd.dispose();
			}
			
		}
		
		/**
		 * Creates a texture pack from a SpriteSheetHelper object
		 * @param	helper	The helper to use to create a TexturePack object
		 * @param	disposeOnImport	Pass as true if you want to dispose of the helper and sprite sequence bitmapdata once the texture is on the GPU
		 */
		
		public function fromHelper( helper:SpriteSheetHelper, disposeOnImport:Boolean = true ):void
		{
			this.helper = helper;
			
			if ( !Starling.context )
			{
				trace( "LaunchPad", TexturePack, "Unable to convert to a Texture. You must establish a Stage3D context first by starting a Starling session." );
				throw ( new Error("Unable to convert to a Texture. You must establish a Stage3D context first by starting a Starling session.") );
				return void;
			}
			
			this.spritesheet = helper.spritesheet;
			this.sparrow_xml = helper.sparrow_xml;
			
			if ( !context_controls_disposal || !Starling.handleLostContext )
			{
				if ( disposeOnImport )
				{
					this._spritesheet.dispose();
					this._spritesheet = null;
					helper.dispose();
				}
				
			}
			else if ( disposeOnImport )
			{
				helper.dispose( true, false );
			}
		}
		
		public function getHelper():SpriteSheetHelper
		{
			return this.helper;
		}
		
		/**
		 * The bitmapdata spritesheet used in the texture. The can be kept in resident memory for use in collision detection and render texture writing.
		 */
		
		public function get spritesheet():BitmapData	{	return this._spritesheet	};
		public function set spritesheet( bmpdata:BitmapData ):void
		{
			if ( !Starling.context )
			{
				trace( "LaunchPad", TexturePack, "Unable to convert to a Texture. You must establish a Stage3D context first by starting a Starling session." );
				throw ( new Error("Unable to convert to a Texture. You must establish a Stage3D context first by starting a Starling session.") );
				return void;
			}
			
			this._spritesheet = bmpdata;
			
			if ( this.texture ) {
				this.texture.dispose();
			}
			
			if ( bmpdata != null )
			{
				if ( !generate_atf )
				{
					this.texture = Texture.fromBitmapData(bmpdata, generate_mipmaps);
					if ( context_controls_disposal && Starling.handleLostContext )
					{
						this.texture.root.onRestore = function() {
							texture.root.uploadBitmapData( _spritesheet );
							trace( "Texture Restored:", pool, "-", sequence );
						}
					}
				}
				else
				{
					var options:EncodingOptions = new EncodingOptions();
					options.mipmap = generate_mipmaps;
					var data:ByteArray = Encoder.encode( bmpdata, options, null );
					this.texture = Texture.fromAtfData( data, 1, generate_mipmaps );
				}
			}
			
		}
		
		/**
		 * Retrieves a sparrow formatted XML object representation of the spritesheet for use in converting to a texture atlas
		 */
		
		public function get sparrow_xml():XML	{	return this._sparrow_xml	};
		public function set sparrow_xml(xml:XML):void
		{
			this._sparrow_xml = xml;
			
			if ( this.atlas ) {
				this.atlas.dispose();
			}
			
			this.atlas = new TextureAtlas( this.texture, xml );
		}
		
		/**
		 * If a helper was used to create the texture pack, this will return true.
		 */
		
		public function get isHelper():Boolean 
		{
			return (this.helper != null);
		}
		
		/**
		 * Gets the Texture Atlas of the Texture Pack
		 * @param	If the texture pack has been created with a helper, pass the sequence name to return a specific set of textures
		 * @return	Texture Atlas for use with a Starling Display Object.
		 */
		public function getTextures( helper_sequence:String = "" ):Vector.<Texture>
		{
			return this.atlas.getTextures( helper_sequence );
		}
		
		/**
		 * Creates a movieclip based on the texture pack.
		 * @param	fps	The frames per second this clip will run at
		 * @param	helper_sequence	If a helper has been used to create the texture pack, pass the name of the texture set here
		 * @return	A Starling MovieClip object
		 */
		public function getMovieClip( fps:int = 60, helper_sequence:String = "" ):MovieClip
		{
			var mc:MovieClip = new MovieClip( this.getTextures(helper_sequence), fps );
			var pt:Point = this.getOffset( helper_sequence );
			mc.pivotX = -pt.x;
			mc.pivotY = -pt.y;
			return mc;
		}
		
		/**
		 * Retrieves an Image object from the texture pack
		 * @param	asRenderTexture	The image is retrieved as a render texture object (dynamic and can be written to)
		 * @param	frame	If the source is a multiframe texture atlas (eg. MovieClip), you can designate which frame to output as an Image. Default is 0.
		 * @param	helper_sequence	If a helper was used to create the Texture Pack, pass through the desired sequence name here
		 * @return	The Image object for use in the Starling Framework
		 */
		public function getImage( asRenderTexture:Boolean=false, frame:int=0, helper_sequence:String = "" ):Image
		{
			var img:Image;
			
			if ( !this.atlas ) {
				if ( asRenderTexture ) {
					img = new Image( this.render_texture );
				} else {
					img = new Image( this.texture );
				}
			} else {
				var textures:Vector.<Texture> = this.atlas.getTextures( helper_sequence );
				if ( textures.length <= frame )
				{
					trace( "TexturePack - getImage :: The requested frame ("+frame+") or helper sequence ("+helper_sequence+") does not exist in this dojo" );
					return null;
				}
				img = new Image( textures[frame] );
			}
			
			var pt:Point = this.getOffset( helper_sequence );
			img.pivotX = -pt.x;
			img.pivotY = -pt.y;
			
			img.name = this.pool + "_" + this.sequence;
			
			return img;
		}
		
		/**
		 * Gets a random image from a multiframe texture
		 * @param	If a helper was used to create the texture pack, pass the desired sequence name here
		 * @return	An Image object generated from the multiframe texture atlas
		 */
		
		public function getRandomImage( helper_sequence:String = "" ):Image
		{
			if ( !this.atlas ) {
				img = new Image( this.texture );
				
			} else {
			
				var choice:int = Math.floor( Math.random() * this.atlas.getTextures(helper_sequence).length );
				var img:Image = new Image( this.atlas.getTextures(helper_sequence)[choice] );
				
			}
			
			var pt:Point = this.getOffset( helper_sequence );
			img.pivotX = -pt.x;
			img.pivotY = -pt.y;
			
			return img;
		}
		
		/**
		 * Retrieves the texture's x/y offset to translate the display object's pivot values
		 * @param	helper_sequence	If a helper was used to create the texture pack object, pass the desired sequence name here
		 * @return	The Point representation of the offset
		 */
		
		public function getOffset( helper_sequence:String = "" ):Point
		{
			if ( this.isHelper && helper_sequence.length )
			{
				return this.helper.getOffset(helper_sequence);
			}
			else
			{
				return this.offset;
			}
		}
		
		public function kill( spritesheet_only:Boolean = false ):void
		{
			this.killSelective( true, (spritesheet_only == false), true, (spritesheet_only == false) );
		}
		
		/**
		 * Removes and disposes texture and bitmapdata from memory
		 * @param	spritesheet	Flag the spritesheet data for removal
		 * @param	texture	Flag the texture for removal from the GPU
		 * @param	helper	Flag the helper object for disposal
		 * @param	render_texture	Flag the render texture for disposal
		 */
		public function killSelective( spritesheet:Boolean = true, texture:Boolean = true, helper:Boolean = true, render_texture:Boolean = true ):void
		{
			if ( this._spritesheet && spritesheet )
			{
				this._spritesheet.dispose();
				this._spritesheet = null;
			}
			
			if ( this.texture && texture )
			{
				this.texture.dispose();
				this.texture = null;
			}
			
			if ( this.helper && helper )
			{
				this.helper.dispose();
				this.helper = null;
			}
			
			if ( this.render_texture && render_texture )
			{
				this.render_texture.dispose();
				this.render_texture = null;
			}
			
			if ( (render_texture || texture) && this.atlas )
			{
				this.atlas.dispose();
				this.atlas = null;
			}
		}
		
		/**
		 * Converts a traditional display list MovieClip to a texture pack.
		 * @param	clip	The movieclip to capture frame-by-frame
		 * @param	pool	The pool name of the resulting texture pack
		 * @param	sequence	The sequence name of the resulting texture pack
		 * @param	timeline	If a sub-clip needs it's timeline to advance with the clip timeline, pass it through in this parameter
		 * @param	start_frame	The number of the first frame
		 * @param	end_frame	The number of the final frame. Leaving this as 0 will capture the every frame in the clip
		 * @param	crop	A rectangle object that will act as a clipping box for the resulting texture atlas
		 * @param	filter_pad	Allows a 'bleed' area around the movieclip bounds to account for any filters that may exceed the bounds area (like a glow filter or drop shadow for example)
		 * @param	onNewFrame	A function to call as the playhead advances through the clip timeline. If you have clip children that require calculations to be made on each frame, you can use this method.
		 * @param	onNewFrameArgs	An array of arguments to pass through to onNewFrame function.
		 * @return	A texture pack of the clip to be used within the Starling Framework.
		 */
		
		public static function createFromMovieClip( clip:flash.display.MovieClip, pool:String, sequence:String = "", timeline:flash.display.MovieClip = null, start_frame:int = 0, end_frame:int = 0, crop:Rectangle = null, filter_pad:int = 5, onNewFrame:Function = null, onNewFrameArgs:Array = null):TexturePack
		{
			var sq:SpriteSequence = SpriteSequence.create( clip, timeline, start_frame, end_frame, crop, filter_pad, onNewFrame, onNewFrameArgs );
			sq.pool = pool;
			sq.sequence = sequence;
			var tp:TexturePack = new TexturePack( sq );
			TexturePack.addTexturePack( tp );
			sq.dispose();
			
			return tp;			
		}
		
		/**
		 * Create a Texture Pack from a series of Sprite Sequences
		 * @param	sprite_sequences	Array of sprite sequence objects
		 * @param	pool	The name of the pool to be associated with the resulting texture pack
		 * @param	sequence_names	Array of sequence names to apply to each sprite_sequence. If left as null, the inherited sequence name will apply if there is one
		 * @param	disposeSource	Should the sprite sequences be disposed upon import
		 * @return	A texture pack object
		 */
		
		public static function createFromHelper( sprite_sequences:Array, pool:String, sequence:String = "", sequence_names:Array=null, disposeSource:Boolean = true ):TexturePack
		{
			if ( !sprite_sequences.length )
			{
				trace( "LaunchPad - TexturePack :: createFromHelper - Error creating as sprite_sequences array was empty" );
				return null;
			}
			
			if ( sequence_names )
			{
				for ( var i:uint = 0; i < sequence_names.length; i++ )
				{
					var ss:SpriteSequence = sprite_sequences[i] as SpriteSequence;
					ss.sequence = sequence_names[i];
				}
			}
			
			for ( i = 0; i < sprite_sequences.length; i++ )
			{
				ss = sprite_sequences[i] as SpriteSequence;
				ss.pool = pool;
			}
			
			var helper:SpriteSheetHelper = SpriteSheetHelper.consolidateSprites( sprite_sequences );
			
			var tp:TexturePack = new TexturePack();
			tp.pool = helper.pool;
			tp.sequence = sequence;
			tp.fromHelper( helper, disposeSource );
			addTexturePack( tp );
			
			return tp;
		}
		
		/**
		 * Adds a texture pack to memory for use in the application.
		 * @param	tp	The texture pack object to add to the library
		 */
		
		public static function addTexturePack( tp:TexturePack ):void
		{
			if ( !texture_packs ) {
				texture_packs = new Vector.<TexturePack>;
			}
			
			if ( !getTexturePack(tp.pool, tp.sequence) ) {
				texture_packs.push( tp );
			}
			
		}
		
		/**
		 * Deletes and disposes of an individual or group of texture packs from the application library.
		 * @param	pool	The pool name of the texture pack to target
		 * @param	sequence	The sequence name of the texture pack to target. Leaving this as an empty string will delete all instances of texture packs using the pool name.
		 * @param	prevent_kill	Prevents the Texture Pack from being disposed upon removal
		 */
		
		public static function deleteTexturePack( pool:String, sequence:String="", prevent_kill:Boolean = false ):void
		{
			if ( texture_packs ) {
				for ( var i:uint = 0; i < texture_packs.length; i++ ) {
					var tp:TexturePack = texture_packs[i] as TexturePack;
					if ( (tp.pool == pool && sequence == "") || (tp.pool == pool && tp.sequence == sequence) ) {
						if ( !prevent_kill )
						{
							tp.kill();
						}
						texture_packs.splice(i, 1);
						i--;
					}
				}
			}
			
		}
		
		/**
		 * Deletes and disposes of all texture packs from the application library.
		 */
		
		public static function deleteAllTexturePacks():void
		{
			while ( texture_packs && texture_packs.length ) {
				var tp:TexturePack = texture_packs[0];
				tp.kill();
				texture_packs.shift();
			}
			
		}
		
		/**
		 * Retrieves a designated texture pack from the application library for use with the Starling Framework
		 * @param	pool	The pool name of the texture pack
		 * @param	sequence	The sequence name of the texture pack. If passed as an empty string, the first texture pack with the passed pool name will be returned
		 * @return	The designated texture pack. If no match was found in the application library, null will be returned.
		 */
		
		public static function getTexturePack( pool:String, sequence:String="" ):TexturePack
		{
			if ( !texture_packs ) {
				return null;
			}
			
			var match:String = "";
			
			for ( var i:uint = 0; i < texture_packs.length; i++ ) {
				var tp:TexturePack = texture_packs[i] as TexturePack;
				if ( tp.pool == pool && tp.sequence == sequence ) {
					return tp;
				}
				if ( tp.pool == pool && sequence == "" && match == "" ) {
					match = tp.sequence;
				}
			}
			
			if ( match != "" ) {
				return getTexturePack( pool, match );
			}
			
			return null;
			
		}
		
		/**
		 * Traces out the list of texture pack objects that currently exist in the application library.
		 * @param	pool	If you wish to limit the traced results to a specific pool, pass through the pool name
		 */
		
		public static function traceAllTexturePacks( pool:String = "" ):int
		{
			var counter:int = 0;
			for ( var i:uint = 0; i < texture_packs.length; i++ )
			{
				var tp:TexturePack = texture_packs[i];
				if ( pool == "" || tp.pool == pool )
				{
					trace( "TEXTURE PACK - POOL:", tp.pool, ", SEQ:", tp.sequence, ", DIMENSIONS:", tp.texture.nativeWidth + " x " + tp.texture.nativeHeight );
					counter++;
				}
			}
			
			return counter;
		}
		
		public static function getTexturePackFromTexture( texture:Texture ):TexturePack
		{
			for ( var i:int = 0; i < texture_packs.length; i++ )
			{
				if ( texture_packs[i].texture == texture )
				{
					return texture_packs[i];
				}
			}
			
			return null;
		}
		
		public static function restoreAllTextures():void
		{
			if ( !texture_packs || texture_packs.length == 0 ) return void;
			
			for ( var i:int = 0; i < texture_packs.length; i++ )
			{
				var tp:TexturePack = texture_packs[i];
				tp.texture.root.onRestore();
			}
		}
	}

}