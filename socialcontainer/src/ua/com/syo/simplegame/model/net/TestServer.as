package ua.com.syo.simplegame.model.net {
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import ua.kiev.djm.core.net.connections.events.CommunicateEvent;
	import ua.kiev.djm.core.net.test.ServerMock;
	
	public class TestServer extends ServerMock {
		
		private var commandStack:Array;
		private var cEvent:CommunicateEvent;
		
		public function TestServer() {
			super();
		}
		
		override public function getRequest(command:String):void {
			sendResponse('{"response":[{"uid":"1","first_name":"Павел","last_name":"Дуров","photo":"http:\/\/cs109.vkontakte.ru\/u00001\/c_df2abf56.jpg"},{"uid":"6492","first_name":"Andrew","last_name":"Rogozov","photo":"http:\/\/cs537.vkontakte.ru\/u06492\/c_28629f1d.jpg"},{"uid":"6492","first_name":"Andrew","last_name":"Rogozov","photo":"http:\/\/cs537.vkontakte.ru\/u06492\/c_28629f1d.jpg"},{"uid":"6492","first_name":"Andrew","last_name":"Rogozov","photo":"http:\/\/cs537.vkontakte.ru\/u06492\/c_28629f1d.jpg"},{"uid":"6492","first_name":"Andrew","last_name":"Rogozov","photo":"http:\/\/cs537.vkontakte.ru\/u06492\/c_28629f1d.jpg"},{"uid":"6492","first_name":"Andrew","last_name":"Rogozov","photo":"http:\/\/cs537.vkontakte.ru\/u06492\/c_28629f1d.jpg"},{"uid":"6492","first_name":"Andrew","last_name":"Rogozov","photo":"http:\/\/cs537.vkontakte.ru\/u06492\/c_28629f1d.jpg"},{"uid":"6492","first_name":"Andrew","last_name":"Rogozov","photo":"http:\/\/cs537.vkontakte.ru\/u06492\/c_28629f1d.jpg"},{"uid":"6492","first_name":"Andrew","last_name":"Rogozov","photo":"http:\/\/cs537.vkontakte.ru\/u06492\/c_28629f1d.jpg"},{"uid":"6492","first_name":"Andrew","last_name":"Rogozov","photo":"http:\/\/cs537.vkontakte.ru\/u06492\/c_28629f1d.jpg"},{"uid":"6492","first_name":"Andrew","last_name":"Rogozov","photo":"http:\/\/cs537.vkontakte.ru\/u06492\/c_28629f1d.jpg"},{"uid":"6492","first_name":"Andrew","last_name":"Rogozov","photo":"http:\/\/cs537.vkontakte.ru\/u06492\/c_28629f1d.jpg"}]}');
		}
	}
}