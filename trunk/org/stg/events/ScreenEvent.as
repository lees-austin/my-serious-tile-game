﻿package org.stg.events {	
	/**
	 * @author japanese cake
	 */
	import flash.events.Event;		

	public class ScreenEvent extends Event {
		
		
		public function ScreenEvent( type:String )
		{
			super( type, false, false );
		}
	}

}