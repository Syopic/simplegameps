package ua.com.syo.socialps.view.stage {
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import ua.com.syo.socialps.data.LibraryData;

	public class GUIContainer extends Sprite {
		
		/**
		 * Singletone
		 */
		private static var _instance:GUIContainer;
		
		public static function get instance():GUIContainer {
			
			if (_instance == null) {
				_instance = new GUIContainer();
			}
			return _instance;
		}
		
		private var scoreBar:Sprite;
		private var scoreTF:TextField;
		
		public function init():void {
			scoreBar = new LibraryData.ScoreBarC();
			scoreTF = scoreBar["scoreTF"];
			addChild(scoreBar);
			updateScore(323);
		}
		
		public function updateScore(value:int):void {
			scoreTF.text = "score: " + value;
		}
	}
}