package ua.com.syo.socialps.view.stage {
	import flash.display.Sprite;
	
	import ua.com.syo.socialps.data.LibraryData;
	import ua.com.syo.socialps.view.stage.indicator.IndicatorView;

	public class Bonus extends Sprite {
		
		public var id:String;
		
		public function Bonus(id:String) {
			this.id = id;
			var slower:Sprite = new LibraryData.SlowerC();
			addChild(slower);
			IndicatorView.instance.addIndicator(id, this);
		}
		
		public function destroy():void {
			IndicatorView.instance.removeIndicator(id);
		}
	}
}