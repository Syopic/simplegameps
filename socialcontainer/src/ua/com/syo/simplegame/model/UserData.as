package ua.com.syo.simplegame.model {
	import flash.events.EventDispatcher;

	public class UserData extends EventDispatcher {

		[Bindable]
		public var time:int;

		[Bindable]
		public var id:String;

		[Bindable]
		public var name:String = "Default User";

		[Bindable]
		public var lvl:int = 0;
		
		[Bindable]
		public var money:int = 0;
		
		[Bindable]
		public var exp:int = 0;

		[Bindable]
		public var score:int = 0;

		/**
		 * update UserData vars by name
		 * @param obj
		 */
		public function update(obj:Object):void {
			for (var i:String in obj) {
				if (this.hasOwnProperty(i)) {
					this[i] = obj[i];
				}
			}
			//dispatchEvent(new ModelEvent(ModelEvent.USERINFO_UPDATE));
		}


		private static var _instance:UserData;

		public static function get instance():UserData {
			if (!_instance) {
				_instance = new UserData();
			}
			return _instance;
		}

	}
}