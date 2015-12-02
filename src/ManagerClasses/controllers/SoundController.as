package ManagerClasses.controllers 
{
	import com.johnstejskal.Maths;
	import com.johnstejskal.SharedObjects;
	import com.thirdsense.sound.SoundStream;
	import flash.media.SoundChannel;
	import flash.net.SharedObject;
	import ManagerClasses.supers.SuperController;
	import staticData.dataObjects.PlayerData;
	import staticData.LocalDataKeys;
	import staticData.SharedObjectKeys;
	import staticData.SoundData;
	import staticData.Sounds;
	import treefortress.sound.SoundAS;
	import treefortress.sound.SoundInstance;
	import treefortress.sound.SoundManager;

	
	//================================================o
	/**
	 * @author John Stejskal
	 * "Why walk when you can ride"
	 */
	//================================================o
	
	public class SoundController extends SuperController
	{
		private var sndthrust:SoundChannel;
		private var _soundGroup_music:SoundManager;
		private var _soundGroup_sfx:SoundManager;
		
		
		//================================================o
		//------ Constructor
		//================================================o			
		public function SoundController() 
		{
			
			
		}
		
		//================================================o
		//------ init
		//================================================o				
		public function init():void
		{
			restoreSettings();
			SoundAS.loadSound("lib/mp3/changeLane01.mp3", Sounds.SFX_CHANE_LANES_1);
	

		}

		//================================================o
		//------ Restore Settings from SharedObjects
		//================================================o	
		private function restoreSettings():void 
		{
			trace(this+"restoreSettings():"+SoundData.isSFXMuted);
			if (SoundData.isSFXMuted)
			{
				SoundAS.mute = true;
			}
		}

		//================================================o
		//------ Enable Sound effects
		//================================================o		
		public function enableSoundFX():void
		{
			
		}
				
		//================================================o
		//------ Disable Sound effects
		//================================================o		
		public function disableSoundFX():void
		{

		}
		
		//================================================o
		//------ toggle Sound effects
		//================================================o		
		public function toggleSoundFX():void
		{
			if (!SoundData.isSFXMuted)
			{
				SoundAS.mute = true;
				SoundData.isSFXMuted = true;
				SharedObjects.setProperty(SharedObjectKeys.IS_SFX_MUTED, true);
			}
			else
			{
				SoundAS.mute = false;	
				SoundData.isSFXMuted = false;
				SharedObjects.setProperty(SharedObjectKeys.IS_SFX_MUTED, false);
			}
			
			trace(this + "toggleSoundFX()" + SharedObjects.getProperty(SharedObjectKeys.IS_SFX_MUTED));
		}
		
		
		//================================================o
		//------ Enable Music
		//================================================o		
		public function enableMusic():void
		{
			SoundAS.mute = false;	
		}
				
		//================================================o
		//------ Disable Music
		//================================================o		
		public function disableMusic():void
		{
			SoundAS.mute = true;	
		}
		
		//================================================o
		//------ toggle Music
		//================================================o		
		public function toggleMusic():void
		{
			if (!SoundData.isMusicMuted)
			{
				SoundData.isMusicMuted = true;
				SharedObjects.setProperty(SharedObjectKeys.IS_MUSIC_MUTED, true);
			}
			else
			{
				SoundData.isMusicMuted = false;
				SharedObjects.setProperty(SharedObjectKeys.IS_MUSIC_MUTED, false);
			}
		}


		//================================================o
		//------ trash/kill/dispose
		//================================================o		
		public function trash():void
		{
			
		}
		
		
		public function playSpecialZoneMusic():void
		{
			
		}
		public function playMusicLoop(num:int = 1):void 
		{
			
			if (Sounds.currentMusic != null)
			SoundAS.getSound(Sounds.currentMusic).stop();
			
			//fail safe------o
			if (SoundAS.getSound(Sounds.MUSIC_LOOP_1).isPlaying)
			SoundAS.getSound(Sounds.MUSIC_LOOP_1).stop();
									
			if (SoundAS.getSound(Sounds.MUSIC_LOOP_2).isPlaying)
			SoundAS.getSound(Sounds.MUSIC_LOOP_2).stop();
			//------o
			
			Sounds.currentMusic = "musicLoop" + num;
			SoundAS.play(Sounds.currentMusic, .8).soundCompleted.addOnce(function(si:SoundInstance):void { 
				
				playMusicLoop(Maths.rn(1, 2));
				
			})	
		}
		
		public function checkIfMusicFailed():void 
		{
			
			if (SoundAS.getSound(Sounds.MUSIC_LOOP_1).isPlaying)
			{
			if (SoundAS.getSound(Sounds.MUSIC_LOOP_2).isPlaying)
			playMusicLoop(1);
			}
			
		}
		


		
		//================================================o
		//------ Getters and Setters
		//================================================o			


		
	}

}