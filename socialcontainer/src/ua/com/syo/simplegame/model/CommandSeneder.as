package ua.com.syo.simplegame.model {
	import ua.com.syo.simplegame.model.net.social.VKData;
	import ua.kiev.djm.core.log.Logger;
	import ua.kiev.djm.core.net.ServerProxy;

	public class CommandSeneder {

		public static function send(commandName:String, params:Object = null):void {
			if (!params) {
				params = {};
			}

			params.cmd = commandName;

			params.uid = VKData.flashVars["user_id"];
			/*params.app_id = VKData.flashVars["user_id"];
			params.auth_key = FlashVars.authKey;*/

			ServerProxy.instance.sendCommand(params, "main");
		}

	}
}