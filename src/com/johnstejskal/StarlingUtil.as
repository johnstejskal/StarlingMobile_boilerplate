package com.johnstejskal 
{
	import com.greensock.TweenLite;
	import data.AppData;
	import flash.events.TimerEvent;
	import flash.utils.clearInterval;
	import flash.utils.getQualifiedClassName;
	import flash.utils.setInterval;
	import flash.utils.Timer;
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.QuadBatch;
	import starling.display.Sprite;
	import view.components.screens.LoadingScreen;
	
	
	/**
	 * @author John Stejskal
	 * "Why walk when you can ride"
	 */
	
	public class StarlingUtil 
	{
		static public const CENTER:String = "CENTER";
		static public const BOTTOM_LEFT:String = "BOTTOM_LEFT";
		static public const BOTTOM_RIGHT:String = "BOTTOM_RIGHT";
		static public const TOP_LEFT:String = "TOP_LEFT";
		static public const TOP_RIGHT:String = "TOP_RIGHT";
		static public var flashInterval:uint;
		
		
		//static private var isLoadingActive:Boolean = false;
		
		public function StarlingUtil() 
		{
			
		}
		
		public static function getBoxWithBorder( ww:int, hh:int, plainColor:int = 0xFFFFFF, borderColor:int = 0x000000, borderThickness:int = 1):QuadBatch {
			// create batch
			var result : QuadBatch = new QuadBatch();
 
			// create plain color
			var center : Quad = new Quad(ww, hh, plainColor);
 
			// create borders
			var left : Quad = new Quad(borderThickness, hh, borderColor);
			var right : Quad = new Quad(borderThickness, hh, borderColor);
 
			var top : Quad = new Quad(ww, borderThickness, borderColor);
			var down : Quad = new Quad(ww, borderThickness, borderColor);
 
			// placing elements (top and left already placed)
			right.x = ww - borderThickness;
			down.y = hh - borderThickness;
 
			// build box
			result.addQuad(center);
			result.addQuad(left);
			result.addQuad(top);
			result.addQuad(right);
			result.addQuad(down);	
 
			return result;
		}		
		

		
		static public function centerRegPoint(obj:*):void 
		{
			obj.x -= obj.width / 2;
			obj.y -= obj.height / 2;
		}
		
		//--------------------------------------------o
		// Changes the registration point of a starling object
		// Modifies original object
		//--------------------------------------------o
		static public function setRegPoint(obj:Quad, pos:String = CENTER):void 
		{
			switch(pos)
			{
				case CENTER:
				obj.pivotX = obj.width / 2;
				obj.pivotY = obj.height / 2;
				break;
				
				case TOP_LEFT:
				obj.pivotX = 0;
				obj.pivotY = 0;
				break;	
				
				case TOP_RIGHT:
				obj.pivotX = obj.width;
				obj.pivotY = 0;
				break;	
				
				case BOTTOM_LEFT:
				obj.pivotX = 0;
				obj.pivotY = obj.height;
				break;	
				
				case BOTTOM_RIGHT:
				obj.pivotX = obj.width;
				obj.pivotY = obj.height;
				break;	
				
			}
		}
		
		//--------------------------------------------o
		// Changes an objects screen pos to on of sever preset positions
		// Modifies original object
		// does NOT change pivotX/ pivotY
		//--------------------------------------------o
		static public function setScreenPos(obj:Quad, pos:String = CENTER):void 
		{
			switch(pos)
			{
				case CENTER:
				obj.x = AppData.deviceResX / 2;
				obj.y = AppData.deviceResY / 2;
				break;
				
				case TOP_LEFT:
				obj.x = 0;
				obj.y = 0;
				break;	
				
				case TOP_RIGHT:
				obj.x = AppData.deviceResX;
				obj.y = 0;
				break;	
				
				case BOTTOM_LEFT:
				obj.x = 0;
				obj.y = AppData.deviceResY;
				break;	
				
				case BOTTOM_RIGHT:
				obj.x = AppData.deviceResX;
				obj.y = AppData.deviceResY;
				break;	
				
			}
		}
		
		
		
		//--------------------------------------------o
		// Changes the scale of an object,
		// used for matching device scale ratios
		// pass in Data.deviceScaleX/Y
		// Modifies original object
		//--------------------------------------------o		
		static public function setScale(obj:Quad, scale:Number):void 
		{
			obj.scaleX = obj.scaleY = scale
		}
		
		static public function shakeMC(degree:Number, time:Number):void 
		{
			//obj.scaleX = obj.scaleY = scale
		}
		
		static public function shakeScreen(degree:Number, time:Number):void 
		{
			//obj.scaleX = obj.scaleY = scale
		}
		public static function shake(shakeClip:*, duration:Number = 3000, frequency:Number = 30, distance:Number = 2):void
		{
			var shakes:int = duration / frequency;
			var shakeTimer:Timer = new Timer(frequency, shakes);
			var startX:Number = shakeClip.x;
			var startY:Number = shakeClip.y;

			var shakeUpdate:Function = function(e:TimerEvent):void
				{
					shakeClip.x = startX + ( -distance / 2 + Math.random() * distance);
					shakeClip.y = startY + ( -distance / 2 + Math.random() * distance); 
				}

			var shakeComplete:Function = function(e:TimerEvent):void
				{
					shakeClip.x = startX;
					shakeClip.y = startY;
					e.target.removeEventListener(TimerEvent.TIMER, shakeUpdate);
					e.target.removeEventListener(TimerEvent.TIMER_COMPLETE, shakeComplete);
				}

			shakeTimer.addEventListener(TimerEvent.TIMER, shakeUpdate);
			shakeTimer.addEventListener(TimerEvent.TIMER_COMPLETE, shakeComplete);

			shakeTimer.start();
		}		
		
		
		//-----------------------------------------------o
		//-------- Make an object flash
		//-----------------------------------------------o
		public static function makeObjectFlash(object:*, time:Number = 1, interval:Number = 500, finishVisible:Boolean = true):void
		{
			flashInterval = setInterval(flash, interval);

			TweenLite.delayedCall(time, function():void{  clearInterval(flashInterval);  object.visible = finishVisible; })
			
			function flash():void
			{
				if (object == null)
				return;
				
				if (!object.visible)
				object.visible = true;
				else
				object.visible = false;
			}
			
		}
		
		public static function stopFlashing(object:*, visible:Boolean = true ):void
		{
			clearInterval(flashInterval);
			object.visible = visible;
		}
		
	    public static function getStageItems( container:DisplayObjectContainer = null ):void
		{
			if ( !container ) container = Starling.current.stage;
				
			for ( var i:int = 0; i < container.numChildren; i++ )
			{
				if ( container.getChildAt(i) is DisplayObjectContainer )
				{
					getStageItems( container.getChildAt(i) as DisplayObjectContainer );
				}
				else
				{
					trace( "Item name: " + container.getChildAt(i).name );
					trace( "Item type: " + getQualifiedClassName( container.getChildAt(i) ) );
					trace( "-------------------------------------" );
				}
			}
		}	
				
	    public static function floorAllPositions( container:DisplayObjectContainer = null ):void
		{
			if ( !container ) container = Starling.current.stage;
				
			for ( var i:int = 0; i < container.numChildren; i++ )
			{
				if ( container.getChildAt(i) is DisplayObjectContainer )
				{
					   var newContainer:DisplayObjectContainer = container.getChildAt(i) as DisplayObjectContainer;
						for (var j:int = 0; j < newContainer.numChildren; j++) 
						{
							newContainer.getChildAt(j).x = Math.floor(newContainer.getChildAt(j).x);
							newContainer.getChildAt(j).y = Math.floor(newContainer.getChildAt(j).y);
							
						}
				}
				else
				{
						container.getChildAt(i).x = Math.floor(container.getChildAt(i).x);
						container.getChildAt(i).y = Math.floor(container.getChildAt(i).y);

				}
			}
		}	
		
		
		
		
	}

}