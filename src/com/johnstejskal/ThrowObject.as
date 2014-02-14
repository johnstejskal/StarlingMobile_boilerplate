package com.johnstejskal 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author 
	 */
	public class ThrowObject 
	{
	    private var ms:MouseSpeed		= new MouseSpeed();
		private var xSpeed:Number		= 0;
		private var ySpeed:Number		= 0;
		private var friction:Number		= .7//0.96;
		private var offsetX:Number		= 0;
		private var offsetY:Number		= 0;
		private var object:MovieClip;
		public function ThrowObject() 
		{
			object = //;
			object.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			object.addEventListener(Event.ENTER_FRAME, throwobject);			
		}
		
		
		private function mouseDownHandler(e:MouseEvent):void
		{
			_stage.addEventListener(Event.ENTER_FRAME, drag);
			_stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			offsetX = _stage.mouseX - object.x;
			//offsetY = mouseY - object.y;
		}

		private function mouseUpHandler(e:MouseEvent):void
		{
			_stage.removeEventListener(Event.ENTER_FRAME, drag);
			_stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			xSpeed = ms.getXSpeed();
			//ySpeed = ms.getYSpeed();
		}	
		
		private function drag(e:Event):void
		{
			object.x = _stage.mouseX - offsetX;
			//object.y = mouseY - offsetY;
		}

		private function throwobject(e:Event):void
		{
			// move object and apply friction
			object.x += xSpeed;
			//object.y += ySpeed;
			
			xSpeed *= friction;
			//ySpeed *= friction;
			
			// keep object within bounds (stage borders)
			//if(object.x > stage.stageWidth - object.width / 2)
			/*
			if(object.x > object.width)
			{
				object.x = _stage.stageWidth - object.width / 2;
				xSpeed *= -1;
			}
			if(object.x < object.width / 2)
			{
				object.x = object.width / 2;
				xSpeed *= -1;
			}
			if(object.y > _stage.stageHeight - object.height / 2)
			{
				object.y = _stage.stageHeight - object.height / 2;
				ySpeed *= -1;
			}
			if(object.y < object.height / 2)
			{
				object.y = object.height / 2;
				ySpeed *= -1;
			}
			*/
		}

		private function changeFriction(e:Event):void
		{
			friction = e.target.value;
			//trace(e.target.value);
		}			
		
		
		
		
	}

}