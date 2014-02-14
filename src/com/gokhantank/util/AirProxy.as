package com.gokhantank.util
{
	import air.update.ApplicationUpdaterUI;
	import air.update.events.UpdateEvent;
	import flash.desktop.DockIcon;
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemTrayIcon;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.display.Stage;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.InvokeEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.system.Capabilities;
	/**
	$(CBI)* ...
	$(CBI)* @author Gokhan Tank
	$(CBI)*/
	public class AirProxy
	{
		private var startupLogin: NativeMenuItem;
		private var alwaysOnTop: NativeMenuItem;
		
		private var _stage:Stage;
		static private var instance:AirProxy;
		private var appUpdater:ApplicationUpdaterUI;
		private var _version:String;
		
		public function AirProxy() 
		{
			
		}
		 public static function get self() : AirProxy {
            if(instance==null) instance = new AirProxy();
            return instance;
		}
		public function init(inStage:Stage) : void {
			if (_stage) return;
			_stage = inStage;
			initAirConfig();
		}
		private function initAirConfig() {
			_stage.nativeWindow.x = Capabilities.screenResolutionX - 460;
			_stage.nativeWindow.y = 50;
			_stage.nativeWindow.alwaysInFront = true;
			//NativeApplication.nativeApplication.startAtLogin = true;
			NativeApplication.nativeApplication.autoExit = false;
			
			MainView.self.$dragBtn.addEventListener(MouseEvent.MOUSE_DOWN, moveWindow);
			MainView.self.$exitBtn.addEventListener(MouseEvent.CLICK, closeWindow);
			MainView.self.$minimizeBtn.addEventListener(MouseEvent.CLICK, minimizeWindow);
			
			checkUpdate();
			
			createSystemTrayNav();
		}
		
		/*private function checkUpdate():void
		{
			setApplicationNameAndVersion();
			appUpdater = new ApplicationUpdaterUI();
			appUpdater.configurationFile = new File("app:/updateConfig.xml"); 
			appUpdater.initialize();
		}*/
		private function checkUpdate():void {
			appUpdater = new ApplicationUpdaterUI();
			NativeApplication.nativeApplication.addEventListener( Event.EXITING, 
                function(e:Event):void {
                    var opened:Array = NativeApplication.nativeApplication.openedWindows;
                    for (var i:int = 0; i < opened.length; i ++) {
                        opened[i].close();
                    }
            });    
    
            setApplicationVersion(); // Find the current version so we can show it below
            
            // Configuration stuff - see update framework docs for more details
            appUpdater.updateURL = "http://www.cokenmusic.com/cnmdesktop/update.xml"; // Server-side XML file describing update
            appUpdater.isCheckForUpdateVisible = false; // We won't ask permission to check for an update
			appUpdater.isDownloadUpdateVisible = true;
			appUpdater.isDownloadProgressVisible = true;
            appUpdater.addEventListener(UpdateEvent.INITIALIZED, onUpdate); // Once initialized, run onUpdate
            appUpdater.addEventListener(ErrorEvent.ERROR, onError); // If something goes wrong, run onError
            appUpdater.initialize(); // Initialize the update framework
        }
    
        private function onError(event:ErrorEvent):void {
            //Alert.show(event.toString());
        }
        
        private function onUpdate(event:UpdateEvent):void {
			trace(this + ".onUpdate");
            appUpdater.checkNow(); // Go check for an update now
        }
    
        // Find the current version for our Label below
        private function setApplicationVersion():void {
            var appXML:XML = NativeApplication.nativeApplication.applicationDescriptor;
            var ns:Namespace = appXML.namespace();
			_version = appXML.ns::version[0]; 

        }
		
		private function moveWindow(e:MouseEvent):void 
		{
			_stage.nativeWindow.startMove();
		}
		private function minimizeWindow(event:MouseEvent):void {
			//this.stage.nativeWindow.minimize();
			_stage.nativeWindow.visible = false;
			//stage.nativeWindow.notifyUser(NotificationType.CRITICAL);
		}
		public function closeWindow(event:MouseEvent):void {
			NativeApplication.nativeApplication.icon.bitmaps = [];
			NativeApplication.nativeApplication.exit();
		}
		public function closeWindow2(event:Event):void {
			NativeApplication.nativeApplication.icon.bitmaps = [];
			NativeApplication.nativeApplication.exit();
		}
		
		private function openWindow():void
		{
			_stage.nativeWindow.visible = true;
		}
		private function restoreWindow(e:MouseEvent):void
		{
			openWindow();
			_stage.nativeWindow.restore();
		}
		
		private function showCommandWindow(e:Event):void
		{
			openWindow();
			_stage.nativeWindow.restore();
		}
		private function onSetAlwaysOnTop(evt:Event):void {
			alwaysOnTop.checked = _stage.nativeWindow.alwaysInFront?false:true;
			_stage.nativeWindow.alwaysInFront = alwaysOnTop.checked;
		}
		private function onSetStartupLogin(evt:Event):void {
			startupLogin.checked = NativeApplication.nativeApplication.startAtLogin?false:true;
			NativeApplication.nativeApplication.startAtLogin = startupLogin.checked;
		}
		private function createSystemTrayNav():void
		{
			NativeApplication.nativeApplication.autoExit = false;
			var _trayIcon:MovieClip = new TrayIcon();
			var bmd:BitmapData = new BitmapData(_trayIcon.width, _trayIcon.height);
				bmd.draw(_trayIcon);
			if (NativeApplication.supportsDockIcon) {
				NativeApplication.nativeApplication.icon.bitmaps = [bmd];
				var dockIcon:DockIcon = NativeApplication.nativeApplication.icon as DockIcon;
				NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, openWindow);
				dockIcon.menu = createIconMenu();

			} else if (NativeApplication.supportsSystemTrayIcon) {
				/*loader.contentLoaderInfo.addEventListener(Event.COMPLETE,iconLoadComplete);
                loader.load(new URLRequest("icons/AIRApp_128.png")); */
				
				NativeApplication.nativeApplication.icon.bitmaps = [bmd]
				var sysTrayIcon:SystemTrayIcon = NativeApplication.nativeApplication.icon as SystemTrayIcon;
				sysTrayIcon.tooltip = "Cokenmusic";
				sysTrayIcon.addEventListener(MouseEvent.CLICK, restoreWindow);
				sysTrayIcon.menu = createIconMenu();
			}
		
		}
		
		
		private function createIconMenu():NativeMenu {
			var iconMenu:NativeMenu = new NativeMenu();
			
			var settingsCommand:NativeMenuItem = new NativeMenuItem("Ayarlar");
			var showCommand: NativeMenuItem = new NativeMenuItem("Cokenmusic "+_version+"'ı aç");
			var exitCommand: NativeMenuItem = new NativeMenuItem("Kapat");
			
			iconMenu.addSubmenu(createSettingsMenu(), "Ayarlar");
			iconMenu.addItem(new NativeMenuItem("", true));//Separator
			
			if (NativeApplication.supportsSystemTrayIcon) {
				iconMenu.addItem(showCommand);
				showCommand.addEventListener(Event.SELECT, showCommandWindow);
				iconMenu.addItem(exitCommand);
				exitCommand.addEventListener(Event.SELECT, closeWindow2);
			}
			
			return iconMenu;
		}
		
		private function createSettingsMenu():NativeMenu {
			var settingsMenu:NativeMenu = new NativeMenu();
			startupLogin = settingsMenu.addItem(new NativeMenuItem("Açılışta açılsın"));
			startupLogin.addEventListener(Event.SELECT, onSetStartupLogin);
			startupLogin.checked = true;
			alwaysOnTop = settingsMenu.addItem(new NativeMenuItem("Tüm pencerelerin üstünde dursun"));
			alwaysOnTop.addEventListener(Event.SELECT, onSetAlwaysOnTop);
			alwaysOnTop.checked = true;
			
			return settingsMenu;
		}
	}

}