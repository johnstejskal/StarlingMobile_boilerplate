package com.gokhantank.ui 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.display.Loader;
	/**
	$(CBI)* ...
	$(CBI)* @author Gokhan Tank
	$(CBI)*/
	public class UploadPanel extends Component
	{
		private var _fileRef:FileReference;
		private var _external:Array;
		private var _loader:Loader;
		private var _bitmap:Bitmap;
		private var _filter:FileFilter;
		
		public function UploadPanel() 
		{
			initUpload();
		}
		private function initUpload() {
			//-------------------------------------------------------------------
			_fileRef = new FileReference();
			_filter = new FileFilter("Jpg Dosyası", ".jpg;*.jpeg;*.JPG;*.JPEG;");
			_external = new Array();
			_loader = new Loader();
			_external.push(_filter);
			//-------------------------------------------------------------------
			_fileRef.addEventListener(Event.SELECT, onFileSelected);
			_fileRef.addEventListener(Event.COMPLETE, onFileCompleted);
			_fileRef.addEventListener (Event.CANCEL, onFileCanceled);
			_fileRef.addEventListener(ProgressEvent.PROGRESS, onFileProgress);
		}
		public function showFileBrowse():void
		{
			_fileRef.browse(_external);
			
		}
		public function loadFile():void
		{
			_fileRef.load ();
		}
		//--------------------------------------
		//---- UPLOAD SELECT / PROGRESS / CANCEL
		//--------------------------------------
		protected function onFileCanceled(e:Event):void
		{
			_fileRef.cancel ();
			//EVENT: IMAJ YUKLEME IPTAL EDILDI.
			trace("yukleme isleminiz iptal edildi.");
		}
		protected function onFileSelected(e:Event):void
		{
			trace("size: " + _fileRef.size+" name: "+_fileRef.name);
			if (_fileRef.size > 1500000) {
				//EVENT: 1,5 mb'dan kucuk olmalı
				return;
			}
			//EVENT: IMAJ SEÇİLİ YUKLEMEYE HAZIR
		}
		protected function onFileProgress(e:ProgressEvent):void
		{
			trace("Loaded " + e.bytesLoaded + " of " + e.bytesTotal + " bytes.");
			//EVENT: PROGRESS
		}
		//--------------------------------------
		//---- UPLOAD COMPLETED
		//--------------------------------------
		protected function onFileCompleted(e:Event):void
		{
			_loader.loadBytes (_fileRef.data);
			_loader.addEventListener(Event.ADDED_TO_STAGE, onFileAddedToStage);
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onFileUploaded);
		}
		protected function onFileUploaded(e:Event):void{
		
			var loaderInfo:Object = e.target;
			var bmd:BitmapData = loaderInfo.loader.content.bitmapData;
			_bitmap = new Bitmap(bmd);
			trace("bitmap.width: " + bitmap.width);
			_bitmap.smoothing = true;
			//EVENT: COMPLETED
		}
		
		protected function onFileAddedToStage(e:Event):void
		{
			_loader.removeEventListener(Event.ADDED_TO_STAGE, onFileAddedToStage);
			//IMAGE ADDEDTOSTAGE
		}
		
		public function get bitmap():Bitmap { return _bitmap; }
		
		public function get fileRef():FileReference { return _fileRef; }
		
	}

}