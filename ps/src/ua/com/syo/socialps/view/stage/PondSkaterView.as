/**
 * PondSkaterView.as	
 * @author				Krivosheya Sergey
 * @link    			http://www.syo.com.ua/
 * @link    			mailto: syopic@gmail.com
 */
package ua.com.syo.socialps.view.stage {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import ua.com.syo.socialps.data.Globals;
	import ua.com.syo.socialps.data.LibraryData;
	
	
	public class PondSkaterView extends Sprite {
		
		public var isRotation:Boolean = true;
		public var speed:Number = 5;
		public var dS:Number = 0.01;
		public var angle:Number = 0;
		
		private var insideMc:MovieClip;
		public var dx:Number = 0;
		public var dy:Number = 0;
		
		public var dAngle:Number = 1;
		
		private var angleInertion:Number = 0;
		
		public function PondSkaterView() {
			var ps:Sprite = new LibraryData.PondSkaterC();
			addChild(ps);
			insideMc = ps["insidePS"];
			insideMc.gotoAndStop("static");
			ps.scaleY = Globals.isoScale;
			angle = insideMc.rotation;	
		}
		
		public function mouseDownReaction():void {
			insideMc.gotoAndPlay("turn");
		}
		
		public function move():void {
			if (isRotation) {
				angle -= dAngle;
				insideMc.rotation = angle;
				angleInertion = dAngle;
				if (dAngle < 4) {
					dAngle += 0.3;
				}
			} else {
				dAngle = 1;
				angleInertion -= 0.3;
				if (angleInertion > 0) { 
					angle -= angleInertion;
					insideMc.rotation = angle;
				}
			}
			
			if (insideMc.currentFrameLabel == "turn") {
				insideMc.gotoAndStop("static");
			} 
			speed += dS;
			
			dx = speed * Math.sin(Math.PI / 180 * angle);
			dy = speed * (-Math.cos(Math.PI / 180 * angle)) * (Globals.isoScale);
			
		}
	}
}