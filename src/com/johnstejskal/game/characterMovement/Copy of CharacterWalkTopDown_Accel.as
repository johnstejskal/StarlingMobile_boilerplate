package com.johnstejskal.game.characterMovement 
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	/**
	 * ...
	 * @author john
	 */
	public class CharacterWalkTopDown_Accel 
	{
		private var isRight:Boolean = false;
		private var isLeft:Boolean = false;
		private var isUp:Boolean = false;
		private var isDown:Boolean = false;
		
		private var xspeed:Number = 0;
		private var yspeed:Number = 0;
		private var maxspeed:Number = 8;
		private var accel:Number = 0.5;		
				
		public function CharacterWalkTopDown_Accel() 
		{
			
		}
		
		private function addListeners():void
		{
		stage.addEventListener(KeyboardEvent.KEY_DOWN, downKey);
		stage.addEventListener(KeyboardEvent.KEY_UP, upKey);	
		stage.addEventListener(Event.ENTER_FRAME, loop);
		}
		
		
		private function downKey(event:KeyboardEvent)
		{
		 if(event.keyCode==39){
		 isRight=true}
		 if(event.keyCode==37){
		 isLeft=true}
		 if(event.keyCode==38){
		 isUp=true}
		 if(event.keyCode==40){
		 isDown=true}
		}
		
		private function upKey(event:KeyboardEvent)
		{
		 if(event.keyCode==39){
		 isRight=false}
		 if(event.keyCode==37){
		 isLeft=false}
		 if(event.keyCode==38){
		 isUp=false}
		 if(event.keyCode==40){
		 isDown=false}
		}	
		
		private function loop(Event)
		{
			// if right is pressed and speed didnt hit the limit, increase speed
			if(isRight==true && xspeed<maxspeed){xspeed+=2}
			// if left is pressed and speed didnt hit the limit, increase speed (the other way)
			if(isLeft==true && xspeed>-maxspeed){xspeed-=2}
			// if speed is more than 0, decrease
			if(xspeed>0){xspeed-=accel}
			// if speed is less than 0, increase
			if (xspeed < 0) { xspeed += accel }
			
			// just like x, but with y
			if(isDown==true && yspeed<maxspeed){yspeed+=2}
			if(isUp==true && yspeed>-maxspeed){yspeed-=2}
			if(yspeed>0){yspeed-=accel}
			if(yspeed<0){yspeed+=accel}

			// apply speed to movieclip
			mc.x+=xspeed
			mc.y+=yspeed		
		}
				
	}

}








