package com.thirdsense.animation 
{
	import com.thirdsense.sound.SoundStream;
	import com.thirdsense.utils.Trig;
	import starling.display.DisplayObject;
	
	/**
	 * A frame-based tweening engine based on the Starling time-based tween engine. The obvious difference being that this is processed on an
	 * EnterFrameEvent rather than timers. This class takes advantage of an asynchronus process which pauses the tween rather than jumping it 
	 * in the event of high cpu load or delays in passing texture data to the GPU.
	 * @author Ben Leffler
	 */
	
	public class BTween
	{
		private static var bTweeners:Vector.<BTween>;
		private static var counter:int = 0;
		
		private var _target:Object;
		private var frames:int;
		private var transition:String;
		private var animations:Array;
		private var frame_counter:int;
		private var transition_worker:Function;
		private var frame_pause:int;
		private var _paused:Boolean;
		private var _transition_progress:Number;
		
		/**
		 * Applies a linear transformation
		 */
		public static const LINEAR:String = "linear";
		
		/**
		 * Applies a gradual ease-out transformation
		 */
		public static const EASE_OUT:String = "easeOut";
		
		/**
		 * Applies a gradual ease-in transformation
		 */
		public static const EASE_IN:String = "easeIn";
		
		/**
		 * Applies an ease-out transformation for the first 50% of the tween duration, then a ease-in transformation for the remaining duration
		 */
		public static const EASE_OUT_IN:String = "easeOutIn";
		
		/**
		 * Applies an ease-in transformation for the first 50% of the tween duration, then a ease-out transformation for the remaining duration
		 */
		public static const EASE_IN_OUT:String = "easeInOut";
		
		/**
		 * Applies an ease-out transformation which then elasticises as it approaches the destination
		 */
		public static const EASE_OUT_ELASTIC:String = "easeOutElastic";
		
		/**
		 * Applies an elasticised transformation initially and transitions to an ease-in transformation as it approaches the destination
		 */
		public static const EASE_IN_ELASTIC:String = "easeInElastic";
		
		/**
		 * Applies an ease in-out overshot of the target value by 25% then an ease back to the target value
		 */
		public static const SINGLE_ELASTIC:String = "singleElastic";
		
		/**
		 * Applies a linear tween loop to continue until the tween is removed from the cue with the BTween.removeFromCue() call
		 */
		public static const LOOPS_FOREVER:String = "loopsForever";
		
		/**
		 * Applies an EASE_IN_OUT to a destination for the first half of the tween duration, then returns to the origin with the same ease.
		 */
		public static const EASE_IN_OUT_RETURN_TO_ORIGIN:String = "easeInOutReturnToOrigin";
		
		/**
		 * Applies an EASE_OUT to a destination for the first half of the tween duration, then returns to the origin with an EASE_IN tween. (Like a ball toss and catch)
		 */
		public static const EASE_OUT_IN_RETURN_TO_ORIGIN:String = "easeOutInReturnToOrigin";
		 
		/**
		 * Designates that the tween is to be of a custom type. Ensure that you call useCustomWorker() before starting the transition.
		 */
		public static const CUSTOM_TWEEN:String = "customTween";
		
		/**
		 * A function that is called upon the tween reaching it's completed phase
		 */
		public var onComplete:Function;
		
		/**
		 * An array of arguments to be applied to the onComplete function if it is called
		 */
		public var onCompleteArgs:Array;
		
		/**
		 * A function that is called upon the tween starting (will be called immediately if that pause value is 0)
		 */
		public var onStart:Function;
		
		/**
		 * An array of arguments to be applied to the onStart function if it is called
		 */
		public var onStartArgs:Array;
		
		/**
		 * A function that is called on each frame whilst a tweening transformation is occuring
		 */
		public var onTween:Function;
		
		/**
		 * An array of arguments to be applied to the onTween function if it is called
		 */
		public var onTweenArgs:Array;
		
		/**
		 * The number of times a tween will loop for. (Default is 0) To loop infinitely, set this value to -1 or set a tween transition to BTween.LOOPS_FOREVER
		 */
		public var loops:int;
		
		/**
		 * Creates a new frame-based (as opposed to timer based) Tween instance
		 * @param	target	The target object to tween properties of
		 * @param	frames	The number of frames to tween over. A minimum value of 2 is applicable (covering the initial state and end state frames)
		 * @param	transition	The type of transition shape to apply to the tween (eg. BTween.LINEAR, BTween.EASE_OUT etc.)
		 * @param	pause	The number of frames to pause before commencing the tween
		 */
		
		public function BTween( target:Object, frames:int, transition:String="linear", pause:int=0 ) 
		{
			this._target = target;
			this.frames = Math.max( frames, 2 );
			this.transition = transition;
			this.frame_pause = pause;
			this.frame_counter = 0;
			if ( transition != BTween.CUSTOM_TWEEN )
			{
				this.transition_worker = this[transition];
			}
			this.loops = 0;
			
		}
		
		/**
		 * If a tween is to utilise a custom transition worker, pass it through in this call BEFORE calling start() on the tween object.
		 * @param	worker	The worker function that is invoked on each frame of a tween, controlling the percentage of the target value to place an object at.
		 * The worker must accept a number argument (value between 0 and 1) which indicates how far in to a tween the object is.
		 * The worker must also return a number value which indicates the percentage of the target value to place the target object at.
		 */
		
		public function useCustomWorker( worker:Function ):void
		{
			this.transition_worker = worker;
		}
		
		/**
		 * Adds a property to the animation cue for a tween
		 * @param	property	The name of the property to alter
		 * @param	targetValue	The target value of the property
		 */
		
		public function animate( property:String, targetValue:Number ):void
		{
			if ( !this.animations ) {
				this.animations = [];
			}
			
			if ( this._target[property] != targetValue ) {
				this.animations.push( { 
					property:property,
					defaultValue:this._target[property],
					targetValue:targetValue
				} );
			}
		}
		
		/**
		 * Retrieves a tweens target value for a specified property
		 * @param	property	The property being tweened
		 * @return	The target value of the property in a tween. If a specific property isn't being tweened, NaN is returned
		 */
		
		public function getTargetValue( property:String ):Number
		{
			if ( this.animations )
			{
				for ( var i:uint = 0; i < this.animations.length; i++ )
				{
					if ( this.animations[i].property == property )
					{
						return this.animations[i].targetValue;
					}
				}
			}
			
			return parseInt("NaN");
		}
		
		/**
		 * Retrieves a tweens original value for a specified property
		 * @param	property	The property being tweened
		 * @return	The original value of the property in a tween. If a specific property isn't being tweened, NaN is returned
		 */
		
		public function getOriginalValue( property:String ):Number
		{
			if ( this.animations )
			{
				for ( var i:uint = 0; i < this.animations.length; i++ )
				{
					if ( this.animations[i].property == property )
					{
						return this.animations[i].defaultValue;
					}
				}
			}
			
			return parseInt("NaN");
		}
		
		/**
		 * Adds an x and y tween property to the animation cue
		 * @param	x	The desired x value
		 * @param	y	The desired y value
		 */
		public function moveTo( x:Number, y:Number ):void
		{
			this.animate( "x", x );
			this.animate( "y", y );
		}
		
		/**
		 * Moves the target to the designated point, and adds an x/y tween to the animation cue
		 * @param	from_x	The x co-ord to move the target from
		 * @param	from_y	The y co-ord to move the target from
		 * @param	dest_x	The x point to tween to
		 * @param	dest_y	The y point to tween to
		 * @param	applyNow	Should the initial translation be applied upon this call, pass as true
		 */
		
		public function moveFromTo( from_x:Number, from_y:Number, dest_x:Number, dest_y:Number, applyNow:Boolean=true ):void
		{
			var ox:Number = this._target["x"];
			var oy:Number = this._target["y"];
			
			this._target["x"] = from_x;
			this._target["y"] = from_y;
			this.moveTo( dest_x, dest_y );
			
			if ( !applyNow )
			{
				this._target["x"] = ox;
				this._target["y"] = oy;
			}
		}
		
		/**
		 * Moves the target from a designated point to it's current point
		 * @param	from_x	The x co-ord to move the target from
		 * @param	from_y	The y co-ord to move the target from
		 * @param	applyNow	Pass as true to apply the initial traslation immediately.
		 */
		
		public function moveFrom( from_x:Number, from_y:Number, applyNow:Boolean = true ):void
		{
			this.moveFromTo( from_x, from_y, this._target.x, this._target.y, applyNow );
		}
		
		/**
		 * Adds a scaleX and scaleY property to the animation cue
		 * @param	scale	The value to scale the object to.
		 */		
		public function scaleTo( scale:Number ):void
		{
			this.animate( "scaleX", scale );
			this.animate( "scaleY", scale );
		}
		
		/**
		 * Adds a scale property to the animation cue from an initial state. Assumes that scaleX and scaleY values are the same.
		 * @param	start_scale	The start scale of the target
		 * @param	end_scale	The end scale of the target
		 * @param	applyNow	Should the start scale be immediately applied, pass as true
		 */
		
		public function scaleFromTo( start_scale:Number, end_scale:Number, applyNow:Boolean = true ):void
		{
			var oscalex:Number = this._target["scaleX"];
			var oscaley:Number = this._target["scaleY"];
			
			this._target["scaleX"] = start_scale;
			this._target["scaleY"] = start_scale;
			this.scaleTo( end_scale );
			
			if ( !applyNow )
			{
				this._target["scaleX"] = oscalex;
				this._target["scaleY"] = oscaley;
			}
		}
		
		/**
		 * Adds a scale transformation to the tween from the passed value to the targets current one
		 * @param	start_scale	The scale value to start the transformation tween from
		 * @param	applyNow	Should the start scale be immediately applied, pass as true
		 */
		
		public function scaleFrom( start_scale:Number, applyNow:Boolean = true ):void
		{
			this.scaleFromTo( start_scale, this._target.scaleX, applyNow );
		}
		
		/**
		 * Adds a rotation property to the animation cue
		 * @param	value	The value to rotate the object to
		 */
		
		public function rotateTo( value:Number ):void
		{
			this.animate( "rotation", value );
		}
		
		/**
		 * Adds a rotation property to the animation cue, from the designated value
		 * @param	start_value	The initial rotation of the target object
		 * @param	end_value	The final rotation of the target object
		 * @param	applyNow	Should the target object immediately adopt the initial rotation, pass this as true
		 */
		
		public function rotateFromTo( start_value:Number, end_value:Number, applyNow:Boolean=true ):void
		{
			var orot:Number = this._target["rotation"];
			this._target["rotation"] = start_value;
			this.rotateTo( end_value );
			
			if ( !applyNow )
			{
				this._target["rotation"] = orot;
			}
		}
		
		/**
		 * Adds a rotation transformation to the tween from the passed value to the targets current one
		 * @param	start_value	The rotation value to start the transformation tween from
		 * @param	applyNow	Should the start rotation be immediately applied, pass as true
		 */
		
		public function rotateFrom( start_value:Number, applyNow:Boolean = true ):void
		{
			this.rotateFromTo( start_value, this._target.rotation, applyNow );
		}
		
		/**
		 * Adds an alpha fade to the the animation cue
		 * @param	alpha	The desired alpha value
		 */
		
		public function fadeTo( alpha:Number ):void
		{
			this.animate( "alpha", alpha );
			
		}
		
		/**
		 * Fades an object's alpha between a start and an end value
		 * @param	start_value	The start value of the object alpha
		 * @param	end_value	The destination value of the object alpha
		 * @param	applyNow	Pass as true if the start_value is to be applied immediately
		 */
		
		public function fadeFromTo( start_value:Number = 0, end_value:Number = 1, applyNow:Boolean = true ):void
		{
			var oalpha:Number = this._target["alpha"];
			this._target["alpha"] = start_value;
			this.fadeTo( end_value );
			
			if ( !applyNow )
			{
				this._target["alpha"] = oalpha;
			}
		}
		
		/**
		 * Adds an alpha transformation to the tween from the passed value to the targets current one
		 * @param	start_alpha	The scale alpha to start the transformation tween from
		 * @param	applyNow	Should the start alpha be immediately applied, pass as true
		 */
		
		public function fadeFrom( start_alpha:Number, applyNow:Boolean = true ):void
		{
			this.fadeFromTo( start_alpha, this._target.alpha, applyNow );
		}
		
		/**
		 * Starts the tween
		 */
		
		public function start():void
		{
			addToCue(this);
			
		}
		
		/**
		 * Stops the tween
		 */
		
		public function stop():void
		{
			removeFromCue(this);
			
		}
		
		/**
		 * Retrieves the progress of the tween represented by a number between 0 and 1. If a tween is in a pre-tween paused state, 0 will be returned.
		 */
		
		public function get progress():Number
		{
			return ( this.frame_counter / this.frames );
		}
		
		/**
		 * @private
		 * @return	A boolean value indicating if the tween has reached it's final frame
		 */
		
		private function timeline():Boolean
		{
			if ( this._paused )	return false;
			
			if ( !this.frame_pause && this.progress == 0 && this.target is DisplayObject )
			{
				if ( !counter )
				{
					SoundStream.play( "woosh" + Math.ceil(Math.random() * 3) + ".mp3", Math.random() * 0.15 + 0.1 );
				}
				counter ? counter = 0 : counter = 1;
			}
			
			var finished:Boolean = false;
			
			if ( this.frame_pause > 0 ) {
				this.frame_pause--;
				if ( !this.frame_pause && this.onStart != null )
				{
					var fn:Function = this.onStart;
					this.onStart = null;
					if ( !this.onStartArgs )
					{
						fn();
					}
					else
					{
						var arr:Array = this.onStartArgs;
						this.onStartArgs = null;
						fn.apply( null, arr );
					}
				}
			} else {
				finished = this.makeMove();
				if ( !finished && this.onTween != null )
				{
					if ( !this.onTweenArgs )
					{
						this.onTween();
					}
					else
					{
						this.onTween.apply( null, this.onTweenArgs );
					}
					
				}
				else
				{
					this.onTween = null;
					this.onTweenArgs = null;
				}
			}
			
			return finished;
		}
		
		/**
		 * @private
		 * @return	A boolean value indicating if the tween has reached it's final frame
		 */
		
		private function makeMove():Boolean
		{
			var perc:Number;
			var animation:Object;
			var i:uint
			var length:int;
			var fn:Function;
			
			this.frame_counter++;
			perc = ( this.frame_counter / this.frames );
			length = this.animations.length;
			
			for ( i = 0; i < length; i++ ) {
				
				animation = this.animations[i];
				
				if ( perc > 1 ) {	// Tween completed
					
					//this._target[ animation.property ] = animation.targetValue;
					this._target[ animation.property ] = ( this.transition_worker(1) * (animation.targetValue - animation.defaultValue) ) + animation.defaultValue;
					this.frame_counter = 0;
					
					if ( this.loops > 0 )
					{
						this.loops--;
					}
					else if ( this.loops == 0 )
					{
						this.stop();
					
						if ( this.onComplete != null ) {
							fn = this.onComplete;
							this.onComplete = null;
							onCompleteArgs ? fn.apply( null, onCompleteArgs ) : fn();
						}
						
						return true;
					}
					
				} else {	// Tween continues
					
					this._transition_progress = this.transition_worker(perc);
					this._target[ animation.property ] = ( this._transition_progress * (animation.targetValue - animation.defaultValue) ) + animation.defaultValue;
					
				}
				
			}
			
			if ( !length ) {
				this.stop();
				
				if ( this.onComplete != null ) {
					fn = this.onComplete;
					this.onComplete = null;
					onCompleteArgs ? fn.apply( null, onCompleteArgs ) : fn();
				}
			}
			
			return false;
			
		}
		
		/**
		 * @private
		 */
		
		private function linear( ratio:Number ):Number
		{
			return ratio;
			
		}
		
		/**
		 * @private
		 */
		
		private function loopsForever( ratio:Number ):Number
		{
			if ( this.loops >= 0 ) this.loops = -1;
			return linear( ratio );
		}
		
		/**
		 * @private
		 */
		
		private function easeOut( ratio:Number ):Number
		{
			var invRatio:Number = ratio - 1.0;
            return -Math.abs(Math.pow( invRatio, 2 )) + 1;
			
		}
		
		/**
		 * @private
		 */
		
		private function easeIn( ratio:Number ):Number
		{
			return Math.pow( ratio, 2 );
			
		}
		
		/**
		 * @private
		 */
		
		private function easeOutIn( ratio:Number ):Number
		{
			return easeCombined( this.easeOut, this.easeIn, ratio);
			
		}
		
		/**
		 * @private
		 */
		
		private function easeInOut( ratio:Number ):Number
		{
			return easeCombined( this.easeIn, this.easeOut, ratio);
			
		}
		
		/**
		 * @private
		 */
		
		private function easeOutElastic(ratio:Number):Number
        {
            if (ratio == 0 || ratio == 1) {
				return ratio;
			} else {
                var p:Number = 0.3;
                var s:Number = p/4.0;                
                return Math.pow(2.0, -10.0 * ratio) * Math.sin((ratio - s) * (2.0 * Math.PI) / p) + 1;
            }            
        }
		
		/**
		 * @private
		 */
		
		private function easeInElastic(ratio:Number):Number
		{
			if (ratio == 0 || ratio == 1) 
			{
				return ratio;
			}
            else
            {
                var p:Number = 0.3;
                var s:Number = p/4.0;
                var invRatio:Number = ratio - 1;
                return -1.0 * Math.pow(2.0, 10.0*invRatio) * Math.sin((invRatio-s)*(2.0*Math.PI)/p);                
            }
		}
		
		/**
		 * @private
		 */
		
		private function easeInOutReturnToOrigin( ratio:Number ):Number
		{
			if ( ratio <= 0.5 )
			{
				return easeInOut( ratio * 2 );
			}
			else
			{
				return easeInOut( 1 - ((ratio - 0.5) * 2) );
			}
		}
		
		/**
		 * @private
		 */
		
		private function easeOutInReturnToOrigin( ratio:Number ):Number
		{
			if ( ratio <= 0.5 )
			{
				return easeOut( ratio * 2 );
			}
			else
			{
				return easeIn( 1 - ((ratio - 0.5) * 2) );
			}
		}
		
		/**
		 * @private
		 */
		
		private function singleElastic(ratio:Number):Number
		{
			if (ratio == 0 || ratio == 1) 
			{
				return ratio;
			}
            else
            {
				const peak:Number = 0.65;
				const max:Number = 1.5;
				
                if ( ratio < peak )
				{
					var p:Number = this.easeOut( ratio / peak ) * max;
					return p;
				}
				else
				{
					p = this.easeIn( (ratio - peak) / (1-peak) ) * (max - 1);
					return max - p;
				}
            }
		}
		
		/**
		 * Retrieves a specific tween worker from this class (for use with custom tweens)
		 * @param	name	The name of the tween worker to retrieve (eg. BTween.EASE_IN)
		 * @return	The function that is used as a worker for a tween within this class.
		 */
		
		public function getWorker( name:String ):Function
		{
			return this[name] as Function;
			
		}
		
		/**
		 * @private
		 */
		
		private function easeCombined(startFunc:Function, endFunc:Function, ratio:Number):Number
        {
            if (ratio < 0.5) {
				return 0.5 * startFunc( ratio*2.0 );
			} else {
				return 0.5 * endFunc( (ratio - 0.5) * 2.0 ) + 0.5;
			}
			
        }
		
		/**
		 * The target object this tween instance applies to
		 */
		
		public function get target():Object
		{
			return this._target;
		}
		
		public function set target( obj:Object )
		{
			this._target = obj;
		}
		
		/**
		 * Returns a boolean value indicating if the tween is in a state of pause
		 */
		
		public function get paused():Boolean 
		{
			return _paused;
		}
		
		/**
		 * Returns the actual progress position of the transition relative to it's origin (Instead of being a value between 0 and 1, the value can exist outside these limits depending on the tween type chosen eg.ELASTIC)
		 */
		
		public function get transition_progress():Number 
		{
			return _transition_progress;
		}
		
		/**
		 * Pauses the tween in it's current place
		 */
		
		public function pause():void
		{
			this._paused = true;
		}
		
		/**
		 * Resumes a tween that has been paused
		 */
		
		public function resume():void
		{
			this._paused = false;
		}
		
		/**
		 * Controls the tweening process on any BTween objects in the static application tweening cue. (In a LaunchPad framework, this is handled by the LaunchPad core)
		 */
		
		public static function processCue():void
		{
			if ( !bTweeners ) {
				return void;
			}
			
			var i:uint;
			var btweener:BTween;
			
			for ( i = 0; i < bTweeners.length; i++ ) {
				
				btweener = bTweeners[i] as BTween;
				if ( btweener.timeline() ) {
					i--;
				}
			}
		}
		
		/**
		 * Checks if a tween exists in the current tween cue
		 * @param	target	The BTween object to check for
		 * @return	An integer value of the index in the tween cue of where the BTween object exists. A value of -1 will be returned if the tween is not in the cue.
		 */
		
		public static function existsInCue( target:BTween ):int
		{
			if ( !bTweeners ) {
				return -1;
			}
			
			var length:int = bTweeners.length;
			var i:uint;
			
			for ( i = 0; i < length; i++ ) {
				if ( bTweeners[i] == target ) {
					return i;
				}
			}
			
			return -1;
			
		}
		
		/**
		 * Checks if an object exists in the current BTween cue
		 * @param	target	The target to check against
		 * @return	True if the object has a value being tweened. False otherwise
		 */
		
		public static function targetExistsInCue( target:Object ):Boolean
		{
			if ( !bTweeners ) return false;
			
			var len:int = bTweeners.length;
			var i:uint;
			
			for ( i = 0; i < len; i++ )
			{
				if ( bTweeners[i].target == target ) return true;
			}
			
			return false;
		}
		
		/**
		 * Adds a BTween object to the cue if it doesn't already exist in cue
		 * @param	target	The BTween object to add
		 */
		
		private static function addToCue( target:BTween ):void
		{
			if ( !bTweeners ) {
				bTweeners = new Vector.<BTween>;
			}
			
			if ( existsInCue(target) == -1 ) {
				bTweeners.push( target );
			}
			
		}
		
		/**
		 * If a BTween object exists in the cue, this function removes it
		 * @param	target	The BTween object to remove from the cue
		 */
		
		public static function removeFromCue( target:BTween ):void
		{
			if ( !bTweeners ) {
				return void;
			}
			
			var length:int = bTweeners.length;
			var i:uint;
			
			var place:int = existsInCue(target);
			if ( place >= 0 ) {
				bTweeners.splice(place, 1);
			}
			
		}
		
		/**
		 * Removes from the tweening cue all currently active tweens associated with a target
		 * @param	target	The object that is being tweened that requires removal
		 */
		
		public static function removeTargetFromCue( target:Object ):void
		{
			if ( !bTweeners ) return void;
			
			var length:int = bTweeners.length;
			var i:uint;
			
			for ( i = 0; i < length; i++ )
			{
				if ( bTweeners[i]._target == target )
				{
					bTweeners.splice(i, 1);
					i--;
					length--;
				}
			}
		}
		
		/**
		 * Retrieves all running tweens that are associated with a specified object
		 * @param	target	The target object
		 * @return	Vector of BTween objects associated with the target. The vector will be empty if no running tweens are found.
		 */
		
		public static function getAllTargetTweens( target:Object ):Vector.<BTween>
		{
			var vec:Vector.<BTween> = new Vector.<BTween>;
			
			if ( !bTweeners ) return vec;
			
			var length:int = bTweeners.length;
			var i:uint;
			
			for ( i = 0; i < length; i++ )
			{
				if ( bTweeners[i]._target == target )
				{
					vec.push( bTweeners[i] );
				}
			}
			
			return vec;
			
		}
		
		/**
		 * Removes and purges all tweens currently in the engine cue
		 */
		
		public static function killCue():void 
		{
			if ( bTweeners )
			{
				var val:int = bTweeners.length;
			}
			else
			{
				val = 0;
			}
			
			bTweeners = new Vector.<BTween>;
			
			trace( "BTween.killCue executed. " + val + " tweens disposed." );
			
		}
		
		/**
		 * Executes a function (with optional arguments) on the next frame.
		 * @param	fn	The function to call on the next frame
		 * @param	fnArgs	(Optional) arguments to feed through to the function when it is called
		 */
		
		public static function callOnNextFrame( fn:Function, fnArgs:Array=null ):void
		{
			var tween:BTween = new BTween( { tick:0 }, 2 );
			tween.animate( "tick", 1 );
			tween.onComplete = fn;
			if ( fnArgs ) tween.onCompleteArgs = fnArgs;
			tween.start();
		}
		
		/**
		 * Executes a function (with optional arguments) at a designated number of frames down the timeline
		 * @param	frames	The number of frames to pause before executing a function
		 * @param	fn	The function to call
		 * @param	fnArgs	(Optional) arguments to feed through to the function when it is called
		 */
		
		public static function callOnFrame( frames:int, fn:Function, fnArgs:Array = null ):BTween
		{
			var tween:BTween = new BTween( { tick:0 }, frames + 1 );
			tween.animate( "tick", 1 );
			tween.onComplete = fn;
			if ( fnArgs ) tween.onCompleteArgs = fnArgs;
			tween.start();
			
			return tween;
		}
		
	}

}