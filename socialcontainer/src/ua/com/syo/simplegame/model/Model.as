package ua.com.syo.simplegame.model {
	
	import flash.events.EventDispatcher;
	import flash.system.Security;
	
	import ru.vkontakte.VKApi;
	
	import ua.com.syo.simplegame.model.net.CommandParser;
	import ua.com.syo.simplegame.model.net.TestServer;
	import ua.com.syo.simplegame.model.net.social.VKData;
	import ua.kiev.djm.core.log.Logger;
	import ua.kiev.djm.core.net.ServerProxy;
	import ua.kiev.djm.core.net.connections.ConnectionAttributes;
	import ua.kiev.djm.core.net.connections.HTTPConnection;
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
			checkPolicy();
			connect();
		}
		
		private function checkPolicy():void {
			Security.loadPolicyFile("http://89.252.12.14:2080/crossdomain.xml");
			
			Security.loadPolicyFile("http://vkontakte.ru/crossdomain.xml");
			Security.loadPolicyFile("http://cs9458.vkontakte.ru/crossdomain.xml");
		}
		
		private function connect():void {
			/*var ca:ConnectionAttributes = new ConnectionAttributes()
			ca.setParser(CommandParser.instance);
			var connection:ServerMockConnection = new ServerMockConnection("mock", ca);
			connection.serverMock = new TestServer();
			
			connection.addEventListener(CommunicateEvent.CONNECT, connectHandler);
			ServerProxy.instance.addConnection(connection);*/
			
			var ca:ConnectionAttributes = new ConnectionAttributes("http://89.252.12.14:2080/go.php");
			ca.setParser(CommandParser.instance);
			var connection:HTTPConnection = new HTTPConnection("main", ca);
			
			connection.addEventListener(CommunicateEvent.CONNECT, connectHandler);
			ServerProxy.instance.addConnection(connection);
		}
		
		private function connectHandler(event:CommunicateEvent):void {
			CommandSeneder.send("join");
		}
		
		
	}
}