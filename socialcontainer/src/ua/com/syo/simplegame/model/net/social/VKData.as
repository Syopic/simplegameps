package ua.com.syo.simplegame.model.net.social {
	import ru.vkontakte.VKApi;
	
	import ua.com.syo.simplegame.model.CommandSeneder;
	import ua.kiev.djm.core.log.Logger;

	public class VKData {
		
		
		public static var securityKey:String = "bye2uZ6umA";
		private static var vkAPI:VKApi;
		public static var flashVars:Object;
		
		public static var lastRequestCommand:String;
		
		public static var apiProfileResponse:String;
		public static var apiAppFriends:String;
		
		public static function init(parameters:Object):void {
			flashVars = parameters;
			vkAPI = new VKApi(flashVars, flashVars["api_id"], securityKey, true);
			vkAPI.errorHandler = onErrorHandler;
		}
		
		public static function getProfiles():void {
			lastRequestCommand = "getProfiles";
			vkAPI.getProfiles([flashVars["viewer_id"]], ["photo"], onDataHandler);
		}
		
		public static function getAppFriends():void {
			lastRequestCommand = "getAppFriends";
			vkAPI.getAppFriends(onDataHandler);
		}
		
		private static function onDataHandler(data:Object): void {
			Logger.DEBUG("API: " + data.action + ":" + data.source);
			if (lastRequestCommand == "getProfiles") {
				apiProfileResponse = data.source;
				getAppFriends();
			} else if (lastRequestCommand == "getAppFriends") {
				apiAppFriends = data.source;
				CommandSeneder.send("reg", {name:apiProfileResponse, friends:apiAppFriends});
			}
		}
		
		private static function onErrorHandler(data:Object): void {
			Logger.ERROR(data.error_code + ":" + data.error_msg);
		}
		
	}
}