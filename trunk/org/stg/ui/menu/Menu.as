﻿package org.stg.ui.menu {
	import org.stg.events.MenuEvent;
	
	import flash.display.MovieClip;	

	/**
	 * @author japanese cake
	 */
	public class Menu extends MovieClip implements IMenu {
		
		public static const HOME_MENU		: String = "_homeMenu";
		
		public static var currentMenu: String;
				
		public function Menu() {}
		
		public function goto(menuName:String):void {
			currentMenu = menuName;
			dispatchEvent(new MenuEvent(MenuEvent.MENU_CHANGED,currentMenu));
		}		
	}
}