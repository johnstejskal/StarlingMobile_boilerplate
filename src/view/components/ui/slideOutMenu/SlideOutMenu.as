package view.components.ui.slideOutMenu
{
	
	import com.greensock.easing.Back;
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;
	import com.johnstejskal.Delegate;
	import com.thirdsense.animation.TexturePack;
	import com.thirdsense.LaunchPad;
	import data.AppData;
	import data.constants.AppStates;
	import data.constants.LaunchPadLibrary;
	import data.settings.PublicSettings;
	import flash.sensors.Geolocation;
	import ManagerClasses.utility.AssetsManager;
	import ManagerClasses.StateMachine;
	import ManagerClasses.utility.DeviceType;
	import singleton.Core;
	import starling.core.Starling;
	import starling.display.Image;
	import flash.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.deg2rad;
	import view.components.EntityObject;

	
	//================================o
	/**
	 * @author John Stejskal
	 * johnstejskal@gmail.com
	 * "Why walk when you can ride"
	 */
	//================================o
	
	public class SlideOutMenu extends EntityObject
	{

		static public const STATE_OPEN:String = "stateOpen";
		static public const STATE_CLOSE:String = "stateClose";
		private var _core:Core;
		
		//images
		private var _imgBacking:Image;
		private var _quFill:Quad;
		
		//mc's
		private var _smcSomeMoveClip:MovieClip;
		private var _type:String;
		private var _imgButton1:Image;
		private var _menuHolder:Sprite;
		private var _isMenuOpen:Boolean = false;
		private var _componentWidth:Number;
		private var _arrNavList:Array;
		private var _imgStats:Image;
		private var _versionLabel:Image;
		
		//positioning / sizing
		private var _topMargin:Number;
		
		//================================o
		//-- Constructor
		//================================o
		public function SlideOutMenu()
		{
			trace(this + "Constructed");
			
			if (stage)
				init(null);
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		
		}
		//================================o
		//-- Init
		//================================o		
		private function init(e:Event):void
		{
			
			trace(this + "inited");
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			//-----------------------------------------------------------------o
			//----generate nav list
		    _arrNavList = new Array();
			_arrNavList.push(["Home", AppStates.STATE_HOME]);
			
			_arrNavList.push(["Rewards & upgrades", AppStates.STATE_TITLE]);
			
			_arrNavList.push(["Contact sgfleet", AppStates.STATE_TITLE]);
			
			_arrNavList.push(["Leaderboards", AppStates.STATE_TITLE]);
			
			_arrNavList.push(["News", AppStates.STATE_TITLE]);
			
			//-----------------------------------------------------------------o
			
			_menuHolder = new Sprite();
			
		    var mc:*;
		    mc = new TA_slideMenuBacking();
		    mc.scaleX = mc.scaleY = AppData.deviceScale
		    TexturePack.createFromMovieClip(mc, LaunchPadLibrary.SLIDE_MENU_DA, "TA_slideMenuBacking", null, 1, 1, null, 0)
		    _imgBacking = TexturePack.getTexturePack(LaunchPadLibrary.SLIDE_MENU_DA, "TA_slideMenuBacking").getImage();
		    this.addChild(_imgBacking)
			_imgBacking.width = AppData.deviceScale * 560
			_imgBacking.height = AppData.deviceResY + 5;
			
			this.addChild(_imgBacking);
			this.addChild(_menuHolder);
			
			// Create Button list
			_topMargin = AppData.deviceScale * 50;
			if (DeviceType.current == DeviceType.IPAD)
			_topMargin = 20;
			
			//Create nav list
			for (var i:int = 0; i < _arrNavList.length; i++)
			{
				var menuItem:SlideMenuItem = new SlideMenuItem(_arrNavList[i][0], _arrNavList[i][1], i)
				menuItem.x = AppData.deviceScale * 20;
				menuItem.y = ((AppData.deviceScale * 76) * i) + _topMargin;
				_menuHolder.addChild(menuItem);
				
			}
			
			_componentWidth = _menuHolder.width;

			//add version label
	        mc = new TA_versionLabel();
		    mc.scaleX = mc.scaleY = AppData.deviceScale;
		    mc.$txLabel.text = PublicSettings.VERSION;
		    TexturePack.createFromMovieClip(mc, LaunchPadLibrary.SLIDE_MENU_DA, "TA_versionLabel", null, 1, 1, null, 0)
		    _versionLabel = TexturePack.getTexturePack(LaunchPadLibrary.SLIDE_MENU_DA, "TA_versionLabel").getImage();
		    _versionLabel.x = 10;			
		    _versionLabel.y = this.height - 10;			
		    this.addChild(_versionLabel)
		
		}
		
		//================================o
		//-- dispose/kill
		//================================o		
		public function trash():void
		{
			trace(this + " trash()")
			this.removeFromParent();
			TexturePack.deleteTexturePack(LaunchPadLibrary.SLIDE_MENU_DA)
		
		}
		//================================o
		//-- Getters and Setters
		//================================o		
		public function get componentWidth():Number
		{
			return _componentWidth;
		}
	
	}

}