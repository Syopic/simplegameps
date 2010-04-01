/**
 * Controller.as			main controller singleton
 * @author					Krivosheya Sergey
 * @link    				http://www.syo.com.ua/
 * @link    				mailto: syopic@gmail.com
 */
package ua.com.syo.socialps.controller {
	import flash.events.EventDispatcher;
	
	import ua.com.syo.socialps.view.UIManager;
	
	public class Controller extends EventDispatcher	{
		/**
		 * Singleton
		 */
		private static var _instance:Controller;
		
		public static function get instance():Controller {
			
			if (_instance == null) {
				_instance = new Controller();
			}
			return _instance;
		}
		
		public var isRunning:Boolean = false;
		
		/**
		 * init
		 */
		public function init():void {
			UIManager.instance.init();
		}
		
		public function runGame():void {
		}
		
	}
}