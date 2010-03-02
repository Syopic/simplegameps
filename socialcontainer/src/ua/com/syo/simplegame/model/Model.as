package ua.com.syo.simplegame.model {
	
	import flash.events.EventDispatcher;
	
	import ua.com.syo.simplegame.model.net.CommandParser;
	import ua.com.syo.simplegame.model.net.TestServer;
	import ua.kiev.djm.core.net.ServerProxy;
	import ua.kiev.djm.core.net.connections.ConnectionAttributes;
	import ua.kiev.djm.core.net.connections.ServerMockConnection;
	import ua.kiev.djm.core.net.connections.events.CommunicateEvent;
	
	public class Model extends EventDispatcher {
		private static var _instance:Model;
		
		public static function get instance():Model {
			if (!_instance)
				_instance = new Model();
			return _instance;
		}
		
		public function init():void {
			connect();
		}
		
		private function connect():void {
			var ca:ConnectionAttributes = new ConnectionAttributes()
			ca.setParser(CommandParser.instance);
			var connection:ServerMockConnection = new ServerMockConnection("mock", ca);
			connection.serverMock = new TestServer();
			
			connection.addEventListener(CommunicateEvent.CONNECT, connectHandler);
			ServerProxy.instance.addConnection(connection);
		}
		
		private function connectHandler(event:CommunicateEvent):void {
			ServerProxy.instance.sendCommand("test", "mock");
		}
	}
}