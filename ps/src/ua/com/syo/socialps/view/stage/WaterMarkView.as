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
			addChild(ww);
			ww.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			ww.play();	
		}
		
		private function enterFrameHandler(event:Event):void {
			if (ww.currentFrame == ww.totalFrames ) {
				ww.stop();
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		public function remove():void {
		}
	}
}