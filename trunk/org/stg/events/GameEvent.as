package org.stg.events {
	import flash.events.Event;			

	/**
	 * @author japanese cake
	 */
	public class GameEvent extends Event {
	
		public static var START_GAME	: String = "startGame";		public static var CHANGE_LEVEL	: String = "changeLevel";		public static var CHANGE_ROOM	: String = "changeRoom";		public static var GFX_GENERATED	: String = "gfxGenerated";		public static var INITIALIZED	: String = "initialized";
				public static var GAMEPAD_INITIALIZED	: String = "gamepad_initialized";
		
		public var data:*;
		
		public function GameEvent( type:String, data:* = null )
		{
			super( type, false, false );
			this.data = data;
		}
	}

}