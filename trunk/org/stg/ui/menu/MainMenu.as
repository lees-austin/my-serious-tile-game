package org.stg.ui.menu {
	import org.stg.events.MenuEvent;
	
	import flash.display.MovieClip;
	import flash.events.Event;	

	/**
	 * @author japanese cake
	 */
	public class MainMenu extends MovieClip {
			 
		public var _menu		: Menu;

		public function MainMenu() {
			//visible = false;
			gotoAndPlay("_loginMenu");
			_menu.addEventListener(MenuEvent.MENU_CHANGED, changeMenuHandler);			_menu.addEventListener(MenuEvent.START_LOAD_GAME, startLoadGameHandler);			_menu.addEventListener(MenuEvent.AUTHENTIFIED, authentifiedHandler);
		}
		
		public function gotoHomeMenu(evt:Event=null):void {
			_menu.goto(Menu.HOME_MENU);	
		}
		
		public function gotoLoginMenu(evt:Event=null):void {
			_menu.goto(Menu.LOGIN_MENU);	
		}
		
		public function gotoGameMenu(evt:Event=null):void {
			_menu.goto(Menu.GAME_MENU);	
		}
		
		public function gotoProfileMenu(evt:Event=null):void {
			_menu.goto(Menu.PROFILE_MENU);	
		}
		
		private function changeMenuHandler(evt:MenuEvent):void {
			trace("MainMenu :: changeMenu-->" + evt.newSection);
			_menu.removeEventListener(MenuEvent.MENU_CHANGED, changeMenuHandler);
			_menu.removeEventListener(MenuEvent.START_LOAD_GAME, startLoadGameHandler);			_menu.removeEventListener(MenuEvent.AUTHENTIFIED, authentifiedHandler);
			gotoAndPlay(evt.newSection);
			_menu.addEventListener(MenuEvent.MENU_CHANGED, changeMenuHandler);
			_menu.addEventListener(MenuEvent.START_LOAD_GAME, startLoadGameHandler);			_menu.addEventListener(MenuEvent.AUTHENTIFIED, authentifiedHandler);
		}
		
		private function startLoadGameHandler(evt:MenuEvent):void {
			trace("MainMenu :: startLoadGameHandler-->" + evt);
			_menu.removeEventListener(MenuEvent.START_LOAD_GAME, startLoadGameHandler);
			dispatchEvent(new MenuEvent(MenuEvent.START_LOAD_GAME));
		}
		
		private function authentifiedHandler(evt:MenuEvent):void {
			trace("MainMenu :: authentifiedHandler-->" + evt);
			_menu.removeEventListener(MenuEvent.AUTHENTIFIED, authentifiedHandler);
			dispatchEvent(new MenuEvent(MenuEvent.AUTHENTIFIED));
		}
	}
}
