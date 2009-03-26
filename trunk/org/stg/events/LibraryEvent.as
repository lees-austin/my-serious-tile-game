package org.stg.events {
	import flash.events.Event;	
	
	/**
	 * @author japanese cake
	 */
	public class LibraryEvent extends Event {
		
		public static const LOAD_COMPLETE	: String = "loadComplete";
		
		public function LibraryEvent(type:String) {
			super( type, false, false );
		}
		
	}
}
