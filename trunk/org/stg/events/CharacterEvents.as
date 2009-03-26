package org.stg.events {
	import flash.events.Event;		

	/**
	 * @author japanese cake
	 */
	public class CharacterEvents extends Event {
		
		// CHARACTER EVENTS
		public static var CHANGE_ROOM		: String = "changeRoom";
		public static var OPEN_DOOR			: String = "openDoor";
		public static var DOOR_CLOSED		: String = "doorClosed";
		
		public function CharacterEvents( type:String )
		{
			super( type, false, false );
		}
	}

}