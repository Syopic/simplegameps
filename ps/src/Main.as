/**
 * Main.as					main entry class
 * @author					Krivosheya Sergey
 * @link    				http://www.syo.com.ua/
 * @link    				mailto: syopic@gmail.com
 */
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
		
		/**
		 * constructor
		 */
		public function Main() {
			// wait for initialisation
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		/**
		 * entry point
		 */
		private function init(event:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			Globals.stageW = stage.stageWidth;
			Globals.stageH = stage.stageHeight;
			
			// init controller and view
			Controller.instance.init();
			addChild(UIManager.instance);
			
			// init log panel
			var logPanel:LogPanel = new LogPanel(this, false);
			Logger.setTarget(logPanel);
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			
		}
		
		private function mouseDownHandler(event:MouseEvent):void {
			StageView.instance.userMouseDown();
		}
		
		private function mouseUpHandler(event:MouseEvent):void {
			StageView.instance.userMouseUp();
		}
		
		private function mouseWheelHandler(event:MouseEvent):void {
			StageView.instance.mouseWheelHandler(event);
		}
		
		public function connectTest():void {
			Controller.instance.runGame();
		}
	}
}