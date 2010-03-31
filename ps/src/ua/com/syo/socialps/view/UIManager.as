/**
 * UIManager.as		main view singleton class
 * @author			Krivosheya Sergey
 * @link    		http://www.syo.com.ua/
 * @link    		mailto: syopic@gmail.com
 */
package ua.com.syo.socialps.view {
	import flash.display.Sprite;
	
	import ua.com.syo.socialps.data.LibraryData;
	import ua.com.syo.socialps.view.stage.GUIContainer;
	import ua.com.syo.socialps.view.stage.StageView;
	import ua.com.syo.socialps.view.stage.indicator.IndicatorView;
	
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
		
		public var guiContainer:GUIContainer;
		
		public function init():void {
			StageView.instance.init();
			GUIContainer.instance.init();
			guiContainer = GUIContainer.instance;
			
			addChild(StageView.instance);
			addChild(IndicatorView.instance);
			addChild(GUIContainer.instance);
		}
		
	}
}