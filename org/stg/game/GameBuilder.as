package org.stg.game {
	import org.stg.net.socket.SocketClient;	
	import org.stg.core.Main;
	import org.stg.core.Support3D;
	import org.stg.events.GameEvent;
	import org.stg.events.ScreenEvent;
	import org.stg.game.Screen;
	import org.stg.managers.GameEventManager;
	import org.stg.managers.LevelManager;
	import org.stg.net.GameUser;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;	

	/**
	 * @author japanese cake
	 */
	public class GameBuilder {
		
		private static var _container : DisplayObjectContainer;
		
		public static function makeOnce(container : DisplayObjectContainer):void {
			if (_container == null) _container = container;
			
			LevelManager.loadXMLLevel(initGamePad);
		}
		
		public static function initGamePad():void {
			new GamePad();
			GamePad.getInstance().addEventListener(GameEvent.GAMEPAD_INITIALIZED, initGamePadHandler);
			GamePad.getInstance().initialize(GameUser.GAMEPAD);
		}
		
		private static function initGamePadHandler(evt:Event):void {
			make();
		}
		
		// MAKE SCRIPT	
		public static function make() : void {
			trace("GameBuilder :: make");
			
			Screen.getInstance().x = Main.getInstance().stage.stageWidth/2 - Screen.getInstance().width/2;
			Screen.getInstance().y = Main.getInstance().stage.stageHeight/2 - Screen.getInstance().height/2;
			Screen.getInstance().addEventListener(ScreenEvent.SCREEN_INITIALIZED, _screenInitHandler);
			Screen.getInstance().initialize(SocketClient.getInstance().playerid);
		}
		
		private static function _screenInitHandler(evt:Event):void {
			trace("GameBuilder :: _screenInitHandler");
			Screen.getInstance().removeEventListener(ScreenEvent.SCREEN_INITIALIZED, _screenInitHandler);
			
			LevelManager.getLevelChild().addEventListener(GameEvent.GFX_GENERATED, _gfxGenerated);
			LevelManager.getLevelChild().generateGfx();
		}
		
		private static function _gfxGenerated(evt:Event):void {
			trace("GameBuilder :: _gfxGenerated");
			
			LevelManager.getLevelChild().removeEventListener(GameEvent.GFX_GENERATED, _gfxGenerated);
			
			new GameEngine();
			GameEngine.getInstance().addEventListener(GameEvent.INITIALIZED, _gameInitialized);
			GameEngine.getInstance().initialize();
			
			// INIT GAME EVENTS LISTENER
			new GameEventManager();
			GameEngine.getInstance().addEventListener(GameEvent.CHANGE_ROOM, GameEventManager.getInstance().onGameEvent);
		}
		
		private static function _gameInitialized(evt:Event):void {
			trace("GameBuilder :: _gameInitialized");
			Screen.getInstance().setVisibility = false;
			GameEngine.getInstance().removeEventListener(GameEvent.INITIALIZED, _gameInitialized);
			Support3D.getInstance().tweenIn(1);
			_container.dispatchEvent(new GameEvent(GameEvent.INITIALIZED));
		}
		
		public static function run():void {
			// PLAY IN TRANSITION + START GAME
			GameEngine.getInstance().start();
			Screen.getInstance().setVisibility = true;
			Screen.getInstance().playTransition(0);
		} 
	
		// CLEAN SCRIPT
		
		public static function clean():void {
			trace("GameBuilder :: clean");
			try{
				GameEngine.getInstance().destroy();
				
				Screen.getInstance().addEventListener(ScreenEvent.SCREEN_CLEAN, onScreenCleaned);
				Screen.getInstance().clean();
			}catch (e:Error) {}
		}
		
		private static function onScreenCleaned(evt:ScreenEvent):void {
			Screen.getInstance().removeEventListener(ScreenEvent.SCREEN_CLEAN, onScreenCleaned);
			make();
		}

		public static function changeRoom():void {
			trace("GameBuilder :: changeRoom");
			LevelManager.changeLevelChild(LevelManager.nextLevelChildDoor.newLevelChildID);
			
			try{
				Support3D.getInstance().tweenIn(1, clean);
			}catch (e:Error) {}
			
			Screen.getInstance().setVisibility = false;
		}
	}
}
