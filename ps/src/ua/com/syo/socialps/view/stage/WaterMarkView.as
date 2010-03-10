package ua.com.syo.socialps.view.stage {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import ua.com.syo.socialps.data.LibraryData;
	
	public class WaterMarkView extends Sprite {
		
		private var ww:MovieClip;
		public var isMarker:Boolean;
		
		public function WaterMarkView()	{
			if (Math.random()*10 > 5) {
				ww = new LibraryData.WaterWaveC();
			} else {
				isMarker = true;
				ww = new LibraryData.MarkC();
			}
			hide();
			addChild(ww);
			ww.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		public function show():void {
			ww.visible = true;
			ww.gotoAndPlay(1);	
		}
		
		public function hide():void {
			ww.visible = false;
			ww.stop();	
		}
		
		private function enterFrameHandler(event:Event):void {
			if (ww.currentFrame == ww.totalFrames ) {
				hide();
			}
		}
	}
}