package view.components.gameobjects 
{


	import com.greensock.TweenLite;
	import com.johnstejskal.ArrayUtil;
	import com.johnstejskal.Delegate;
	import ManagerClasses.AssetsManager;
	import org.gestouch.events.GestureEvent;
	import org.gestouch.gestures.SwipeGesture;
	import singleton.Core;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.deg2rad;
	import vo.Constants;
	import vo.Data;
	/**
	 * ...
	 * @author John Stejskal
	 * www.johnstejskal.com
	 * johnstejskal@gmail.com
	 */
	public class Car extends Sprite
	{
/*		static public const COLOUR_BLUE:String = "Blue";
		static public const COLOUR_RED:String = "Red";
		static public const COLOUR_YELLOW:String = "Yellow";
		static public const COLOUR_GREEN:String = "Green";
		static public const COLOUR_RANDOM:String = "random";
		*/
		static public const DIRECTION_LEFT:String = "directionLeft";
		static public const DIRECTION_UP:String = "directionUp";
		static public const DIRECTION_DOWN:String = "directionDown";
		static public const DIRECTION_RIGHT:String = "directionRight";
		
		private var _sourceDirection:String;
		
		private var _collisionArea:Image;
		
		//images
		private var _imgCar:Image;
		
		//mc's
		
		private var _core:Core;
		private var _speed:Number;
		private var _speedSlow:int = .5;
		private var _speedNormal:Number = 1.5;
		private var _speedBoost:int = 5;
		
		private var _currRotation:Number;
		
		private var _nextDirection:String;
		private var _currDirection:String;
		private var _turnIntention:String = "";
		
		
		private var _currMapPos:String;
		private var _isTurning:Boolean = false;
		private var _arrColours:Array;
		private var _currDoorColour:String;
		private var _currColour:String;
		private var _quFill:Quad;
		private var _smcBlinkerR:MovieClip;
		private var _smcBlinkerL:MovieClip;
		
		//-----------------------------o
		//-- Constructor
		//-----------------------------o
		public function Car(colour:String) 
		{
			trace(this + "Constructed");
			_core = Core.getInstance();
			
			
			if (colour == Constants.COLOUR_RANDOM)
			{
			_arrColours = new Array(Constants.COLOUR_BLUE, Constants.COLOUR_RED, Constants.COLOUR_YELLOW, Constants.COLOUR_GREEN)
			ArrayUtil.shuffleArray(_arrColours)
			trace("_arrColours :" + _arrColours);
			colour = _arrColours[0];
		   
			}
			 _currColour = colour;
			
			if (stage) init(null);
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
			
			
			//_imgCar = new Image(Assets.getAtlas(Assets.SPRITE_ATLAS_ACTION_ASSETS).getTexture("TA_car"+colour+"0000"));
			_imgCar = new Image(AssetsManager.getAtlas(AssetsManager.SPRITE_ATLAS_ACTION_ASSETS).getTexture("TA_car_"+colour+"0000"));
			_imgCar.x = -_imgCar.width / 2;
			_imgCar.y = -_imgCar.height / 2;
			this.addChild(_imgCar);
			_imgCar.visible = true;
			
			_quFill = new Quad(_imgCar.width + 40, _imgCar.height + 40, 0x000000);
			_quFill.alpha = 0;
			_quFill.x = -_quFill.width / 2;
			_quFill.y = -_quFill.height / 2;
			addChild(_quFill);
			
			_smcBlinkerR = new MovieClip(AssetsManager.getAtlas(AssetsManager.SPRITE_ATLAS_ACTION_ASSETS).getTextures("TA_blinker"), 12);
			_smcBlinkerR.pause();
			_smcBlinkerR.loop = true;
			_smcBlinkerR.x = -50;
			_smcBlinkerR.y = -20;
			_core.animationJuggler.add(_smcBlinkerR)
			addChild(_smcBlinkerR);
					
			_smcBlinkerL = new MovieClip(AssetsManager.getAtlas(AssetsManager.SPRITE_ATLAS_ACTION_ASSETS).getTextures("TA_blinker"), 12);
			_smcBlinkerL.pause();
			_smcBlinkerL.loop = true;
			_smcBlinkerL.x = -50;
			_smcBlinkerL.y = 11;
			_core.animationJuggler.add(_smcBlinkerL)
			addChild(_smcBlinkerL);
		
			//_collisionArea = new Image(Assets.getAtlas(Assets.SPRITE_ATLAS_CHARACTER).getTexture("TA_collisionBox0000"));
		
		}
		
		private function init(e:Event):void 
		{
			trace(this + "inited");
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			_currDirection = DIRECTION_UP;
			changeDirection([_currDirection])
			
			this.addEventListener(Event.ENTER_FRAME, onUpdate)
			//this.addEventListener(TouchEvent.TOUCH, onTouch);
			
			var swipe:SwipeGesture = new SwipeGesture(this);
			swipe.addEventListener(GestureEvent.GESTURE_RECOGNIZED, onSwipeRec);
			
			_speed = _speedNormal;
		}
		

		
		private function onUpdate(e:Event):void 
		{
			checkMapPos();

			switch(_currDirection)
			{
				case DIRECTION_LEFT:
						this.x -= _speed;
				break;
				
				case DIRECTION_RIGHT:
					this.x += _speed;
				break;	
			
				case DIRECTION_UP:
					this.y -= _speed;
				break;				
				
				case DIRECTION_DOWN:
					this.y += _speed;
				break;			
			}
			
		}
		
		private function checkMapPos():void 
		{
			var colWidth:Number = 73//(1024) / Data.cols;
			var rowHeight:Number = 69//(768) / Data.rows;
			
			var countX:Number = Constants.MARGIN_LEFT// 0;
			var colPos:int = 0;
						
			var countY:Number = Constants.MARGIN_TOP;// 0;
			var rowPos:int = 0;
			
			var turnXpos:Number
			var turnYpos:Number;
			
			loop: for (var i:int = 0; i <= Data.cols; i++) 
			{
				countX += colWidth;
				if (this.x < countX)
				{
				colPos = i;
				break loop;
				}
				
			}
			
			if(_currDirection == DIRECTION_LEFT)
			turnXpos = ((colPos + 1) * colWidth) - (colWidth / 2)+ Constants.MARGIN_LEFT
			if(_currDirection == DIRECTION_RIGHT)
			turnXpos = ((colPos) * colWidth) + (colWidth / 2) + Constants.MARGIN_LEFT
			
			loop2: for (var j:int = 0; j <= Data.rows; j++) 
			{
				countY += rowHeight;
				if (this.y < countY)
				{
				rowPos = j;
				break loop2;
				}
				
			}
			
			if (
			(rowPos > Data.rows - 1) ||
			(rowPos < 0) ||
			(colPos > Data.cols - 1) ||
			(colPos < 0)			
			) { return; }
			
			
			
			if(_currDirection == DIRECTION_UP)
			turnYpos = ((rowPos+1) * rowHeight) - (rowHeight/2)  + Constants.MARGIN_TOP
			if(_currDirection == DIRECTION_DOWN)
			turnYpos = ((rowPos) * rowHeight) + (rowHeight/2) + Constants.MARGIN_TOP
			
			_currMapPos = Constants.LEVEL_1_TURN_MAP[rowPos][colPos]
			_currDoorColour = Constants.LEVEL_1_DOOR_MAP[rowPos][colPos]
			
			
			
			

			if (_currMapPos == Constants.O)
			{
			 _isTurning = false;
			 _sourceDirection = "";
			}
			//if coming into a corner, track it so the car doesnt return down that corner after a turn
			if (_currMapPos == Constants.A || _currMapPos == Constants.B || _currMapPos == Constants.C || _currMapPos == Constants.D)
			{
			  _isTurning = false;
			  _sourceDirection = _currMapPos;
			}
			else if (_currMapPos == Constants.T)
			{ 
				//trace("YOU ARE ON TILE T");
					
				if ((_currDirection == DIRECTION_LEFT && this.x <= turnXpos) ||
					(_currDirection == DIRECTION_RIGHT && this.x >= turnXpos) ||
					(_currDirection == DIRECTION_UP && this.y <= turnYpos) ||
					(_currDirection == DIRECTION_DOWN && this.y >= turnYpos)
					)
					{
					//trace("READY TO TURN")	
					if (!_isTurning)
					{
						_isTurning = true;
						
					if (_currDirection == DIRECTION_LEFT)
					this.x = turnXpos;				
					if (_currDirection == DIRECTION_RIGHT)
					this.x = turnXpos;				
					if (_currDirection == DIRECTION_UP)
					this.y = turnYpos;				
					if (_currDirection == DIRECTION_DOWN)
					this.y = turnYpos;
						
					//determine available directions
						var up:String
						var down:String
						var left:String
						var right:String
						var arrAvailableTurns:Array = new Array();
						
						//check UP
						if (rowPos > 0)
						{
							up = Constants.LEVEL_1_TURN_MAP[rowPos - 1][colPos]
							if( up != _sourceDirection && up != Constants.R && up != Constants.O)
							arrAvailableTurns.push(DIRECTION_UP)
						}
						
						//check Down
						if (rowPos < Data.rows-1)
						{
							down = Constants.LEVEL_1_TURN_MAP[rowPos + 1][colPos]			
							if( down != _sourceDirection && down != Constants.R && down != Constants.O)
							arrAvailableTurns.push(DIRECTION_DOWN)
						}
						
						//check Left
						if (colPos > 0)
						{
							left = Constants.LEVEL_1_TURN_MAP[rowPos][colPos -1]
							if( left != _sourceDirection && left != Constants.R && left != Constants.O)
							arrAvailableTurns.push(DIRECTION_LEFT);
						}
						
						//check right
						if (colPos < Data.cols-1)
						{
							right = Constants.LEVEL_1_TURN_MAP[rowPos][colPos + 1]
							if( right != _sourceDirection && right != Constants.R && right != Constants.O)
							arrAvailableTurns.push(DIRECTION_RIGHT);
						}
						//if the car has not been set a direction by the
						//player, then continue going strait unless there is a corner with no other options
					    if (arrAvailableTurns.indexOf(_turnIntention) != -1)
						{
							arrAvailableTurns = [_turnIntention];
							changeDirection(arrAvailableTurns);
						}
						else 
						{
							
							if (Constants.CAR_AUTO_CORNERING)
							{
								changeDirection(arrAvailableTurns)
								return;
							}
							
							
							if (arrAvailableTurns.length == 1)
							{
							changeDirection(arrAvailableTurns)//player is on a corner with onlu 1 path
							}
							else if (arrAvailableTurns.length == 2)
							{
							 //player has hit a T section, determine if player can continue strait
							  if ((_currDirection == DIRECTION_RIGHT && arrAvailableTurns.indexOf(DIRECTION_RIGHT) > -1) ||
							  (_currDirection == DIRECTION_LEFT && arrAvailableTurns.indexOf(DIRECTION_LEFT) > -1) ||
							  (_currDirection == DIRECTION_DOWN && arrAvailableTurns.indexOf(DIRECTION_DOWN) > -1) ||
							  (_currDirection == DIRECTION_UP && arrAvailableTurns.indexOf(DIRECTION_UP) > -1))
							  {
								  //continue going strait
							  }
							  else
							  {
								 changeDirection(arrAvailableTurns)
							  }
							  
							 
							}
						}

					}
				}
			}
			else if (_currMapPos == Constants.G)
			{ 
				this._speed = 0;
				
				trace("_currDoorColour:"+_currDoorColour)
				trace("_currColour:"+_currColour)
				if (_currDoorColour == _currColour)
				Data.currScore += 1;
				
				trace("Data.currScore :"+Data.currScore)
				
				Data.carsOnStage --;
				this.removeFromParent();
				
			}
		}
		
		private function changeDirection(arrDirections:Array):void 
		{
			ArrayUtil.shuffleArray(arrDirections);
			
			_turnIntention = "";
			
			_smcBlinkerL.currentFrame = 0;
			_smcBlinkerR.currentFrame = 0;
						
			_smcBlinkerL.pause();
			_smcBlinkerR.pause();
			
			//trace("newDirection :"+arrDirections[0])
			switch (arrDirections[0]) 
			{
				case DIRECTION_UP:
				//this.rotation = deg2rad(90);
				//TweenLite.to(this, .1, { rotation:deg2rad(90) } )
				
					if(_currDirection == DIRECTION_LEFT)
					TweenLite.to(this, .1, { rotation:deg2rad(90) } )
					else if (_currDirection == DIRECTION_RIGHT)
					TweenLite.to(this, .1, { rotation:String(deg2rad( -90)) } )
					else
					this.rotation = deg2rad(90);  //likely spawning
				break;				
				
				case DIRECTION_DOWN:
				//this.rotation = deg2rad( -90);	
			//	TweenLite.to(this, .1,{rotation:deg2rad(-90)})
					if(_currDirection == DIRECTION_RIGHT)
					TweenLite.to(this, .1, { rotation:String(deg2rad(90)) } )
					else if (_currDirection == DIRECTION_LEFT)
					TweenLite.to(this, .1, { rotation:String(deg2rad(-90)) } )
					else
					this.rotation = deg2rad(-90);  //likely spawning
				break;
				
				case DIRECTION_LEFT:
				//this.rotation = deg2rad(0);	
				TweenLite.to(this, .1,{rotation:deg2rad(0)})
				break;
				
				case DIRECTION_RIGHT:
				//this.rotation = deg2rad(180);	
				if(_currDirection == DIRECTION_UP)
				TweenLite.to(this, .1, { rotation:deg2rad(180) } )
				else if (_currDirection == DIRECTION_DOWN)
				TweenLite.to(this, .1, { rotation:String(deg2rad(-90)) } )
				break;	
			}
			
			_currDirection = arrDirections[0];
			
		}
		
		private function onSwipeRec(e:GestureEvent):void
		{
			var swipeGesture:SwipeGesture = e.target as SwipeGesture;
			
			trace("GESTURE RECOGNIZED");
			//----- RIGHT SWIPE
			if (swipeGesture.offsetX>6) {
					
					if(_currDirection == DIRECTION_UP){
					setTurnIntention(DIRECTION_RIGHT, _smcBlinkerR)
					}else if(_currDirection == DIRECTION_DOWN){
					setTurnIntention(DIRECTION_RIGHT, _smcBlinkerL)	
					}else if(_currDirection == DIRECTION_RIGHT){
					_speed = _speedBoost;
					Delegate.callLater(1500, function():void { _speed = _speedNormal } )
					}

			}
			//----- LEFT SWIPE
			else if (swipeGesture.offsetX < -6) {
				
					if(_currDirection == DIRECTION_UP){
					setTurnIntention(DIRECTION_LEFT, _smcBlinkerL)
					}else if(_currDirection == DIRECTION_DOWN){
					setTurnIntention(DIRECTION_LEFT, _smcBlinkerR)		
					}else if(_currDirection == DIRECTION_LEFT){
					_speed = _speedBoost;
					Delegate.callLater(1500, function():void { _speed = _speedNormal } )
					}
			}
			//----- UP SWIPE
			else if (swipeGesture.offsetY < -6) {
				
					if(_currDirection == DIRECTION_LEFT){
					setTurnIntention(DIRECTION_UP, _smcBlinkerR)
					}else if(_currDirection == DIRECTION_RIGHT){
					setTurnIntention(DIRECTION_UP, _smcBlinkerL)		
					}else if(_currDirection == DIRECTION_UP){
					_speed = _speedBoost;
					Delegate.callLater(1500, function():void { _speed = _speedNormal } )
					}
			}
			//----- DOWN SWIPE
			else if (swipeGesture.offsetY > 6) {
				
					if(_currDirection == DIRECTION_LEFT){
					setTurnIntention(DIRECTION_DOWN, _smcBlinkerL)
					}else if(_currDirection == DIRECTION_RIGHT){
					setTurnIntention(DIRECTION_DOWN, _smcBlinkerR)
					}else if(_currDirection == DIRECTION_DOWN){
					_speed = _speedBoost;
					Delegate.callLater(1500, function():void { _speed = _speedNormal } )
					}

			}
			
		}	
		
		//------------------------------------o
		//-- Screen Touch events
		//------------------------------------o
		private function onTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(stage);
			if(touch)
			{
				if(touch.phase == TouchPhase.BEGAN)
				{
					_speed = _speedSlow;
					Delegate.callLater(1500, function():void{_speed = _speedNormal})
				}
 
				else if(touch.phase == TouchPhase.ENDED)
				{
					
				}
 
				else if(touch.phase == TouchPhase.MOVED)
				{
					
				}
			}
 
		}		
		
		private function setTurnIntention(direction:String, blinker:MovieClip):void 
		{
			_turnIntention = direction;
			
			_smcBlinkerL.currentFrame = 0;
			_smcBlinkerR.currentFrame = 0;
						
			_smcBlinkerL.pause();
			_smcBlinkerR.pause();
			
			blinker.play()
		}
		
		public function get currDirection():String 
		{
			return _currDirection;
		}
		
		public function set currDirection(value:String):void 
		{
			_currDirection = value;
		}
		
		
	}

}