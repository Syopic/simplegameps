/**
 * StageViewManager.as	
 * @author				Krivosheya Sergey
 * @link    			http://www.syo.com.ua/
 * @link    			mailto: syopic@gmail.com
 */
package ua.com.syo.socialps.view.stage {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
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
		private var markContainer:Sprite;
		private var objectsContainer:Sprite;
		
		/**
		 * init
		 */
		public function init():void {
			initBG();
			initPS(355, 355);
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
			bgContainer.graphics.drawRect(0,0,730,730);
			bgContainer.graphics.endFill();
			
			markContainer = new Sprite();
			addChild(markContainer);
		}
		
		public function moveStage(dx:Number, dy:Number):void {
			markContainer.x -= dx;
			markContainer.y -= dy;
		}
		
		
		public function movePS():void {
			ps.x += 10;
		}

	}
}