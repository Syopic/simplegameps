/**
 * UIManager.as		main view singleton class
 * @author			Krivosheya Sergey
 * @link    		http://www.syo.com.ua/
 * @link    		mailto: syopic@gmail.com
 */
package ua.com.syo.socialps.view {
	import flash.display.Sprite;
	
	import ua.com.syo.socialps.view.stage.StageView;
	
	public class UIManager extends Sprite {
		/**
		 * Singleton
		 */
		private static var _instance:UIManager;
		
		public static function get instance():UIManager {
			
			if (_instance == null) {
				_instance = new UIManager();
			}
			return _instance;
		}
		
		public function init():void {
			StageView.instance.init();
			addChild(StageView.instance);
		}
		
	}
}