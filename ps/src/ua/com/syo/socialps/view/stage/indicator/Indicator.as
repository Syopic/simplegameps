/**
 * Indicator.as	 	
 * @author				Krivosheya Sergey
 * @link    			http://www.syo.com.ua/
 * @link    			mailto: syopic@gmail.com
 */
package ua.com.syo.socialps.view.stage.indicator {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	import ua.com.syo.socialps.data.Globals;
	import ua.com.syo.socialps.data.LibraryData;
	import ua.com.syo.socialps.view.UIManager;
	import ua.com.syo.socialps.view.stage.StageView;
	
	public class Indicator extends Sprite {
		
		private var container:Sprite;
		private var targetObj:Sprite;
		private var halfW:Number;
		private var halfH:Number;
		
		private var dxTody:Number;
		
		public function Indicator(target:Sprite)	{
			targetObj = target;
			container = new LibraryData.IndicatorC();
			addChild(container);
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		private function enterFrameHandler(event:Event):void {
			// TODO
			halfW = Globals.stageW / 2;
			halfH = Globals.stageH / 2;
			
			dxTody = Globals.stageW / Globals.stageH;
			
			var p:Point = targetObj.localToGlobal(new Point(-halfW, -halfH));
			var dx:Number = p.x + halfW * StageView.instance.scaleX - halfW;
			var dy:Number = p.y + halfH * StageView.instance.scaleY - halfH;
			
			
			var ky:Number = dx / ((dy * dxTody) / halfW);
			var kx:Number = (dy * dxTody) / (dx / halfH);
			
			
			if (Math.abs(dx) < halfW && Math.abs(dy) < halfH) {
				visible = false;
			} else {
				visible = true;
				if (dy < 0 && dx < 0) {
					if (Math.abs(dx) > Math.abs(dy * dxTody)) {
						this.x = 0;
						this.y = halfH - kx;
					} else {
						this.y = 0;
						this.x = halfW - ky;
					}
				} else if (dy < 0 && dx > 0) {
					if (Math.abs(dx) > Math.abs(dy * dxTody)) {
						this.x = Globals.stageW;
						this.y = halfH + kx;
					} else {
						this.y = 0;
						this.x = halfW - ky;
					}
				} else if (dy > 0 && dx > 0) {
					if (Math.abs(dx) > Math.abs(dy * dxTody)) {
						this.x = Globals.stageW;
						this.y = halfH + kx;
					} else {
						this.y = Globals.stageH;
						this.x = halfW + ky;
					}
				} else if (dy > 0 && dx < 0) {
					if (Math.abs(dx) > Math.abs(dy * dxTody)) {
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