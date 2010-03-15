package {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import ua.com.syo.socialps.controller.Controller;
	import ua.com.syo.socialps.data.Globals;
	import ua.com.syo.socialps.view.UIManager;
	import ua.com.syo.socialps.view.stage.StageView;
	import ua.kiev.djm.core.log.Logger;
	import ua.kiev.djm.core.log.targets.LogPanel;
	
	[SWF(width="730", height = "730", frameRate = "41")]
	
	public class Main extends Sprite {
		
		public function Main() {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		/**
		 * Entry Point
		 */
		private function init(event:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			Globals.stageW = stage.stageWidth;
			Globals.stageH = stage.stageHeight;
			
			
			Controller.instance.init();
			addChild(UIManager.instance);
			var logPanel:LogPanel = new LogPanel(this, false);
			Logger.setTarget(logPanel);
			
			Logger.DEBUG("Globals.stageW: " + Globals.stageW); 
			Logger.DEBUG("Globals.stageH: " + Globals.stageH); 
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			
		}
		
		private function mouseDownHandler(event:MouseEvent):void {
			StageView.instance.ps.userMouseDown();
		}
		
		private function mouseUpHandler(event:MouseEvent):void {
			StageView.instance.ps.userMouseUp();
		}
		
		private function mouseWheelHandler(event:MouseEvent):void {
			StageView.instance.mouseWheelHandler(event);
		}
		
		public function connectTest():void {
			StageView.instance.movePS();
		}
	}
}