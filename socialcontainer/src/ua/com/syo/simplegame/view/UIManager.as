package ua.com.syo.simplegame.view {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	import mx.core.FlexGlobals;
	import mx.managers.PopUpManager;
	
	import ua.com.syo.simplegame.view.popups.BankPopup;


	
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
		
		private var popups:Dictionary = new Dictionary();
		
		private var bankPopup : BankPopup = new BankPopup();
		
		public function init():void {
			//init popups
			popups[bankPopup.name] = bankPopup; 
		}
		
		/**
		 * show modal popup by id
		 * @param popupName - name id in popups Dictionary
		 */
		public function showPopup(popupName:String):void{
			if (popups[popupName]) {
				PopUpManager.addPopUp(popups[popupName], FlexGlobals.topLevelApplication as DisplayObject, true);
				PopUpManager.centerPopUp(popups[popupName]);
			}
		}
		
	}
}