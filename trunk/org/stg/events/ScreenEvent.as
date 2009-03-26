package org.stg.events {	
	/**
	 * @author japanese cake
	 */
	import flash.events.Event;		

	public class ScreenEvent extends Event {
				public static const SCREEN_INITIALIZED	: String = "screenInitialized";		public static const SCREEN_CLEAN		: String = "screenCleaned";
		
		public function ScreenEvent( type:String )
		{
			super( type, false, false );
		}
	}

}