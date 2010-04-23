/**
 * Main.as					main entry class
 * @author					Krivosheya Sergey
 * @link    				http://www.syo.com.ua/
 * @link    				mailto: syopic@gmail.com
 */
package {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.system.Security;
	
	import mx.core.Application;
	import mx.core.FlexLoader;
	import mx.managers.SystemManager;
	
	import ua.com.syo.socialps.controller.Controller;
	import ua.com.syo.socialps.data.Globals;
	import ua.com.syo.socialps.model.Model;
	import ua.com.syo.socialps.view.UIManager;
	import ua.com.syo.socialps.view.stage.StageView;
	import ua.kiev.djm.core.log.Logger;
	import ua.kiev.djm.core.log.targets.LogPanel;
	import ua.kiev.djm.core.net.connections.events.CommunicateEvent;
	
	[SWF(width="730", height = "730", frameRate = "41")]
	
	public class Main extends Sprite {
		
		/**
		 * constructor
		 */
		public function Main() {
			// wait for initialisation
			Security.allowDomain("*");
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
			
			Controller.instance.addEventListener(Event.COMPLETE, completeHandler);
			
			// init log panel
			/*var logPanel:LogPanel = new LogPanel(this, false);
			Logger.setTarget(logPanel);*/
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			//stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			
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
		
		private function keyDownHandler(event:KeyboardEvent):void {
			connectTest();
		}
		
		public function connectTest():void {
			Controller.instance.runGame();
		}
		
		public function completeHandler(event:Event):void {
			var dEvent:DataEvent = new DataEvent(DataEvent.DATA);
			dEvent.data = (Model.instance.score + 1).toString();
			dispatchEvent(dEvent);
			//(((this.parent as FlexLoader).root as SystemManager).application as Object).innerCall(Model.instance.score + 1);
		}
	}
}