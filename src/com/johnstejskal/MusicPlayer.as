package com.johnstejskal 
{
	import com.gokhantank.util.Delegate;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	import flash.media.SoundLoaderContext;

	/**
	$(CBI)* ...
	$(CBI)* @author SelfLearner
	$(CBI)*/
	public class MusicPlayer extends EventDispatcher
	{
		private var _playing:Boolean = false;
		//==========================================================O
		//---o 
		//==========================================================O
		private var getMusic:URLRequest;
		private var music:Sound;
		private var soundChannel:SoundChannel;
		private var pos:Number;
		static private var _self:MusicPlayer
		public static const MUSIC_PLAYED:String = "music_played";
		public static const MUSIC_LOADED:String = "music_loaded";
		public static const MUSIC_COMPLETED:String = "music_completed";
		//==========================================================O
		//---o 
		//==========================================================O
		public function MusicPlayer() 
		{
			
		}
		
		public static function get self():MusicPlayer {
			if (!_self) _self = new MusicPlayer();
			return _self;
		}	
		//==========================================================O
		//---o 
		//==========================================================O
		public function loadMusic(path:String):void {
			trace(this+".loadMusic");
			_playing = false;
			kill();
			var urlRequest:URLRequest = new URLRequest(path);
			music = new Sound();
			music.addEventListener(Event.COMPLETE, musicReady);
			
			var context:SoundLoaderContext = new SoundLoaderContext(8000, true);
			music.load(urlRequest, context);
			
			dispatchEvent(new Event(MUSIC_LOADED));
			playMusic();
			

		}
		public function loopMusic(e:Event):void
		{
			/*
			if (soundChannel != null)
			{
				soundChannel.removeEventListener(Event.SOUND_COMPLETE, loopMusic);
				playMusic();
			}
			*/
			dispatchEvent(new Event(MUSIC_COMPLETED));
		}
		private function musicReady(ev:Event):void {
			//playMusic();
			//dispatchEvent(new Event(MUSIC_LOADED));
		}
		//==========================================================O
		//---o LOGICAL FUNCTIONS
		//==========================================================O
		private function playMusic(num:Number = 0 ):void {
			dispatchEvent(new Event(MUSIC_PLAYED));
			_playing = true;
			soundChannel = music.play(num);
			soundChannel.addEventListener(Event.SOUND_COMPLETE, loopMusic);
		}
		private function pauseMusic():void {
			_playing = false;
			if(soundChannel !=null){ 
				pos = soundChannel.position;
				soundChannel.removeEventListener(Event.SOUND_COMPLETE, loopMusic);
				soundChannel.stop();
			}
		}
		//==========================================================O
		//---o PUBLIC PLAY PAUSE STOP FUNS
		//==========================================================O
		public function pause():void {
			trace(this + ".pause");
			trace("_playing: "+_playing);
			if (_playing) pauseMusic();
		}
		public function stop():void {
			if (_playing) pauseMusic();
			pos = 0;
		}
		public function play():void {
			playMusic(pos);
		}
		//==========================================================O
		//---o KILL
		//==========================================================O
		public function kill():void {

			if(soundChannel !=null){ 
			
				
				soundChannel.removeEventListener(Event.SOUND_COMPLETE, loopMusic);
				soundChannel.stop();
				//delete soundChannel;
				soundChannel = null;
				
			}
			if (music) {
				
				music.removeEventListener(Event.COMPLETE, musicReady);
				try
				{
					 music.close();
				}
				catch(err:Error)
				{
					trace("couldnt close it");
					 //Do nothing
				}
				//delete music;
				music = null;
				
			}
			
			
		}
	}
}