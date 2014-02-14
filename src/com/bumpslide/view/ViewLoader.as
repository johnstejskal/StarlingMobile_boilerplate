package com.bumpslide.view 
{
	import com.bumpslide.events.ViewChangeEvent;
	import com.bumpslide.ui.IResizable;
	import com.bumpslide.view.BasicView;
	import com.bumpslide.view.IView;

	import flash.display.DisplayObject;
	import flash.net.LocalConnection;

	/**
	 * Makes use of the transition in and out methods of pages to manage page content
	 * 
	 * This is a rather abstract view stack.  You could use this to switch between
	 * sections of a web page, or to switch view when changing a tab in a form.
	 * 
	 * If you want a ready-made viewstack, check out the ViewStack class that
	 * mantains an array of the classes you want instantiated.  
	 * 
	 * In your subclass, whenever you need to trigger a page change, simply
	 * call invalidate(VALID_VIEW); 
	 * 
	 * Then, override the initView() method and update 'currentView' there.
	 * 
	 * @author David Knape
	 */
	public class ViewLoader extends BasicView implements IView {

		// validation constant
		public static const VALID_VIEW:String = "validView";

		// the curent view
		protected var _currentView:IView;

		// holder for old views
		protected var _oldViews:Array;

		/**
		 * Constructor
		 */
		public function ViewLoader() {
			_oldViews = new Array();
			super();
		}

		/**
		 * Override this and add new view to stage while saving reference as 'currentView'
		 */
		protected function initView():void {
			trace('WARNING: You need to implement the initView() method in your ViewLoader implementation.  This is where you set currentView and add it to the stage.');
		}

		/**
		 * If valid page has changed, transition out the old page and load in the new one
		 */
		override protected function draw():void {			
			if(hasChanged(VALID_VIEW)) {	
				validate(VALID_VIEW);
				updateView();
			}
			
			if(hasChanged(VALID_SIZE)) {
				if(currentView is IResizable) {
					( currentView as IResizable).setSize( width, height );
				}
			}
			super.draw();
		}

		/**
		 * transition out old page and load the next one
		 */
		protected function updateView():void {
				
			if(_currentView != null) {
					
				// instead of killing the current view, move a reference
				// to a stack of old views, so we can add new views on top
				// and allow for crossfades, and things of that sort
				_oldViews.push(currentView);
				debug('updatePage() - transitioning out current view ' + currentView );
				currentView.transitionOut();
				//currentView = null;
			} else {
				debug('updatePage() - currentView is null. Adding new view now...');
				addNewView();
			}
		}


		/**
		 * transition out complete, load next page
		 */
		protected function handleTransitionOutComplete(event:ViewChangeEvent):void {
			debug('handleTransitionOutComplete() for ' + event.target );
			addNewView();
		}
		
		/**
		 * Transition In is complete, time to remove the old views
		 */
		protected function handleTransitionInComplete(event:ViewChangeEvent):void {
			debug('removeOldViews() [because transitionIn is complete for '+event.target+']');
			removeOldViews();
		}

		/**
		 * Initializes new page and calls transitionIn on that page
		 */
		protected function addNewView():void {
			
			_currentView = null;
			
			// subclass should create child and add to display list
			initView();
						
			if(currentView != null) {
				debug('addNewView() created ' + currentView);				
				currentView.addEventListener(ViewChangeEvent.TRANSITION_OUT_COMPLETE, handleTransitionOutComplete, false, 0, true);
				currentView.addEventListener(ViewChangeEvent.TRANSITION_IN_COMPLETE, handleTransitionInComplete, false, 0, true);
				currentView.transitionIn();
			} else {
				debug('removeOldViews() [because there is no new currentView]');
				removeOldViews();
			}
		}
		
		/**
		 * Remove all the old views
		 */
		protected function removeOldViews():void {
			while( _oldViews.length ) {
				var view:IView = _oldViews.pop();
				debug(' - removing ' + view );
				if(view is DisplayObject) destroyChild( view as DisplayObject );
				view.removeEventListener(ViewChangeEvent.TRANSITION_OUT_COMPLETE, handleTransitionOutComplete);				view.removeEventListener(ViewChangeEvent.TRANSITION_IN_COMPLETE, handleTransitionInComplete);
			}
			_oldViews = new Array();
			
			// force some garbage collection (yeah, gskinner told you not to do this in production code. I know.)
			try {
				new LocalConnection().connect('__');
				new LocalConnection().connect('__');
			} catch (e:*) {}
		}

		/**
		 * The current view
		 */
		public function get currentView():IView {
			return _currentView;
		}

		/**
		 * Set the current view.  This should be a display object.
		 */
		public function set currentView(currentView:IView):void {
			_currentView = currentView;
		}
				
		
		//------------------------------------------------------------		
		// IView implementation so that ViewLoaders can be nested
		//------------------------------------------------------------
		
		/**
		 * Transition out the child view
		 */
		override public function transitionOut():void {
			if(currentView!=null) {
				currentView.addEventListener(ViewChangeEvent.TRANSITION_OUT_COMPLETE, handleChildTransitionOutComplete, false, 0, true);
				currentView.transitionOut();
			}
			super.transitionOut();
		}
		
		/**
		 * notify transition out complete
		 */
		private function handleChildTransitionOutComplete(event:ViewChangeEvent):void {
			currentView.removeEventListener(ViewChangeEvent.TRANSITION_OUT_COMPLETE, handleChildTransitionOutComplete);
			super.transitionOutComplete();
		}
	}
}
