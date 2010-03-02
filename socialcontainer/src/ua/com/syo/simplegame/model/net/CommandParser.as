package ua.com.syo.simplegame.model.net {
	
	import com.adobe.serialization.json.JSON;
	
	import flash.events.EventDispatcher;
	
	import mx.core.FlexGlobals;
	
	import ua.kiev.djm.core.log.Logger;
	import ua.kiev.djm.core.net.cmd.ICommandParser;
	
	public class CommandParser extends EventDispatcher implements ICommandParser {
		
		private static var _instance:CommandParser;
		
		public static function get instance():CommandParser {
			if(!_instance) _instance = new CommandParser();
			return _instance;
		}
		
		public var lastRequestCommand:String = "getProfiles";
		
		public function parse(command:*): void {
			try {
				var result:Object = JSON.decode(command);
			} catch (error:Error) {
				Logger.ERROR("JSON parser : " + error.message);
			}
			
			if (result) {
				if (result.error) {
					// VK API
					if (result.error.error_msg) {
						Logger.ERROR("API ERROR : " + result.error.error_msg);
					}
				} else {
					if (lastRequestCommand == "getProfiles") {
						FlexGlobals.topLevelApplication.friendPanel.setData(result.response);
					}
				}
				
			}
		}
		
	}
}