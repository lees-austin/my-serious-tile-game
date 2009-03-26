﻿package org.stg.events {
	import flash.events.Event;	
	
	/**
	 * @author japanese cake
	 */
	public class MenuEvent extends Event {
		
		public static const MENU_CHANGED	: String = "menuChanged";
		
		
		public function MenuEvent(type:String, targetSection:String=null)
		{
			super( type, false, false );
			newSection = targetSection;
		}
	}
}