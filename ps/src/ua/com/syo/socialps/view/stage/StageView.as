/**
 * StageViewManager.as	
 * @author				Krivosheya Sergey
 * @link    			http://www.syo.com.ua/
 * @link    			mailto: syopic@gmail.com
 */
package ua.com.syo.socialps.view.stage {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import ua.com.syo.socialps.data.Globals;
	import ua.com.syo.socialps.data.LibraryData;
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
		
		
		private var bonusContainer:Sprite;
		
		public var ps:PondSkaterView;
		private var bgContainer:Sprite;
		private var levelContainer:Sprite;
		private var markContainer:Sprite;
		
		private var objectsContainer:Sprite;
		
		private var waterMarkStack:Array;
		
		
		/**
		 * init
		 */
		public function init():void {
			initBG();
			initPS(Globals.stageW / 2, Globals.stageH / 2);
			//initPS(Globals.stageW -100, Globals.stageH / 2);
			
			levelContainer = new LibraryData.TestLevelC();
			addChild(levelContainer);
			levelContainer.scaleX = levelContainer.scaleY = 8;
			
			bonusContainer = new Sprite();
			addChild(bonusContainer);
			
			for (var i:int = 0; i < 1; i++) {
				var slower:Sprite = new LibraryData.SlowerC();
				bonusContainer.addChild(slower);
				/*slower.x = Math.random()* 200 - 100;
				slower.y = Math.random()* 200 - 100;*/
				slower.x = 0;
				slower.y = 0;
				
				IndicatorView.instance.addIndicator("t"+i, slower);
			}
			
			waterMarkStack = new Array();
			for (var j:int = 0; j < 60; j++) {
				var wm:WaterMarkView = new WaterMarkView();
				waterMarkStack.push(wm);
				markContainer.addChild(wm);
			}
			
			//
			addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
		}
		
		public var zdx:Number;
		public var zdy:Number; 
		private function mouseWheelHandler(event:MouseEvent):void {
			var dw:Number = Number(event.delta)/100;
			if (event.delta > 0) {
				dw = 0.01;
			} else {
				dw = -0.01;
			}
			scaleX += dw;
			scaleY += dw;
			//x = Globals.stageW / 2 - width / 2;
			//y = Globals.stageH / 2 - height / 2;
			var p:Point = localToGlobal(new Point(ps.x, ps.y));
			zdx =  Globals.stageW / 2 - p.x;
			zdy =  Globals.stageH / 2 - p.y;
			
			x += zdx;
			y += zdy;
			
			Logger.DEBUG("width: " + p);
		}
		
		private function centeredPS():void {
			
		}
		
		private var incr:int = 0;
		public function showWaterMark():void {
			var wm:WaterMarkView = waterMarkStack[incr];
			if (wm.isMarker) {
				wm.x = -markContainer.x + ps.x + Math.random()*2000 - 1000;
				wm.y = -markContainer.y + ps.y + Math.random()*2000 - 1000;
			} else {
				wm.x = -markContainer.x + ps.x + Math.random()*20 - 10;
				wm.y = -markContainer.y + ps.y + Math.random()*20 - 10;
			}
			wm.show();
			incr ++;
			if (incr >= waterMarkStack.length){
				incr = 0;
			} 
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
			bgContainer.graphics.drawRect(0 , 0, Globals.stageW, Globals.stageH);
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
			
			/*Tweener.addTween(bonusContainer, {x:bonusContainer.x - dx, y:bonusContainer.x - dy, time:1, transition:"linear"});
			Tweener.addTween(levelContainer, {x:levelContainer.x - dx, y:levelContainer.x - dy, time:1, transition:"linear"});
			Tweener.addTween(markContainer, {x:levelContainer.x - dx, y:levelContainer.x - dy, time:1, transition:"linear"});*/
			
			
			/*if (Math.round(dx) < 2) {
				x += -x/50 / scaleX;
			} else {
				x = x - dx/5/ scaleX - x/80/ scaleX;
			}
			
			if (Math.round(dy) < 2) {
				y += -y/50/ scaleX;
			} else {
				y = y - dy/5/ scaleX - y/80/ scaleX;
			}
			*/
			/*var isMoveX:Boolean = true;
			var isMoveY:Boolean = true;
			var vp:int = 200;
			if (p.x < vp || p.x > Globals.stageW - vp) {
				isMoveX = false
			}
			if (p.y < vp || p.y > Globals.stageH - vp) {
				isMoveY = false
			}
			
			if (isMoveX) {
				x = x - (dx/2) * (scaleX);
			} else {
				x = x + (dx/2) * (scaleX);
			}			
			if (isMoveY) {
				y = y - (dy/2) * (scaleY);
			} else {
				y = y + (dy/2) * (scaleY);
			}			*/
			
			
			/*levelContainer.x = levelContainer.x - dx/2;
			levelContainer.y = levelContainer.y - dy/2;*/
			
			bonusContainer.x = levelContainer.x = markContainer.x -= dx;
			bonusContainer.y = levelContainer.y = markContainer.y -= dy;
		}
		
		
		public function movePS():void {
			//ps.x += 10;
		}

	}
}