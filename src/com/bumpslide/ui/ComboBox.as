﻿package com.bumpslide.ui {
	import com.bumpslide.data.type.Padding;
	import com.bumpslide.events.UIEvent;
	import com.bumpslide.tween.FTween;
	import com.bumpslide.ui.Component;
	import com.bumpslide.util.Align;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.getDefinitionByName;		
	
	[Event(name='change',type='flash.events.Event')]
	
	/**
	 * A combobox (requires assets on stage)
	 * 
	 * @author David Knape
	 */
	public class ComboBox extends Component {

		// stage assets
		public var background:Button;
		public var label_txt:TextField;
		public var dropdown:Grid;
		public var icon:Sprite;
		
		// holder for dropdown (defaults to stage)
		protected var _dropDownHolder:DisplayObjectContainer;

		// state
		protected var _dropDownOpen:Boolean;
		protected var _dropdownWidth:Number=-1;
		protected var _selectedIndex:int=-1;
		protected var _selectedItem:*;
		protected var _selectionPrompt:String="Select...";
		protected var _dropdownGridInitialized:Boolean = false;
		protected var _dropdownClassName:String = "combo_dropdown";
		
		// validate constants
		public static const VALID_DROPDOWN:String='dropdown';
		

		//------------------------------
		// COMPONENT OVERRIDES
		//------------------------------
		
		override protected function addChildren():void {
			createBackground();
			createDropdown();
			createLabel();
			/*if(height==0 && width==0) {
				setSize( 150, 22);
			}*/
			addEventListener( MouseEvent.CLICK, toggleDropdownList); 
			super.addChildren();    
		}
		
		/**
		 * Creates the dropdown list
		 * 
		 * By default, this is just a normal grid
		 */
		protected function createDropdown():void {			
			if(dropdown==null) {				
				try { 
					var dropdown_class:Class;
					dropdown_class = getDefinitionByName( _dropdownClassName ) as Class;
					dropdown = new dropdown_class();	
				} catch (e:Error) {
					dropdown = new Grid();
					dropdown.backgroundBox.color = 0x999999;
					dropdown.backgroundBox.alpha = .8;
					dropdown.padding = new Padding(2);
					dropdown.spacing = 1;
					dropdown.scrollbarWidth = 13;
				}	
			}			
			dropdown.rowHeight = 20;
			dropdown.fixedColumnCount = 1;
			dropdown.gap = 2;
			dropdown.addEventListener( Grid.EVENT_ITEM_CLICK, handleDropdownItemClick);	
		}

		protected function createBackground():void {
			if(background==null) {
				background = new GenericButton(width, height);
				addChild( background );
				
				// we're in code-only mode, so draw an icon
				icon = new PixelIcon(['*****', ' ***', '  *']);
				addChild( icon );
			}
		}
		
		protected function createLabel():void {
			if(label_txt==null) {
			   	label_txt = new TextField();
				label_txt.defaultTextFormat = new TextFormat('Verdana', 14, 'bold');   
				label_txt.autoSize = TextFieldAutoSize.LEFT;
				label_txt.x = 1.5;
				label_txt.y = -7.5;
				addChild( label_txt );
			}
			label_txt.multiline = false;
			label_txt.mouseEnabled = false;
			label_txt.mouseWheelEnabled = false;
			
		}

		override protected function draw():void {		
			drawBackground();
			drawDropdown();
			drawLabel();
			super.draw();
		}
		

		//------------------------------
		// EVENT HANDLERS
		//------------------------------
		
		protected function toggleDropdownList(event:Event=null):void {
			if(_dropDownOpen) {
				closeDropdownList(event);
				return;
			}
			_dropDownOpen = true;			
			callLater(1, dropdown.addEventListener, MouseEvent.CLICK, captureClicks );			
			callLater(1, stage.addEventListener, MouseEvent.CLICK, closeDropdownList );
			stage.addEventListener( Event.MOUSE_LEAVE, closeDropdownList );		
			invalidate(VALID_DROPDOWN);
		}

		protected function closeDropdownList(event:Event=null):void {
			_dropDownOpen = false;
			dropdown.removeEventListener(MouseEvent.CLICK, captureClicks);
			stage.removeEventListener( MouseEvent.CLICK, closeDropdownList );
			stage.removeEventListener( Event.MOUSE_LEAVE, closeDropdownList );
			invalidate(VALID_DROPDOWN);
		}
		
		private function captureClicks(event:Event):void {
			event.stopImmediatePropagation();
		}
		
		private function handleDropdownItemClick(event:UIEvent):void {
			debug('selected item ' + event.data );
			selectedIndex = (event.target as IGridItem).gridIndex;		
			closeDropdownList();	
		}		
		
		
		//------------------------------
		// COMBOBOX DRAWING METHODS
		//------------------------------
		
		
		protected function drawDropdown():void {
	
			// remove dropdown from this displaylist
			if(dropdown && contains(dropdown)) removeChild( dropdown );	
						
			if(dropDownHolder==null && stage!=null) dropDownHolder = stage;
			
			if(hasChanged(VALID_DROPDOWN) && dropDownHolder!=null) {				
				if(_dropDownOpen) {
					dropDownHolder.addChild( dropdown );
					var loc:Rectangle = background.getBounds( stage );
					dropdown.x = loc.x;
					dropdown.y = loc.bottom-1;
					if(dataProvider!=null) {
						dropdown.setSize( dropdownWidth, Math.min( 200, dataProvider.length*dropdown.rowHeight + dropdown.padding.height ));
						// open on top if necessary
						
						if(dropdown.getBounds(dropDownHolder).bottom>stage.getBounds(dropDownHolder).bottom) {
							dropdown.y = loc.top-dropdown.height+1;
						}
					}		
					FTween.fadeIn( dropdown, 200, .2 );
				} else {
					FTween.stopTweening(dropdown);
					dropdown.visible = false;
					dropdown.reset();
					if(dropDownHolder.contains(dropdown)) dropDownHolder.removeChild(dropdown);
				}
				validate(VALID_DROPDOWN);
			}
		}
		
		protected function drawBackground():void {
			background.enabled = enabled;
			background.setSize( width, height );
			if(icon) {
				Align.right( icon, Math.round(width-(height-icon.height)/2));
				Align.middle( icon, height );
			}
		}
		
		protected function drawLabel():void {			
			if(selectedItem==null) {
				label_txt.text = _selectionPrompt;
			} else {
				label_txt.text = selectedItem.label + "";
			}                 
			label_txt.width = width - 20; 
			//label_txt.y = Math.round((height-label_txt.textHeight)/2);
		}

		//------------------------------
		// GETTERS/SETTERS
		//------------------------------
		
		/**
		 * emabled status - overriden to pass value to background
		 */
		override public function set enabled (v:Boolean) : void {
			super.enabled = v;
			if(!enabled && _dropDownOpen) closeDropdownList(); 
			invalidate();
		}
		
		/**
		 * The combobox dataprovider
		 */		 
		public function get dataProvider() : * {
			return dropdown.dataProvider;
		}
		
		public function set dataProvider( dp:* ) : void {
			dropdown.dataProvider = dp;
		}
		
		/**
		 * the selected index, of course
		 */
		public function get selectedIndex():int {
			return _selectedIndex;
		}
		
		public function set selectedIndex(idx:int):void {
			
			if (isNaN(idx)) idx = 0;
			if (idx==-1) {
				_selectedIndex = -1;
				return;
			}
			var old_index:int = _selectedIndex;
			_selectedIndex = Math.max( idx, Math.min( dataProvider.length, 0 ));
			debug('selectedIndex = ' + idx );
			if(_selectedIndex!==old_index) {
				dispatchEvent( new Event(Event.CHANGE) );
				sendChangeEvent( 'selectedIndex', _selectedIndex, old_index );
				sendChangeEvent( 'selectedItem', getItemAt(_selectedIndex), getItemAt(old_index) );
			}
			invalidate();
		}
		
		public function get selectedItem():* {
			return getItemAt(selectedIndex);
		}
		
		public function set selectedItem(item:*):void {			
			var idx:int;
			if(dataProvider.getItemIndex is Function) {
				idx = dataProvider['getItemIndex'](item) as int;
			} else {
				idx = (dataProvider as Array).indexOf( item );
			}			
			selectedIndex = idx;
		}
		
		public function get selectionPrompt():String {
			return _selectionPrompt;
		}
		
		public function set selectionPrompt(selectionPrompt:String):void {
			_selectionPrompt = selectionPrompt;
			invalidate();
		}
		
		public function get dropdownWidth():Number {
			return (_dropdownWidth==-1)?width:_dropdownWidth;
		}
		
		public function set dropdownWidth(dropdownWidth:Number):void {
			_dropdownWidth = dropdownWidth;
		}
		
		public function get cellRenderer():Class {
			return dropdown.gridItemRenderer;
		}
		
		/**
		 * Must be a class that implements IGridItem
		 */
		public function set cellRenderer(cellRenderer:Class):void {
			dropdown.gridItemRenderer = cellRenderer;
		}
		
		public function get tweenEnabled():Boolean {
			return dropdown.tweenEnabled;
		}
		
		public function set tweenEnabled(tweenEnabled:Boolean):void {
			dropdown.tweenEnabled = tweenEnabled;
		}
		
		public function getItemAt(idx:int) : * {
			if(dataProvider==null || dataProvider.length==0 || idx<0) return null;			
			if(dataProvider.getItemAt is Function) {
				return dataProvider['getItemAt']( idx );
			} else {
				return dataProvider[ idx ];
			}
		}
		
		public function get dropDownHolder():DisplayObjectContainer {
			return _dropDownHolder;
		}
		
		public function set dropDownHolder(dropDownHolder:DisplayObjectContainer):void {
			_dropDownHolder = dropDownHolder;
			invalidate(VALID_DROPDOWN);
		}
	}
}
