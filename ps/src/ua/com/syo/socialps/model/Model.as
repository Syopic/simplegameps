package ua.com.syo.socialps.model {
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

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
	}
}