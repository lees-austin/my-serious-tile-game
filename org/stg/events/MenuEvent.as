package org.stg.events {
	import flash.events.Event;	
	
	/**
	 * @author japanese cake
	 */
	public class MenuEvent extends Event {
		
		public static const MENU_CHANGED	: String = "menuChanged";		public static const AUTHENTIFIED	: String = "authentified";		public static const START_LOAD_GAME	: String = "startLoadGame";
				public var newSection	: String;
		
		public function MenuEvent(type:String, targetSection:String=null)
		{
			super( type, false, false );
			newSection = targetSection;
		}
	}
}
