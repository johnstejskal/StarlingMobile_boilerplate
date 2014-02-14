package com.gokhantank.util
{
	import gs.TweenLite;
	import gs.easing.*;	
	import fl.video.VideoEvent;
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.text. * ;
	import flash.external. *	
	public class VidPlayer extends MovieClip
	{
		private var Cont:MovieClip
		private var videoPath:String
		private var VidMc:VidLoader
		private var Controls:MovieClip
		private var PlayPauseMc:MovieClip;
		private var ProgressBarMc:MovieClip;
		private var FullMc:MovieClip;
		private var DurationTxt:TextField;
		private var PanelMc:MovieClip;
		private var IndicMc:MovieClip;
		private var Playing:Boolean = false;
		public static const VIDEO_PLAY:String = "video_play";
		public static const VIDEO_PAUSE:String = "video_pause";
		
		//==========================================================O
		//---o constructor
		//==========================================================O
		public function VidPlayer ()
		{
			videoPath = "flv/2009_1.flv";
			Cont = new MovieClip();
			addChild(Cont)
			init();
		}
		private function init ()
		{
			putVideo();
			putControls();
		}
		//==========================================================O
		//---o video
		//==========================================================O
		private function putVideo() {
			VidMc = new VidLoader(videoPath)
			VidMc.x = 0;
			VidMc.y = 0;
			VidMc.addEventListener(VideoEvent.READY,vidReady)
			VidMc.addEventListener(VideoEvent.PLAYHEAD_UPDATE,vidPlaying)
			VidMc.addEventListener(VideoEvent.COMPLETE,vidComplete)
			Cont.addChild(VidMc);
		
		}
		//------------------------------------------------------------------o
		private function vidReady(ev:VideoEvent) {
			//playPause()
		}
		//------------------------------------------------------------------o
		private function vidPlaying(ev:VideoEvent) {
			//trace(VidMc.PlayingTime);
			DurationTxt.text = secToTime(0,VidMc.PlayingTime)
			var xPos:Number = VidMc.PlayingPercent / 100
			TweenLite.to (IndicMc, 1, { scaleX : xPos, overwrite : true } );
			if (IndicMc.width - PanelMc.width < 0) {
				PanelMc.x = 0;
			}else{
				TweenLite.to (PanelMc, 1, { x :IndicMc.width - PanelMc.width, overwrite : true } );
			}
		}	
		private function vidComplete(ev:VideoEvent) {
			//trace(VidMc.PlayingTime);
			TweenLite.to (IndicMc, 1, { scaleX : 0, overwrite : true } )
			DurationTxt.text = "00:00";	
			VidMc.StopVideo();
			playPause()
		}			
		private function secToTime (dir:Number,a:Number):String {
			var sonuc:String = "";
			var SecondStr:String = "";
			var MinuteStr:String = "";
			if (dir!=0) {
				a = dir - a;
			}
			var MinuteCount:int = a / 60;
			var SecondCount:int = a - (MinuteCount * 60);
			SecondCount <10 ? SecondStr = String("0"+SecondCount): SecondStr = String(SecondCount);
			MinuteCount <10 ? MinuteStr= String("0"+MinuteCount) : MinuteStr= String(MinuteCount);
			sonuc = String(MinuteStr + ":" + SecondStr);
			
			return sonuc;
		}		
		//=================================================================o
		//---o Controls
		//=================================================================o
		private function putControls() {
			trace(this + ".putControls");
			Controls = new ControlHolder();
			Controls.x = 94;
			Controls.y = 225
			setClips();
			setControls();
			Cont.addChild(Controls);	
		}
		private function setClips():void{
			PlayPauseMc = Controls["PlayPauseMc"];
			PlayPauseMc.buttonMode = true;
			FullMc = Controls["FullMc"];
			FullMc.buttonMode = true;
			PlayPauseMc.mouseChildren = false;
			ProgressBarMc = Controls["ProgressBarMc"];
			IndicMc = ProgressBarMc["IndicMc"];
			//DurationTxt= ProgressBarMc["DurationTxt"];
			PanelMc= ProgressBarMc["$panel"];
			DurationTxt= PanelMc["$txt"];
			IndicMc.scaleX = 0;
		}
		private function setControls() {
			PlayPauseMc.stop();
			PlayPauseMc.addEventListener(MouseEvent.CLICK, playTrigger);	
			FullMc.addEventListener(MouseEvent.CLICK, callJS);
		}
		private function callJS(ev:MouseEvent) {
			if (ExternalInterface.available)
			{
				ExternalInterface.call ("showDiv");
			}
		}
		private function playTrigger(ev:MouseEvent) {
			playPause()
		}
		private function playPause() {
			if (Playing) {
					Playing = false;
					dispatchEvent(new Event(VIDEO_PAUSE));
					PlayPauseMc.gotoAndStop("playVid");
					PlayPauseMc.mouseChildren = false;
					VidMc.PauseVideo();
				}else {
					Playing = true;
					dispatchEvent(new Event(VIDEO_PLAY));
					PlayPauseMc.gotoAndStop("pauseVid");
					PlayPauseMc.mouseChildren = false;
					VidMc.PlayVideo();
			}	
		}
		public function removeVideo():void {
			VidMc.removeVideo();
		}
		public function pauseVideo():void {
			Playing = false;
			//dispatchEvent(new Event(VIDEO_PAUSE));
			PlayPauseMc.gotoAndStop("playVid");
			PlayPauseMc.mouseChildren = false;
			VidMc.PauseVideo();
		}
	}
}
