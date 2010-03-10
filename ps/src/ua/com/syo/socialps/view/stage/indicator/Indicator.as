package ua.com.syo.socialps.view.stage.indicator {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	import ua.com.syo.socialps.data.Globals;
	import ua.com.syo.socialps.data.LibraryData;
	import ua.kiev.djm.core.log.Logger;
	
	public class Indicator extends Sprite {
		
		private var container:Sprite;
		private var targetObj:Sprite;
		private var halfW:Number;
		private var halfH:Number;
		
		public function Indicator(target:Sprite)	{
			targetObj = target;
			container = new LibraryData.IndicatorC();
			addChild(container);
			
			halfW = Globals.stageW / 2;
			halfH = Globals.stageH / 2;
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		private function enterFrameHandler(event:Event):void {
			var p:Point = targetObj.localToGlobal(new Point(-halfW, -halfH));
			
			var dist:Number = Point.distance(new Point(0, 0), p);
			var dx:Number = p.x;
			var dy:Number = p.y;
			
			
			
			var ky:Number = dx / (dy / halfW);
			var kx:Number = dy / (dx / halfH);
			
			
			//Logger.DEBUG("halfW: " + halfW); 
			//Logger.DEBUG("halfH: " + halfH);
			
			if (Math.abs(dx) < halfW && Math.abs(dy) < halfH) {
				visible = false;
			} else {
				visible = true;
				if (dy < 0 && dx < 0) {
					if (Math.abs(dx) > Math.abs(dy)) {
						this.x = 0;
						this.y = halfH - kx;
					} else {
						this.y = 0;
						this.x = halfW - ky;
					}
				} else if (dy < 0 && dx > 0) {
					if (Math.abs(dx) > Math.abs(dy)) {
						this.x = Globals.stageW;
						this.y = halfH + kx;
					} else {
						this.y = 0;
						this.x = halfW - ky;
					}
				} else if (dy > 0 && dx > 0) {
					if (Math.abs(dx) > Math.abs(dy)) {
						this.x = Globals.stageW;
						this.y = halfH + kx;
					} else {
						this.y = Globals.stageH;
						this.x = halfW + ky;
					}
				} else if (dy > 0 && dx < 0) {
					if (Math.abs(dx) > Math.abs(dy)) {
						this.x = 0;
						this.y = halfH - kx;
					} else {
						this.y = Globals.stageH;
						this.x = halfW + ky;
					}
				}
			}
		}
	}
}