/**
 * StageViewManager.as	
 * @author				Krivosheya Sergey
 * @link    			http://www.syo.com.ua/
 * @link    			mailto: syopic@gmail.com
 */
package ua.com.syo.socialps.view.stage {
	import flash.display.Sprite;
	import flash.events.Event;
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
		
		
		public var ps:PondSkaterView;
		private var bgContainer:Sprite;
		private var levelContainer:Sprite;
		private var markContainer:Sprite;
		
		private var objectsContainer:Sprite;
		private var bonusContainer:Sprite;
		
		public var slower:Sprite;
		
		/**
		 * init
		 */
		public function init():void {
			initBG();
			initPS(Globals.stageW / 2, Globals.stageH / 2);
			
			levelContainer = new LibraryData.TestLevelC();
			addChild(levelContainer);
			levelContainer.scaleX = levelContainer.scaleY = 8;
			
			bonusContainer = new Sprite();
			addChild(bonusContainer);
			
			slower = new LibraryData.SlowerC();
			bonusContainer.addChild(slower);
			/*slower.x = 500;
			slower.y = 300;*/
			
			addChild(IndicatorView.instance);
			IndicatorView.instance.addIndicator("t", slower);
			
			
		}
		
		public function showWaterMark():void {
			var wm:WaterMarkView = new WaterMarkView();
			if (wm.isMarker) {
				wm.x = -markContainer.x + ps.x + Math.random()*1000 - 500;
				wm.y = -markContainer.y + ps.y + Math.random()*1000 - 500;
			} else {
				wm.x = -markContainer.x + ps.x + Math.random()*10 - 5;
				wm.y = -markContainer.y + ps.y + Math.random()*10 - 5;
			}
			wm.addEventListener(Event.COMPLETE, markCompleteHandler);
			markContainer.addChild(wm);
			wm = null;
		}
		
		private function markCompleteHandler(event:Event):void {
			var wm:WaterMarkView = event.currentTarget as WaterMarkView;
			wm.removeEventListener(Event.COMPLETE, markCompleteHandler);
			markContainer.removeChild(wm);
			wm = null;
		}
		
		public function initPS(xPos:int, yPos:int):void {
			ps = new PondSkaterView();
			addChild(ps);
			ps.x = xPos;
			ps.y = yPos;
		}
		
		public function initBG():void {
			bgContainer = new Sprite();
			addChild(bgContainer);
			
			bgContainer.graphics.beginFill(0x00789F);
			bgContainer.graphics.drawRect(0,0, Globals.stageW, Globals.stageH);
			bgContainer.graphics.endFill();
			
			markContainer = new Sprite();
			addChild(markContainer);
			
			
		}
		
		public function moveStage(dx:Number, dy:Number):void {
			var p:Point = localToGlobal(new Point(ps.x, ps.y));
			if (levelContainer.hitTestPoint(p.x, p.y, true)) {
				levelContainer.alpha = 0.3;
				if (ps.speed > 0) {
					//ps.speed = 0;
					//ps.dS = 0.5;
				}
			} else {
				levelContainer.alpha = 1;
			}
			bonusContainer.x = levelContainer.x = markContainer.x -= dx;
			bonusContainer.y = levelContainer.y = markContainer.y -= dy;
		}
		
		
		public function movePS():void {
			//ps.x += 10;
		}

	}
}