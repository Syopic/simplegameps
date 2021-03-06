/**
 * StageView.as	        gameplay view component aggregator
 * @author				Krivosheya Sergey
 * @link    			http://www.syo.com.ua/
 * @link    			mailto: syopic@gmail.com
 */
package ua.com.syo.socialps.view.stage {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import ua.com.syo.socialps.controller.Controller;
	import ua.com.syo.socialps.data.Globals;
	import ua.com.syo.socialps.data.LibraryData;
	import ua.com.syo.socialps.data.StageData;
	import ua.com.syo.socialps.model.Model;
	import ua.com.syo.socialps.view.UIManager;
	import ua.com.syo.socialps.view.stage.indicator.IndicatorView;
	import ua.kiev.djm.core.log.Logger;

	public class StageView extends Sprite {

		/**
		 * Singletone
		 */
		private static var _instance:StageView;

		public static function get instance():StageView {

			if (_instance == null) {
				_instance = new StageView();
			}
			return _instance;
		}

		// unit view
		public var mainPS:SkaterView;

		public var psArray:Array;

		// containers
		private var bgContainer:Sprite;
		private var levelContainer:Sprite;
		private var psContainer:Sprite;
		private var bonusContainer:Sprite;
		private var objectsContainer:Sprite;
		private var markContainer:Sprite;

		// stack for looping
		private var waterMarkStack:Array;
		[ArrayElementType("Bonus")]
		private var bonusStack:Array;

		private var defaultScale:Number = 1;
		private var toScale:Number = 0.5;
		private var markIncr:int = 0;
		
		private var isJolting:int = 0;

		/**
		 * init
		 */
		public function init():void {
			initBG();
			initMarkers();
			initLevel();
			initPS();
			initBonuses();
			initObjects();
		}

		public function run():void {
			initLevel();
			initBonuses();
			scaleX = scaleY = defaultScale;
			Model.instance.score = 0;
			markContainer.x = bonusContainer.x = psContainer.x = levelContainer.x = objectsContainer.x = bgContainer.x = 0;
			markContainer.y = bonusContainer.y = psContainer.y = levelContainer.y = objectsContainer.y = bgContainer.y = 0;
			mainPS.init(Globals.stageW / 2, Globals.stageH / 2);
			toScale = 0.5;
			Controller.instance.isRunning = true;
			initObjects();
		}

		public function correctEnding():void {
			Controller.instance.isRunning = false;
			isJolting = 10;
		}

		/**
		 * mouse down event from main stage
		 */
		public function userMouseDown(isKey:Boolean = false, isLeft:Boolean = false):void {
			mainPS.isRotation = true;
			mainPS.mouseDownReaction(isKey, isLeft);
		}

		/**
		 * mouse up event from main stage
		 */
		public function userMouseUp():void {
			mainPS.isRotation = false;
		}

		/**
		 * event from main stage
		 */
		public function mouseWheelHandler(event:MouseEvent):void {
			if (event.delta > 0) {
				toScale = scaleX + 0.1;
			} else {
				toScale = scaleX - 0.1;
			}
		}


		/**
		 * init background
		 */
		private function initBG():void {
			bgContainer = new Sprite();
			addChild(bgContainer);
		}

		/**
		 * init markers
		 */
		private function initMarkers():void {
			markContainer = new Sprite();
			addChild(markContainer);

			waterMarkStack = new Array();
			for (var j:int = 0; j < 20; j++) {
				var wm:WaterMarkView = new WaterMarkView();
				waterMarkStack.push(wm);
				markContainer.addChild(wm);
			}
		}

		/**
		 * init pond skaters
		 */
		private function initPS():void {
			psContainer = new Sprite();
			addChild(psContainer);

			psArray = new Array();

			mainPS = new SkaterView(Globals.stageW / 2, Globals.stageH / 2);
			mainPS.addEventListener(Event.ENTER_FRAME, moveController);
			psContainer.addChild(mainPS);

			psArray.push(mainPS);

		/*for (var i:int = 0; i < 10; i++) {
		   var tps:PondSkaterView = new PondSkaterView(Math.random()*2000, Math.random()*2000);
		   tps.speed = Math.random()*30;
		   psContainer.addChild(tps);
		   tps.alpha = 0.5;
		   psArray.push(tps);
		 }*/
		}

		/**
		 * init level terrain
		 */
		private function initLevel():void {
			if (levelContainer && contains(levelContainer)) {
				while (levelContainer.numChildren > 0) {
					levelContainer.removeChildAt(0);
				}
			} else {
				levelContainer = new Sprite();
				addChild(levelContainer);
			}
			
			var levSprite:Sprite;
			switch (Globals.currentLevelNum) {
				case 1: 
					levSprite = new LibraryData.TestLevelC();
					break;
				case 2: 
					levSprite = new LibraryData.TestLevel2C();
					break;
			}
			levelContainer.addChild(levSprite);
			levelContainer.scaleX = levelContainer.scaleY = 10;
		}

		/**
		 * init bonus container
		 */
		private function initBonuses():void {
			if (bonusContainer && this.contains(bonusContainer)) {
				for (var j:int = 0; j < bonusStack.length; j++) {
					var element:Bonus = bonusStack[j] as Bonus;
					element.destroy();

				}
				while (bonusContainer.numChildren > 0) {
					bonusContainer.removeChildAt(0);
				}
			} else {
				bonusContainer = new Sprite();
				addChild(bonusContainer);
			}
			bonusStack = new Array();
			bonusCounter = 0;
			showNextBonus();
		/*bonusStack = new Array();

		   // MOCK
		   for (var i:int = 0; i < 10; i++) {
		   var bonus:Bonus = new Bonus("t" + i);
		   bonusContainer.addChild(bonus);
		   bonus.x = Math.random() * 2000 - 1000;
		   bonus.y = Math.random() * 2000 - 1000;
		   bonusStack.push(bonus);
		 }*/
		}
		
		private var bonusCounter:int = 0;

		private function showNextBonus():void {
			/*for (var j:int = 0; j < bonusStack.length; j++) {
				var element:Bonus = bonusStack[j] as Bonus;
				element.destroy();
			}
			while (bonusContainer.numChildren > 0) {
				bonusContainer.removeChildAt(0);
			}*/
			
			bonusStack = new Array();
			//Logger.DEBUG(bonusCounter);
			if (bonusCounter < StageData.bonusPosArray.length) {
				var bonus:Bonus = new Bonus("t" + bonusCounter);
				bonusContainer.addChild(bonus);
				bonus.x = (StageData.bonusPosArray[bonusCounter] as Point).x;
				bonus.y = (StageData.bonusPosArray[bonusCounter] as Point).y;
				bonusStack.push(bonus);
				GUIContainer.instance.updateBonuses(bonusCounter, StageData.bonusPosArray.length);
				bonusCounter++;
			}
		}
			
		private function initObjects():void {
			if (objectsContainer && contains(objectsContainer)) {
				while (objectsContainer.numChildren > 0) {
					objectsContainer.removeChildAt(0);
				}
			} else {
				objectsContainer = new Sprite();
				addChild(objectsContainer);
			}
			
			var objSprite:Sprite;
			switch (Globals.currentLevelNum) {
				case 1: 
					objSprite = new LibraryData.LevelObjectsC();
					break;
				case 2: 
					objSprite = new LibraryData.LevelObjects2C();
					break;
			}
			objectsContainer.addChild(objSprite);
			objectsContainer.scaleX = objectsContainer.scaleY = 10;
		}

		/**
		 * event from main stage
		 */
		private function moveController(event:Event):void {
			if (Controller.instance.isRunning) {
				for (var i:int = 0; i < psArray.length; i++) {
					var tps:SkaterView = psArray[i] as SkaterView;
					tps.move();

					if (mainPS == tps) {
						if (tps.isRotation) {
							StageView.instance.showWaterMark(tps);
						}
						if (Math.random() * 10 > 5) {
							StageView.instance.showWaterMark(tps);
						}

						// hit test
						var p:Point = localToGlobal(new Point(tps.x, tps.y));
						if (levelContainer.getChildAt(0)["collision"].hitTestPoint(p.x, p.y, true)) {
							correctEnding();
						}

						for (var j:int = 0; j < bonusStack.length; j++) {
							if ((bonusStack[j] as Bonus).hitTestPoint(p.x, p.y, true)) {
								(bonusStack[j] as Bonus).destroy();
								bonusContainer.removeChild(bonusStack[j] as Bonus);
								mainPS.slow();
								showNextBonus();
							}
						}


						bonusContainer.x = levelContainer.x = objectsContainer.x = markContainer.x -= tps.dx;
						bonusContainer.y = levelContainer.y = objectsContainer.y = markContainer.y -= tps.dy;

						scaleY = scaleX += (toScale - scaleX) / 20;

						x += Globals.stageW / 2 - p.x;
						y += Globals.stageH / 2 - p.y;
						Model.instance.score++;
						UIManager.instance.guiContainer.updateScore(Model.instance.score);
							//toScale = 1 - mainPS.speed / 70;
					} else {
						tps.x += tps.dx - mainPS.dx;
						tps.y += tps.dy - mainPS.dy;
					}
				}
			}
			if (isJolting >= 0) {
				isJolting --;
				this.x += Math.random() * mainPS.speed / 2 - mainPS.speed / 4;
				this.y += Math.random() * mainPS.speed / 2 - mainPS.speed / 4;
				if (isJolting == 0) {
					Controller.instance.endGameCall();
				}
			}
		}


		/**
		 * showWaterMark
		 */
		private function showWaterMark(psInst:SkaterView):void {
			// stack looping
			var wm:WaterMarkView = waterMarkStack[markIncr];
			if (wm.isMarker) {
				wm.x = -markContainer.x + psInst.x + Math.random() * 2000 - 1000;
				wm.y = -markContainer.y + psInst.y + Math.random() * 2000 - 1000;
			} else {
				wm.rotation = Math.random() * 360;
				wm.x = -markContainer.x + psInst.x + Math.random() * 20 - 10;
				wm.y = -markContainer.y + psInst.y + Math.random() * 20 - 10;
			}
			wm.show();
			if (++markIncr >= waterMarkStack.length) {
				markIncr = 0;
			}
			wm = null;
		}
		
	}
}