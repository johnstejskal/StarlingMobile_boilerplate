package com.johnstejskal 
{

	import com.adobe.images.BitString;
	import com.greensock.plugins.*;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	import staticData.DataVO;
	import com.adobe.images.JPGEncoder;
	import com.adobe.images.PNGEncoder;

	import singleton.Core;
	/**
	 * ...
	 * @author john
	 */
	public class SaveBitmapToDisk 
	{
		
		private var _core:Core;
		private const _stage:Stage = Core.getInstance().main.stage;
		private var _screenShot:Bitmap;
		private var bitmapData2:BitmapData;
		
		
		//----------------------------------------o
		//------ Constructor
		//----------------------------------------o				
		public function SaveBitmapToDisk() 
		{
			_core = Core.getInstance();
			
		}

		//----------------------------------------o
		//------ Private Methods 
		//----------------------------------------o		
		//----------------------------------------o
		//------ Public Methods 
		//----------------------------------------o	
		
		
		//////////////////////////////////////
		// Flash File saving and image encoding example.
		// www.permadi.com
		// (C) F. Permadi
		//////////////////////////////////////

		public function saveBitmapTargetToDisk(_target:*, fileName:String, _width:int, _height:int , quality:int ):void
		{	
			//var tempMcHolder:MovieClip = new MovieClip();
			//tempMcHolder.addChild(_target)
			var fileName:String = fileName;
			var quality:int = quality;
			
			var bitmapData:BitmapData=new BitmapData(_width, _height);
			bitmapData.draw(MovieClip(_target));  
			
			_screenShot = new Bitmap(bitmapData)
			_screenShot.smoothing = true;
			//_screenShot.scaleX = _screenShot.scaleY = .3;
			
			
			
			bitmapData2=new BitmapData(_width, _height);
			bitmapData2.draw(_screenShot);
			
		
			
			saveToDisk(bitmapData2, fileName, quality)

			
		}
		
		public function saveToDisk(_target:*, _fileName:String, _quality:int):void
		{
			var fileName:String = _fileName;
			var quality:int =  _quality;
			var target:* = _target;
			
			trace(this + "saveToDisk");
			var jpgEncoder:JPGEncoder = new JPGEncoder(quality);
			var byteArray:ByteArray = jpgEncoder.encode(target);

			var fileReference:FileReference=new FileReference();
			fileReference.save(byteArray, fileName); 
		}



		
		
		
		
		//----------------------------------------o
		//------ Event Handlers
		//----------------------------------------o		
		
	}

}