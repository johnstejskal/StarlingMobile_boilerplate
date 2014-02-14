package com.johnstejskal.game.characterMovement 
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	/**
	 * ...
	 * @author john
	 */
	public class CharacterWalkTopDown_noAccel 
	{
		private var isRight:Boolean = false;
		private var isLeft:Boolean = false;
		private var isUp:Boolean = false;
		private var isDown:Boolean = false;
		
		public function CharacterWalkTopDown_noAccel() 
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
		 if(isRight==true && mc.x<450){mc.x+=5}
		 if(isLeft==true && mc.x>50){mc.x-=5}
		 if(isUp==true && mc.y>50){mc.y-=5}
		 if(isDown==true && mc.y<350){mc.y+=5}
		}
				
	}

}








