package com 
{
	import com.thirdsense.animation.SpriteSequence;
	import com.thirdsense.animation.TexturePack;
	import flash.display.MovieClip;
	import starling.display.Image;

	/**
	 * ...
	 * @author ...
	 */
	public class LaunchPadUtil 
	{
		
		public function LaunchPadUtil() 
		{
			
		}
		
		public static function convertToImage( mc:MovieClip, pool:String, sequence:String = "" , mcFrameFirst:int = 1, mcFrameLast:int = 1, padding:int = 5):Image
		{
			if(!TexturePack.getTexturePack(pool, sequence)){
			 var sq:SpriteSequence;
			 var tp:TexturePack;
			
			 sq = SpriteSequence.create( mc, null, mcFrameFirst, mcFrameLast,null, padding,null)
			 
			 sq.pool = pool;
			 sq.sequence = sequence;
			
			 tp = new TexturePack( sq );
			 TexturePack.addTexturePack( tp );
			 sq.dispose();
			}
			var myImage:Image = TexturePack.getTexturePack(pool, sequence).getImage();
			myImage.touchable=false
			return myImage
			
		}
		
		public static function convertToMovieClip( mc:MovieClip, pool:String, sequence:String = "" ,mcFrameFirst:int=1,mcFrameLast:int=1, padding:int = 5):starling.display.MovieClip
		{
			if(!TexturePack.getTexturePack(pool, sequence)){
			 var sq:SpriteSequence;
			 var tp:TexturePack;
			 
			 sq = SpriteSequence.create( mc, null, mcFrameFirst, mcFrameLast,null, padding, null)
			 
			 sq.pool = pool;
			 sq.sequence = sequence;
			
			 tp = new TexturePack( sq );
			 TexturePack.addTexturePack( tp );
			 sq.dispose();
			}
			var myMC:starling.display.MovieClip = TexturePack.getTexturePack(pool, sequence).getMovieClip()
			myMC.touchable=false
			return myMC
			
		}
		
	}

}