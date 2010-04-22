package ua.com.syo.simplegame.model.net {
	
	import com.adobe.serialization.json.JSON;
	
	import flash.events.EventDispatcher;
	
	import mx.core.FlexGlobals;
	
	import ua.com.syo.simplegame.model.UserData;
	import ua.com.syo.simplegame.model.net.social.VKData;
	import ua.kiev.djm.core.log.Logger;
	import ua.kiev.djm.core.net.cmd.ICommandParser;
	
	public class CommandParser extends EventDispatcher implements ICommandParser {
		
		private static var _instance:CommandParser;
		
		public static function get instance():CommandParser {
			if(!_instance) _instance = new CommandParser();
			return _instance;
		}
		
		public function parse(command:*): void {
			Logger.trace("[Server]: " + command.toString);
			try {
				var result:Object = JSON.decode(command);
			} catch (error:Error) {
				Logger.ERROR("JSON parser : " + error.message);
			}
			
			if (result) {
				
				if (result.error) {
					// VK API
					if (!(result.error is String) &&  result.error.error_msg) {
						Logger.ERROR("API ERROR : " + result.error.error_msg);
					} else {
						Logger.ERROR(result.error);
					}
				} else {
					// registration
					if (result.reg) {
						if (result.reg == "no") {
							VKData.getProfiles();
						}
						if (result.reg == "ok") {
							VKData.getProfiles();
						}
					}
					// userInfo
					if (result.userInfo) {
						UserData.instance.update(result.userInfo);
					}
				}
				
			}
		}
		
	}
}