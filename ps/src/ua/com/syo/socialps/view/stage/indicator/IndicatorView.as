/**
 * IndicatorView.as	 	
 * @author				Krivosheya Sergey
 * @link    			http://www.syo.com.ua/
 * @link    			mailto: syopic@gmail.com
 */
package ua.com.syo.socialps.view.stage.indicator {
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	public class IndicatorView extends Sprite {
		
		/**
		 * Singletone
		 */
		private static var _instance:IndicatorView;
		
		public static function get instance():IndicatorView {
			
			if (_instance == null) {
				_instance = new IndicatorView();
			}
			return _instance;
		}
		
		private var indicatorsDict:Dictionary = new Dictionary(true);
		
		public function addIndicator(id:String, target:Sprite):void {
			var ind:Indicator = new Indicator(target);
			indicatorsDict[id] = ind;
			addChild(ind);
		}
	}
}