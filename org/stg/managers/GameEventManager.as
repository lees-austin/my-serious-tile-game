package org.stg.managers {
	import org.stg.events.GameEvent;
	import org.stg.game.GameBuilder;
	import org.stg.game.Screen;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;	

	/**
	 * @author japanese cake
	 */
	public class GameEventManager extends EventDispatcher {
		
		private static var _instance : GameEventManager;
		
		public static function getInstance():GameEventManager {
			return _instance;
		}
		
		public function GameEventManager(target : IEventDispatcher = null) {
			super(target);
			_instance = this;
		}
		
		public function onGameEvent(evt:GameEvent):void {
			trace("GameEventManager :: onGameEvent->"+evt.type);
			this[evt.type]();	
		}
		
		public function changeRoom():void {
			Screen.getInstance().playTransition(1,GameBuilder.changeRoom);
		}
		
		
	}
}
