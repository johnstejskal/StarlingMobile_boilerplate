package ManagerClasses 
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import singleton.Core;
	import view.components.ComponentTemplate;
	import staticData.DataVO;

	/**
	 * ...
	 * @author john
	 */
	public class SoundManager 
	{
		//---------------------------------------o
		//------  Sound and Audio
		//---------------------------------------o
		[Embed(source="../../assets/audio/music/music-loop.mp3")]
		public static const gameplayMusic:Class;
		
		[Embed(source="../../assets/audio/music/short.mp3")]
		public static const screenMusic:Class;		
		
		[Embed(source="../../assets/audio/music/title-music.mp3")]
		public static const titleMusic:Class;		
		
		
		//---------------------------------------o
		//------  Character Sounds
		//---------------------------------------o
		[Embed(source="../../assets/audio/fx/character/male/grunt1.mp3")]
		public static const PLAYERB_GRUNT1:Class;
		public static var playerB_grunt1:Sound = new SoundManager.PLAYERB_GRUNT1() as Sound;
		
		[Embed(source="../../assets/audio/fx/character/male/grunt2.mp3")]
		public static const PLAYERB_GRUNT2:Class;		
		public static var playerB_grunt2:Sound = new SoundManager.PLAYERB_GRUNT2() as Sound;

		[Embed(source="../../assets/audio/fx/character/unisex/grunt1.mp3")]
		public static const UNISEX_GRUNT1:Class;
		public static var unisex_grunt1:Sound = new SoundManager.UNISEX_GRUNT1() as Sound;
		
		[Embed(source="../../assets/audio/fx/character/unisex/grunt2.mp3")]
		public static const UNISEX_GRUNT2:Class;			
		public static var unisex_grunt2:Sound = new SoundManager.UNISEX_GRUNT2() as Sound;		
		
		[Embed(source="../../assets/audio/fx/character/unisex/grunt3.mp3")]
		public static const UNISEX_GRUNT3:Class;
		public static var unisex_grunt3:Sound = new SoundManager.UNISEX_GRUNT3() as Sound;	
		
		[Embed(source="../../assets/audio/fx/character/unisex/grunt4.mp3")]
		public static const UNISEX_GRUNT4:Class;
		public static var unisex_grunt4:Sound = new SoundManager.UNISEX_GRUNT4() as Sound;			
		
		[Embed(source="../../assets/audio/fx/character/unisex/jump.mp3")]
		public static const UNISEX_JUMP:Class;	
		public static var unisex_jump:Sound = new SoundManager.UNISEX_JUMP() as Sound;		
		
		
		//---------------------------------------o
		//------  Seagull Sounds
		//---------------------------------------o
		[Embed(source="../../assets/audio/fx/seagulls/attack.mp3")]
		public static const SEAGULLS_ATTACK1:Class;		
		public static var seagulls_attack1:Sound = new SoundManager.SEAGULLS_ATTACK1() as Sound;
		//---------------------------------------o
		//------  Collectable sounds
		//---------------------------------------o		
		[Embed(source="../../assets/audio/fx/energyfield.mp3")]
		public static const ENERY_FIELD:Class;			
		private var _snEnergyField:Sound = new SoundManager.ENERY_FIELD() as Sound;
		
		[Embed(source="../../assets/audio/fx/collectitem.mp3")]
		public static const COLLECT_ITEM:Class;		
		public static var snCollectItem:Sound = new SoundManager.COLLECT_ITEM() as Sound;
		
		[Embed(source="../../assets/audio/fx/collectFood.mp3")]
		public static const COLLECT_FOOD:Class;				
		public static var snCollectFood:Sound = new SoundManager.COLLECT_FOOD() as Sound;
		
		[Embed(source="../../assets/audio/fx/superJump.mp3")]
		public static const SUPER_JUMP:Class;				
		public static var snSuperJump:Sound = new SoundManager.SUPER_JUMP() as Sound;		
			
		[Embed(source="../../assets/audio/fx/scoreDing.mp3")]
		public static const SCORE_DING:Class;				
		public static var snScoreDing:Sound = new SoundManager.SCORE_DING() as Sound;				
		
		[Embed(source="../../assets/audio/fx/dogBark.mp3")]
		public static const DOG_BARK:Class;				
		public static var snDogBark:Sound = new SoundManager.DOG_BARK() as Sound;		
		
		[Embed(source="../../assets/audio/fx/playful_reveal_melodic_01.mp3")]
		public static const MELODY1:Class;				
		public static var snMelody1:Sound = new SoundManager.MELODY1() as Sound;				

		[Embed(source="../../assets/audio/fx/playful_reveal_melodic_02.mp3")]
		public static const MELODY2:Class;				
		public static var snMelody2:Sound = new SoundManager.MELODY2() as Sound;		
		
		[Embed(source="../../assets/audio/fx/playful_reveal_melodic_03.mp3")]
		public static const MELODY3:Class;				
		public static var snMelody3:Sound = new SoundManager.MELODY3() as Sound;				
		//---------------------------------------o
		//------  UI Sounds
		//---------------------------------------o			
		[Embed(source="../../assets/audio/fx/rollOver.mp3")]
		public static const PLAYER_SECLECT_RO:Class;				
		public static var snPlayerSelectRO:Sound = new SoundManager.PLAYER_SECLECT_RO() as Sound;				
		
		[Embed(source="../../assets/audio/fx/magicWand.mp3")]
		public static const PLAYER_SELECT_CLK:Class;				
		public static var snPlayerSelectClick:Sound = new SoundManager.PLAYER_SELECT_CLK() as Sound;			
		
		//public static var seagulls_flap:Sound = new SoundManager.SEAGULLS_FLAP() as Sound;
		
		public static const MUSIC_PLAY:int = 0;
		public static const SCREEN_MUSIC:int = 1;
		public static const TITLE_SCREEN:int = 2;		
		
		
		private var _core:Core;
		public var snGamePlayMusic:Sound;
		private var _scMusicChannel:SoundChannel;
		private var _stSoundTransform:SoundTransform;
		private var snScreenMusic:Sound;
		private var _scScreenMusicChannel:SoundChannel;
		private var _stSoundTransform2:SoundTransform;
		private var snTitleMusic:Sound;
		private var _scTitleMusicChannel:SoundChannel;
		private var _stSoundTransform3:SoundTransform;
		private var _stSoundTransformFX:SoundTransform;
		private var _scFXChannel:SoundChannel;
		
		private var _scEnergyField:SoundChannel;
		private var _scGruntChannel:SoundChannel;
		private var _scSeagullChannel:SoundChannel;
		
		//----------------------------------------o
		//------ Constructor
		//----------------------------------------o				
		public function SoundManager() 
		{
			trace(this+"inited")
			_core = Core.getInstance();
			
			//----------------------------------------o
			//------- MUSIC  
			//----------------------------------------o
			snGamePlayMusic = new SoundManager.gameplayMusic() as Sound;
			_scMusicChannel = new SoundChannel();
			_stSoundTransform = new SoundTransform(.2);
			
			
			snScreenMusic = new SoundManager.screenMusic() as Sound;
			_scScreenMusicChannel = new SoundChannel();
			//_stSoundTransform2 = new SoundTransform(.05);		
			
			snTitleMusic = new SoundManager.screenMusic() as Sound;
			_scTitleMusicChannel = new SoundChannel();
			//_stSoundTransform3 = new SoundTransform(.05);	
			
			_scGruntChannel = new SoundChannel();
			//----------------------------------------o
			//------- SOUND FX  
			//----------------------------------------o			
			_scFXChannel = new SoundChannel();
			_stSoundTransformFX = new SoundTransform();
			
			_scEnergyField = new SoundChannel();
			_scSeagullChannel = new SoundChannel()
			}
		
		public function playSoundEffect(target:Sound, volume:Number = .1, count:int = 1):void
		{
			if (DataVO.SOUND_MUTED)
			return;
			
			_stSoundTransformFX.volume = volume;
			_scFXChannel.soundTransform = _stSoundTransformFX;
			_scFXChannel = target.play(0, count, _stSoundTransformFX);
		}
		
		public function fadeOutMusic():void
		{
			TweenMax.to(_scMusicChannel, 2, {delay:1, volume:0});
		}
		
		
		public function playSeagull(volume:Number = .3):void
		{
			if (DataVO.SOUND_MUTED)
			return;			
			
			_stSoundTransformFX.volume = volume;
			_scSeagullChannel.soundTransform = _stSoundTransformFX;
			_scSeagullChannel = SoundManager.seagulls_attack1.play(0, 1, _stSoundTransformFX);
		}
		
		public function playGrunt(target:Sound = null):void
		{
			if (DataVO.SOUND_MUTED)
			return;	
			
			_stSoundTransformFX.volume = .1;
			_scGruntChannel.soundTransform = _stSoundTransformFX;
			//_scGruntChannel = target.play(0,1,_stSoundTransformFX)
			_scGruntChannel = SoundManager["unisex_grunt" + Math.ceil(Math.random() * 4)].play(0, 1, _stSoundTransformFX)
			
			//_core.cl_soundManager.playSoundEffect(SoundManager["unisex_grunt" + Math.ceil(Math.random() * 3)]);
		}		
		
		public function playEneryField(volume:Number = .5):void
		{
			if (DataVO.SOUND_MUTED)
			return;
			
			_stSoundTransformFX.volume = volume;
			_scEnergyField.soundTransform = _stSoundTransformFX;
			_scEnergyField = _snEnergyField.play(0, 8, _stSoundTransformFX);
		}		
		
		
		public function changeMusicState(state:int):void
		{
			SoundMixer.stopAll();
			if (DataVO.SOUND_MUTED)
			return;
			
			switch(state)
			{
				case MUSIC_PLAY:
				_stSoundTransform.volume = .2;
				_scMusicChannel.soundTransform = _stSoundTransform;
				_scMusicChannel = snGamePlayMusic.play(0,int.MAX_VALUE,_stSoundTransform)
				break;
				
				case SCREEN_MUSIC:
				_stSoundTransform.volume = .05;
				_scScreenMusicChannel.soundTransform = _stSoundTransform;
				_scScreenMusicChannel = snScreenMusic.play(0,int.MAX_VALUE,_stSoundTransform)
				break;	
				
				case TITLE_SCREEN:
				_stSoundTransform.volume = .05;
				_scScreenMusicChannel.soundTransform = _stSoundTransform;
				_scScreenMusicChannel = snScreenMusic.play(0,int.MAX_VALUE,_stSoundTransform)
				break;		
				
				
				}
			
		}

		//----------------------------------------o
		//------ Private Methods 
		//----------------------------------------o		
		
		
		//----------------------------------------o
		//------ Public Methods 
		//----------------------------------------o		
		
		public function init_component(_parent:*, _x:int, _y:int):void
		{
			trace(this + " inited");

		}
		
		public function stopAll():void 
		{
			SoundMixer.stopAll();
		}
		
		public function mute():void 
		{
			DataVO.SOUND_MUTED = true;
			_stSoundTransform.volume = 0;
			
			_scMusicChannel.soundTransform = _stSoundTransform;
			_scScreenMusicChannel.soundTransform = _stSoundTransform;
			_scSeagullChannel.soundTransform = _stSoundTransform;	
			_scEnergyField.soundTransform = _stSoundTransform;
			
		}
		public function unmute():void 
		{
			DataVO.SOUND_MUTED = false;
			_stSoundTransform.volume = .2;
			_scMusicChannel.soundTransform = _stSoundTransform;
			
			_stSoundTransform.volume = .05;
			_scScreenMusicChannel.soundTransform = _stSoundTransform;		
			
		}		
		public function get scMusicChannel():SoundChannel 
		{
			return _scMusicChannel;
		}
		

		

		
		
	

		
		
		//----------------------------------------o
		//------ Event Handlers
		//----------------------------------------o	
		


		


		
		
		//----------------------------------------o
		//------ Getters
		//----------------------------------------o	

		
		//----------------------------------------o
		//------ Setters
		//----------------------------------------o	
		

		
	}

}