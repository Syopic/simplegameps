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
	import ua.com.syo.socialps.model.Model;
	import ua.com.syo.socialps.view.UIManager;
	import ua.com.syo.socialps.view.stage.indicator.IndicatorView;

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
		public var mainPS:PondSkaterView;

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

		private var toScale:Number = 0.5;
		private var markIncr:int = 0;

		/**
		 * init
		 */
		public function init():void {
			initBG();
			initMarkers();
			initPS();
			initBonuses();
			initLevel();
		}
		
		public function reInit():void {
			markContainer.x = bonusContainer.x = psContainer.x = levelContainer.x = bgContainer.x = 0;
			markContainer.y = bonusContainer.y = psContainer.y = levelContainer.y = bgContainer.y = 0;
		}

		/**
		 * mouse down event from main stage
		 */
		public function userMouseDown():void {
			if (!Controller.instance.isRunning) {
				Controller.instance.isRunning = true;
				mainPS.init(Globals.stageW / 2, Globals.stageH / 2);
				Model.instance.score = 0;
				reInit();
			}
			mainPS.isRotation = true;
			mainPS.mouseDownReaction();
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
			// draw bg color rectangle
			bgContainer.graphics.beginFill(0x00789F);
			bgContainer.graphics.drawRect(0, 0, Globals.stageW, Globals.stageH);
			bgContainer.graphics.endFill();
		}

		/**
		 * init markers
		 */
		private function initMarkers():void {
			markContainer = new Sprite();
			addChild(markContainer);

			waterMarkStack = new Array();
			for (var j:int = 0; j < 140; j++) {
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

			mainPS = new PondSkaterView(Globals.stageW / 2, Globals.stageH / 2);
			psContainer.addChild(mainPS);
			mainPS.addEventListener(Event.ENTER_FRAME, moveController);

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
			levelContainer = new LibraryData.TestLevelC();
			addChild(levelContainer);
			levelContainer.scaleX = levelContainer.scaleY = 10;
		}

		/**
		 * init bonus container
		 */
		private function initBonuses():void {
			bonusContainer = new Sprite();
			addChild(bonusContainer);
			
			bonusStack = new Array();
			
			// MOCK
			for (var i:int = 0; i < 10; i++) {
				var bonus:Bonus = new Bonus("t" + i);
				bonusContainer.addChild(bonus);
				bonus.x = Math.random() * 2000 - 1000;
				bonus.y = Math.random() * 2000 - 1000;
				bonusStack.push(bonus);
			}
		}

		/**
		 * event from main stage
		 */
		private function moveController(event:Event):void {
			if (Controller.instance.isRunning) {
				for (var i:int = 0; i < psArray.length; i++) {
					var tps:PondSkaterView = psArray[i] as PondSkaterView;
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
						if (levelContainer["collision"].hitTestPoint(p.x, p.y, true)) {
							Controller.instance.isRunning = false;
						} else {
							levelContainer.alpha = 1;
						}
						
						for (var j:int = 0; j < bonusStack.length; j++) {
							if ((bonusStack[j] as Bonus).hitTestPoint(p.x, p.y, true)) {
								(bonusStack[j] as Bonus).destroy();
								bonusContainer.removeChild(bonusStack[j] as Bonus);
								mainPS.slow();
							}
						}
						

						bonusContainer.x = levelContainer.x = markContainer.x -= tps.dx;
						bonusContainer.y = levelContainer.y = markContainer.y -= tps.dy;

						scaleY = scaleX += (toScale - scaleX) / 20;

						x += Globals.stageW / 2 - p.x;
						y += Globals.stageH / 2 - p.y;
						Model.instance.score++;
						UIManager.instance.guiContainer.updateScore(Model.instance.score);
							//toScale = 1 - mainPS.speed / 100;
					} else {
						tps.x += tps.dx - mainPS.dx;
						tps.y += tps.dy - mainPS.dy;
					}
				}
			}
		}


		/**
		 * showWaterMark
		 */
		private function showWaterMark(psInst:PondSkaterView):void {
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


		public function movePS():void {
			//ps.x += 10;
		}

	}
}