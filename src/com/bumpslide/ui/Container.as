package com.bumpslide.ui 
{
	import com.bumpslide.ui.Component;
	import com.bumpslide.ui.constants.Direction;
	import com.bumpslide.util.Align;

	import flash.display.DisplayObject;

	/**
	 * Generic container to be used as HBox or Vbox
	 * 
	 * @author David Knape
	 */
	public class Container extends Component 
	{		
		protected var _layout:String = "horizontal";
		protected var _spacing:uint = 10;
		
		override protected function addChildren():void
		{
			super.addChildren();
			addEventListener( Component.EVENT_DRAW, eventDelegate( invalidate ) );
		}
				
		override protected function draw():void
		{
			for each ( var child:DisplayObject in children ) {
				child.x = child.y = 0;				
			}
			
			switch( layout ) {				
				case Direction.HORIZONTAL:
					Align.hbox( children, spacing );
					break;
				case Direction.VERTICAL:
					Align.vbox( children, spacing );
					break;
			}			
			super.draw();
		}
		
		
		public function get layout():String {
			return _layout;
		}		
		
		[Inspectable(type="String",enumeration="horizontal,vertical")]
		public function set layout(layout:String):void {
			_layout = layout;
			invalidate();
		}		
		
		public function get spacing():uint {
			return _spacing;
		}		
		
		public function set spacing(spacing:uint):void {
			_spacing = spacing;
			invalidate();
		}
	}
}
