package com.bumpslide.view {
	import com.bumpslide.view.IView;
	import com.bumpslide.ui.Component;
	import com.bumpslide.events.ViewChangeEvent;	
	
	/**
	 * Abstract Transitionable View
	 *  
	 * Extend this class with custom transitions in your app.
	 * See example implementation at the bottom of this file.
	 * 
	 * @author David Knape
	 */
	public class BasicView extends Component implements IView {

		public static const STATE_TRANSITIONING_OUT:String = "transOut";
		public static const STATE_TRANSITIONING_IN:String = "transIn";
		public static const STATE_ACTIVE:String = "active";
		public static const STATE_INACTIVE:String = "inactive";
				
		protected var _viewState:String = STATE_INACTIVE;
		
		public function transitionIn():void {
			_viewState = STATE_TRANSITIONING_IN;
			dispatchEvent( new ViewChangeEvent( ViewChangeEvent.TRANSITION_IN ) );
		}		
		
		public function transitionOut():void {
			_viewState = STATE_TRANSITIONING_OUT;			
			dispatchEvent( new ViewChangeEvent( ViewChangeEvent.TRANSITION_OUT ) );
		}
		
		protected function transitionOutComplete() : void {
			debug('transition out complete');
			_viewState = STATE_INACTIVE;
			dispatchEvent( new ViewChangeEvent( ViewChangeEvent.TRANSITION_OUT_COMPLETE ) ); 
			destroy();
		}
		
		protected function transitionInComplete() : void {
			if(_viewState==STATE_TRANSITIONING_OUT) return;
			_viewState = STATE_ACTIVE;
			dispatchEvent( new ViewChangeEvent( ViewChangeEvent.TRANSITION_IN_COMPLETE ) );
		}
		
		public function get viewState():String {
			return _viewState;
		}
	}
}

//package app {
//	import com.bumpslide.ui.AbstractView;
//	import com.bumpslide.tween.FTween;
//
//	/**
//	 * Example View Implementation
//	 */
//	public class AppView extends AbstractView {
//		
//		override public function transitionIn():void {
//			FTween.fadeIn( this, 0, .2, transitionInComplete );
//			super.transitionIn();
//		}		
//		
//		override public function transitionOut():void {	
//			FTween.fadeOut( this, 0, .5, transitionOutComplete );
//			super.transitionOut();
//		}
//	}
//}
