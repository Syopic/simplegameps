package ua.com.syo.socialps.view.stage {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;

	import ua.com.syo.socialps.data.Globals;
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
		private var slowTF:TextField;
		private var speedTF:TextField;

		private var directArrow:Sprite;

		public function init():void {
			scoreBar = new LibraryData.ScoreBarC();
			directArrow = new LibraryData.DirectArrowC();
			scoreTF = scoreBar["scoreTF"];
			slowTF = scoreBar["slowTF"];
			speedTF = scoreBar["speedTF"];
			addChild(scoreBar);
			addChild(directArrow);

			updateScore(0);
			updateSpeed(0);
			slowTF.text = "/";
			directArrow.alpha = 0;
		}

		public function updateScore(value:int):void {
			scoreTF.text = value.toString();
		}
		
		public function updateBonuses(value:int, maxValue:int):void {
			if (slowTF) {
				slowTF.text = value + "/" + maxValue;
			}
		}
		
		public function updateSpeed(value:int):void {
			speedTF.text = value.toString();
		}
		

		public function showDirectArrow(isLeft:Boolean = true):void {
			directArrow.alpha = 1;
			if (isLeft) {
				directArrow.scaleX = 1;
				directArrow.scaleX = 1;
				directArrow.x = Globals.stageW / 2 - 100;
				directArrow.y = Globals.stageH / 2 + 200;
			} else {
				directArrow.scaleX = -1;
				directArrow.x = Globals.stageW / 2 + 100;
				directArrow.y = Globals.stageH / 2 + 200;
			}

			directArrow.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}

		private function enterFrameHandler(event:Event):void {
			directArrow.alpha -= 0.01;
			if (directArrow.alpha <= 0.2) {
				directArrow.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			}
		}
	}
}