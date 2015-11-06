package com.thirdsense.ui.starling 
{
	import com.thirdsense.animation.BTween;
	import com.thirdsense.animation.TexturePack;
	import com.thirdsense.settings.LPSettings;
	import com.thirdsense.sound.SoundStream;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.setTimeout;
	import starling.display.MovieClip;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	/**
	 * Creates a button from a TexturePack object
	 * @author Ben Leffler
	 */
	
	public dynamic class LPsButton extends MovieClip 
	{
		private var _source_width:Number;
		private var _source_height:Number;
		private var _delayOnState:Boolean;
		private var _delayTimeStamp:Number;
		private var onRelease:Function;
		private var disabled:Boolean;
		
		private static var clickSound:String;
		private static var sound:Sound;
		
		/**
		 * The local tween instance that can be used for transitions and animation of this button
		 */
		public var tween:BTween;
		
		/**
		 * This function is called (if not null) when this button has been disabled by the disable() function
		 */
		public var onDisable:Function;
		
		/**
		 * This function is called (if not null) when this button has been enabled by the enable() function
		 */
		public var onEnable:Function;
		
		/**
		 * If a click sound has been designated and you want to mute this particular button instance, set as true.
		 * @default	false
		 */
		public var mute:Boolean;
		
		/**
		 * Overrides the static set click sound with the filename passed in this parameter
		 */
		public var click_sound:String;
		
		/**
		 * The width of the source DisplayObject that was turned in to this button instance (not the width of the texture being used)
		 */
		public function get source_width():Number {	return this.scaleX * this._source_width	};
		
		/**
		 * The height of the source DisplayObject that was turned in to this button instance (not the height of the texture being used)
		 */
		public function get source_height():Number { return this.scaleY * this._source_height };
		
		public function get isDisabled():Boolean { return this.disabled };
		
		/**
		 * When set to true, the button's "on" state is delayed by a short amount of time before being visually triggered.
		 */
		public function get delayOnState():Boolean { return _delayOnState };		
		public function set delayOnState(value:Boolean):void 
		{
			_delayOnState = value;
		}
		
		/**
		 * Fires when a touch is detected on the button. This fires concurrently to the onRelease variable passed in the constructor and is not
		 * restricted by button bounds.
		 */
		public var onTouch:Function;
		
		/**
		 * Constructs a custom starling button from a TexturePack
		 * @param	tp	The TexturePack object to generate the button from
		 * @param	onRelease	If a click on the button is detected, call this function. Must accept a touch object as it's argument
		 * @param	helper_sequence	If a helper was used to create the texture pack, pass the desired sequence name here
		 * @see starling.events.Touch
		 */
		
		public function LPsButton( tp:TexturePack, onRelease:Function, helper_sequence:String="" ) 
		{
			this.onRelease = onRelease;
			
			super( tp.getTextures(helper_sequence) );
			
			
			if ( helper_sequence.length )
			{
				this.name = tp.pool + "_" + helper_sequence;
			}
			else
			{
				this.name = tp.pool + "_" + tp.sequence;
			}
			
			var pt:Point = tp.getOffset( helper_sequence );
			this.pivotX = -pt.x;
			this.pivotY = -pt.y;
			
			this.addListeners();
			this.currentFrame = 0;
			
			this._source_width = tp.source_width;
			this._source_height = tp.source_height;
			
			this.disabled = false;
			this.useHandCursor = true;
			this.mute = false;
			this.click_sound = "";
			this._delayOnState = false;
			this._delayTimeStamp = 0;
		}
		
		public function shiftPivot( xpos:Number, ypos:Number ):void
		{
			var tx:Number = xpos - this.pivotX;
			var ty:Number = ypos - this.pivotY;
			
			this.pivotX = xpos;
			this.pivotY = ypos;
			
			this.x += tx;
			this.y += ty;
		}
		
		/**
		 * Disables the button.
		 * @param	fade_button	Multiplies the button's alpha value by 0.25 if passed as true
		 */
		
		public function disable( fade_button:Boolean=false ):void
		{
			if ( this.disabled ) return void;
			
			this.disabled = true;
			this._delayTimeStamp = 0;
			
			if ( fade_button )
			{
				this.alpha *= 0.25;
			}
			
			if ( this.onDisable != null )
			{
				this.onDisable();
			}
			
		}
		
		/**
		 * Returns the x,y co-ords of the button in a point format
		 * @return
		 */
		
		public function getPoint():Point
		{
			return new Point(this.x, this.y);
		}
		
		/**
		 * Enables a button if previously disabled and turns it fully visable or multiplies it's alpha by 4 (whatever is less in value)
		 */
		
		public function enable():void
		{
			if ( this.disabled ) {
				this.disabled = false;
				this.alpha = Math.min( 1, this.alpha * 4 );
				this.currentFrame = 0;
				if ( this.onEnable != null )
				{
					this.onEnable();
				}
			}
			
		}
		
		/**
		 * @private	Adds the listeners necessary for this to become a button
		 */
		
		private function addListeners():void
		{
			this.addEventListener( TouchEvent.TOUCH, this.touchHandler );
			this.addEventListener( Event.REMOVED_FROM_STAGE, this.removeHandler );
			
		}
		
		public final function triggerTouch():void
		{
			if ( this.onRelease != null && !this.disabled )
			{
				var touch:Touch = new Touch(0);
				touch.target = this;
				touch.phase = TouchPhase.ENDED;
				this.onRelease( touch );
			}
		}
		
		private function controlSound():void
		{
			// local referenced click sound will override the static app-wide click sound and will play as a SoundStream.
			var filename:String = this.click_sound;
			if ( filename && filename.length && !this.mute )
			{
				SoundStream.play( filename, Math.random() * 0.5 + 0.5 );
			}
			else if ( sound )
			{
				// But if no local referenced click sound is declared, use the static referenced (and cached instead of streaming) sound 
				var vol:Number = SoundStream.sound_volume;
				if ( vol > 0 )
				{
					var st:SoundTransform = new SoundTransform( vol * (Math.random() * 0.5 + 0.5) );
					sound.play( 0, 0, st );
				}
			}
		}
		
		/**
		 * @private	Handler for the TouchEvent listener
		 */
		
		private function touchHandler( evt:TouchEvent ):void
		{
			if ( this.disabled ) {
				return void;
			}
			
			var touches:Vector.<Touch> = evt.getTouches(this);
			
			for ( var i:uint = 0; i < touches.length; i++ ) {
				var touch:Touch = touches[i];
				if ( touch ) {
					
					switch ( touch.phase ) {
						
						case TouchPhase.BEGAN:
							if ( this.currentFrame != 1 && this.numFrames > 1 ) {
								if ( _delayOnState )
								{
									this._delayTimeStamp = new Date().getTime() + 150;
									setTimeout( setOnState, 150 );
								}
								else
								{
									this.currentFrame = 1;
								}
							}
							break;
						
						case TouchPhase.ENDED:
							if ( this.currentFrame || this.numFrames <= 1 || _delayOnState ) {
								_delayTimeStamp = 0;
								this.currentFrame = 0;
								var bounds:Rectangle = this.getBounds(this.parent);
								var pt:Point = touch.getLocation(this.parent);
								if ( bounds.containsPoint(pt) && this.onRelease != null )
								{
									this.controlSound();
									this.onRelease( touch );
								}
							}
							
							break;
							
						case TouchPhase.MOVED:
							pt = touch.getLocation(this.parent);
							if ( !this.getBounds(this.parent).containsPoint(pt) ) {
								if ( this.currentFrame ) {
									this.currentFrame = 0;
									_delayTimeStamp = 0;
								}
							} else {
								if ( this.currentFrame != 1  && this.numFrames > 1 ) {
									if ( _delayOnState )
									{
										if ( new Date().getTime() >= _delayTimeStamp )
										{
											_delayTimeStamp = 0;
											currentFrame = 1;
										}
									}
									else
									{
										this.currentFrame = 1;
									}
								}
							}
							break;
							
					}
					
					if ( this.onTouch != null )
					{
						if ( this.onTouch.length ) this.onTouch(touch);
						else this.onTouch();
					}
					
				}
			}
			
		}
		
		private function setOnState():void 
		{
			if ( _delayTimeStamp > 0 )
			{
				currentFrame = 1;
			}
		}
		
		/**
		 * @private	Removes listeners from memory upon the removal of this button from the stage
		 */
		
		private function removeHandler( evt:Event ):void
		{
			if ( evt.type == Event.REMOVED_FROM_STAGE ) {
				this.removeEventListener( Event.REMOVED_FROM_STAGE, this.removeHandler );
				this.removeEventListener( TouchEvent.TOUCH, this.touchHandler );
			}
			
		}
		
		public static function setClickSound( filename:String = "" ):void
		{
			LPsButton.clickSound = filename;
			
			if ( filename.length )
			{
				var url_request:URLRequest = new URLRequest( LPSettings.LIVE_EXTENSION + SoundStream.sound_path + filename );
				LPsButton.sound = new Sound( url_request );
			}
			else
			{
				LPsButton.sound = null;
			}
		}
		
		public static function getClickSound():String
		{
			return LPsButton.clickSound;
		}
		
	}

}