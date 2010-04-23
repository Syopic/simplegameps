package ua.com.syo.socialps.model {
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.system.Security;

	public class Model extends EventDispatcher {
		/**
		 * Singletone
		 */
		private static var _instance:Model;
		
		public static function get instance():Model {
			
			if (_instance == null) {
				_instance = new Model();
			}
			return _instance;
		}
		
		public var score:int = 0;
		
		public function init():void {
			checkPolicy();
		}
		
		private function checkPolicy():void {
			Security.loadPolicyFile("http://89.252.12.14:2080/crossdomain.xml");
			
			Security.loadPolicyFile("http://vkontakte.ru/crossdomain.xml");
			Security.loadPolicyFile("http://cs9458.vkontakte.ru/crossdomain.xml");
		}
	}
}