package com.johnstejskal  {
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.external.ExternalInterface;
	//import com.adobe.serialization.json.JSON;
	import com.pippoflash.string.JsonMan;
	
	public class FaceBook{
		
		private var _currentUserName:String;
		private var _currentUserID:String;
		private var _avatar:Loader;
		private var _nameField:TextField;
		private var _controls:MovieClip;
		
		public function FaceBook() {
			//JsonMan.init()
			//debug("App constructor");
			
			//_currentUserName = loaderInfo.parameters.userName || "John Stejskal";
			//_currentUserID = loaderInfo.parameters.userID || "686405474";
			
			//loadCurrentUserAvatar();
			//showCurrentUserName();
			//addControls();
			
			//ExternalInterface.addCallback("onGetFriends", onGetFriends);
			
		}
		public static function loadCurrentUserAvatar(userID:String):Loader {
			var url:String = "http://graph.facebook.com/" + userID + "/picture";
			var _avatar:Loader = new Loader();
			_avatar.load(new URLRequest(url));
			//_avatar.x = _avatar.y = 20;
			//addChild(_avatar);
			return _avatar
		}
		/*
		private function showCurrentUserName():void {
			var tf:TextFormat = new TextFormat();
			tf.font = "Verdana";
			tf.size = 12;
			tf.color = 0x000000;
			_nameField = new TextField();
			_nameField.defaultTextFormat = tf;
			_nameField.text = _currentUserName;
			_nameField.x = 80;
			_nameField.y = 20;
			_nameField.width = 300;
			_nameField.height = 30;
			addChild(_nameField);
		}
		private function addControls():void {
			_controls = new AppControls();
			_controls.x = 20;
			_controls.y = 83;
			_controls.b1.addEventListener(MouseEvent.CLICK, getFriends);
			addChild(_controls);
		}
		private function getFriends(e:Event):void {
			ExternalInterface.call("F.getFriends");
		}
		private function onGetFriends(result:String):void {
			var friends:Array = JsonMan.decode(result).data;
			var text:String = "";
			if(friends && friends.length > 0) {
				var numOfFriends:int = friends.length;
				for(var i:int=0; i<numOfFriends; i++) {
					text += friends[i].name + " <u><a href='http://www.facebook.com/profile.php?id=" + friends[i].id + "' target='_blank'>view profile</a></u><br />";
				}
			} else {
				text = "Problem reading friends' list.";
			}
			_controls.area.htmlText = text;
		}
		public function debug(str:*):void {
			trace(str.toString());
		}
		*/
	}

}