package com.gokhantank.util
{
	
	import flash.display.MovieClip;
	import fl.video. *;
	import flash.events.Event;
	import flash.display.Loader;
	import flash.events.ProgressEvent;
	import flash.events.IOErrorEvent;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.utils.Dictionary;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.net.navigateToURL
	import flash.events.MouseEvent;
	
	public class VidLoader extends MovieClip
	{
		private var Cont:MovieClip
		private var videoPath : String = "flv/2009_1.flv";
		private var myVideo : FLVPlayback
		//-------------------------------------------o
		public var TotalTime:Number;
		public var PlayingTime:Number;
		public var PlayingPercent:Number;
		//==========================================================O
		//---o constructor
		//==========================================================O
		public function VidLoader (str : String)
		{
			videoPath = str;
			Cont = new MovieClip();
			addChild(Cont)
			init();
		}
		private function init ()
		{
			myVideo = new FLVPlayback ();
			myVideo.source = videoPath;
			myVideo.width = 578;
			myVideo.height = (578 / 4) * 3;
			myVideo.x = 0;
			myVideo.y = -69;
			myVideo.autoPlay = false;
			
			//myVideo.skin = "SkinOverPlayStopSeekMuteVol.swf";
			//myVideo.skinBackgroundColor = 0x333333
			//myVideo.skinBackgroundAlpha = 1;
			//myVideo.skinAutoHide = true
			
			myVideo.addEventListener (VideoEvent.READY, videoReady);
			myVideo.addEventListener (VideoEvent.PLAYHEAD_UPDATE, videoPlaying);
			myVideo.addEventListener (VideoEvent.COMPLETE, videoComplete);
			Cont.addChild (myVideo);
		}
		private function videoReady (ev : VideoEvent)
		{
			TotalTime = Math.round(myVideo.totalTime);
			dispatchEvent (new VideoEvent (VideoEvent.READY));
		}
		private function videoComplete (ev : VideoEvent)
		{
			dispatchEvent (new VideoEvent (VideoEvent.COMPLETE));
		}	
		private function videoPlaying (ev : VideoEvent)
		{
			PlayingTime = Math.round(ev.playheadTime)
			PlayingPercent = (PlayingTime / TotalTime) * 100;
			dispatchEvent (new VideoEvent (VideoEvent.PLAYHEAD_UPDATE));
		}			
		//----------------------------------------------------------------o
		public function PlayVideo() {
			myVideo.play();	
		}
		public function StopVideo() {
			myVideo.stop();	
		}	
		public function PauseVideo() {
			myVideo.pause();	
		}	
		public function removeVideo ()
		{
			destroy (myVideo);
			reSetup(myVideo);
		}
		//--------------------------------------------------------------o
		private static function destroy (vid : FLVPlayback) : void
		{
			if (vid.playing)
			{
				vid.stop ();
			}
			for each (var v : VideoPlayer in vid.flvplayback_internal :: videoPlayers)
			{
				v.close ();
			}
		}
		private static function reSetup(vid: FLVPlayback) : void
		{
			var vp:VideoPlayer = new VideoPlayer(0, 0);
			vp.setSize(vid.width, vid.height);
			vid.flvplayback_internal::videoPlayers = new Array();
			vid.flvplayback_internal::videoPlayers[0] = vp;
			vid.flvplayback_internal::_firstStreamShown = false;
			vid.flvplayback_internal::_firstStreamReady = false;
			vid.flvplayback_internal::videoPlayerStates = new Array();
			vid.flvplayback_internal::videoPlayerStateDict = new Dictionary(true);
			vid.flvplayback_internal::createVideoPlayer(0);
		}
	}
}
