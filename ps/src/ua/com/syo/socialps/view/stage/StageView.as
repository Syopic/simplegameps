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
	
	import ua.com.syo.socialps.data.Globals;
	import ua.com.syo.socialps.data.LibraryData;
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
		private var bonusContainer:Sprite;
		private var objectsContainer:Sprite;
		private var markContainer:Sprite;
		
		// stack for looping
		private var waterMarkStack:Array;
		
		private var toScale:Number = 1;
		private var markIncr:int = 0;
		
		/**
		 * init
		 */
		public function init():void {
			initBG();
			initMarkers();
			///////////
			
			psArray = new Array();
			
			mainPS = initPS(Globals.stageW / 2, Globals.stageH / 2);
			mainPS.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			
			psArray.push(mainPS);
			
			for (var i:int = 0; i < 10; i++) {
				var tps:PondSkaterView = initPS(Math.random()*2000, Math.random()*2000);
				tps.speed = Math.random()*20;
				tps.alpha = 0.5;
				psArray.push(tps);
			}
			
			//////////////
			initLevel();
			initBonuses();
		}
		
		/**
		 * mouse down event from main stage
		 */
		public function userMouseDown():void {
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
			if (event.delta < 0) {
				toScale = scaleX + 0.1;
			} else {
				toScale = scaleX - 0.1;
			}
		}
		
		private function enterFrameHandler(event:Event):void {
			for (var i:int = 0; i < psArray.length; i++) {
				var tps:PondSkaterView = psArray[i] as PondSkaterView;
				tps.move();
				StageView.instance.showWaterMark(tps);
				
				if (mainPS == tps) {
					
					var p:Point = localToGlobal(new Point(tps.x, tps.y));
					if (levelContainer["collision"].hitTestPoint(p.x, p.y, true)) {
						levelContainer.alpha = 0.3;
					} else {
						levelContainer.alpha = 1;
					}
					
					bonusContainer.x = levelContainer.x = markContainer.x -= tps.dx;
					bonusContainer.y = levelContainer.y = markContainer.y -= tps.dy;
					
					scaleY = scaleX += (toScale - scaleX) / 20;
					
					x += Globals.stageW / 2 - p.x;
					y += Globals.stageH / 2 - p.y;
				} else {
					tps.x += tps.dx;
					tps.y += tps.dy;
					
					tps.x -= mainPS.dx;
					tps.y -= mainPS.dy;
					
				}
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
			bgContainer.graphics.drawRect(0 , 0, Globals.stageW, Globals.stageH);
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
		 * init pond skater
		 * @param xPos, yPos - position on view port
		 */
		private function initPS(xPos:int, yPos:int):PondSkaterView {
			var tps:PondSkaterView = new PondSkaterView();
			addChild(tps);
			tps.x = xPos;
			tps.y = yPos;
			return tps;
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
			
			// MOCK
			for (var i:int = 0; i < 10; i++) {
				var slower:Sprite = new LibraryData.SlowerC();
				bonusContainer.addChild(slower);
				slower.x = Math.random()* 2000 - 1000;
				slower.y = Math.random()* 2000 - 1000;
				
				IndicatorView.instance.addIndicator("t"+i, slower);
			}
		}
		
		
		/**
		 * showWaterMark
		 */
		private function showWaterMark(psInst:PondSkaterView):void {
			// stack looping
			var wm:WaterMarkView = waterMarkStack[markIncr];
			if (wm.isMarker) {
				wm.x = -markContainer.x + psInst.x + Math.random()*2000 - 1000;
				wm.y = -markContainer.y + psInst.y + Math.random()*2000 - 1000;
			} else {
				wm.x = -markContainer.x + psInst.x + Math.random()*20 - 10;
				wm.y = -markContainer.y + psInst.y + Math.random()*20 - 10;
			}
			wm.show();
			if (++ markIncr >= waterMarkStack.length){
				markIncr = 0;
			} 
			wm = null;
		}
		
		
		public function movePS():void {
			//ps.x += 10;
		}

	}
}