package org.stg.net {
	import it.gotoandplay.smartfoxserver.SmartFoxClient;
	
	import org.stg.core.Main;
	import org.stg.core.Support3D;
	import org.stg.core.offline;
	import org.stg.core.online;
	import org.stg.events.GameEvent;
	import org.stg.game.GameBuilder;
	import org.stg.game.GameEngine;
	import org.stg.game.Screen;
	import org.stg.managers.LevelManager;
	import org.stg.net.socket.SocketClient;
	import org.stg.ui.GameTimer;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;	

	/**
	 * @author japanese cake
	 */
	public class NetGateway extends EventDispatcher {
		
		private static var mode			: Namespace;
		private static var main			: Main;		private static var screen		: Screen;		private static var support3d	: Support3D;		private static var gameEngine	: GameEngine;		private static var socketClient : SocketClient;		private static var gameTimer 	: GameTimer;

		private static var scenary		: String = "disconnected";
		
		public function NetGateway(target : IEventDispatcher = null) {
			super(target);
		}
		
		public static function initialize(mainInstance : Main, support3dInstance : Support3D):void {
			mode			= Main.mode;
			main			= mainInstance;
			support3d 		= support3dInstance;
			
			support3d.addEventListener(Support3D.LEVEL_SELECTED, levelSelectedHandler);			support3d.addEventListener(GameEvent.INITIALIZED, sendInitMsg);
			
			scenary = "disconnected";
		}
		
		public static function connect():void {
			initSmartFoxClient();
		}
		
		public static function destroySocketClient():void {
			
		}
		
		public static function disconnect():void {
			trace("NetGateway :: disconnect (" + scenary + ")");
			if (scenary != "disconnected" && socketClient != null) socketClient.disconnect();
			else sfsDisconnectHandler();
		}
		
		public static function levelSelectedHandler(event:Event):void {
			trace("NetGateway :: levelSelectedHandler");
			gameTimer.kill();
			mode::initGame();
		}
		
		/* */
		online static function initGame(event:Event = null):void {
			main.loadGame();
		}
		
		offline static function initGame(event:Event = null):void {
			trace(mode+"::initGame");
			scenary = "validation";
			socketClient.askLevel(GameUser.LEVELID);
		}
		
		/* Private Methods */
		
		private static function initSmartFoxClient():void {
			socketClient = new SocketClient(true);	
			socketClient.addEventListener(SocketClient.DISCONNECTED, sfsDisconnectHandler);			socketClient.addEventListener(SocketClient.CONNECTED, sfsConnectionHandler);
			socketClient.addEventListener(SocketClient.ENOUGHT_USERS, sfsEnoughtUsersHandler);			socketClient.addEventListener(SocketClient.NEW_USER, sfsNewUserHandler);			socketClient.addEventListener(SocketClient.LEVEL_SELECTED, serverLevelSelectionHandler);			socketClient.addEventListener(SocketClient.START, start);
		}
		
		private static function sfsConnectionHandler(event : Event) : void {
			main.showGamePanel();
			scenary = "waitForUser";
			Main.setStatut({cnxStatut:"En attente des autres joueurs"});
			socketClient.checkIfEnoughtUsers();
		}

		private static function sfsDisconnectHandler(event : Event = null):void {
					
			switch (scenary) {
				case "waitForUser":
					if (gameTimer != null) gameTimer.kill();
					main.hideGamePanel();
				break;
				
				case "disconnected":
					
				break;
				
				case "ingame":
					gameEngine.destroy();
					screen.destroy();
					support3d.destroyActiveMode();
				break;
			}
			
			scenary = "disconnected";
						
			LevelManager.clean();
			GameUser.clearUserData();
			
			main.userPanel.hideMe();
			main.gameMenu.gotoLoginMenu();
			main.showMenu();
						
		}
		
		private static function sfsNewUserHandler(event : Event = null):void {
			if (scenary == "waitForUser") socketClient.checkIfEnoughtUsers();
		}
		
		private static function sfsEnoughtUsersHandler(event : Event = null):void {
			Main.setStatut({cnxStatut:"Sélectionnez un niveau"});
			scenary = "level_selection";
			main.hideGamePanel();
			main.showCoverFlow();
			gameTimer = new GameTimer(10, forceLevelSelection, null, true);			
		}
		
		private static function forceLevelSelection():void {
			trace("forceLevelSelection");
			GameUser.LEVELID = Math.floor(Math.random() * LevelManager.LEVELS_NUMBER + 1);
			support3d.flowTo(GameUser.LEVELID, true);
		}
		
		private static function serverLevelSelectionHandler(event:GameEvent):void {
			var levelId:int = event.data.selectedLevel;
			trace("serverLevelSelectionHandler :: level="+levelId);
			LevelManager.SELECTED_LEVEL = levelId;
			support3d.flowTo(levelId, true, true);
			gameTimer = new GameTimer(2, loadLevel, null, false, false);
		}
		
		private static function loadLevel():void {
			trace("NetGateway :: loadLevel");
			support3d.destroyActiveMode();
			support3d.createGameSupport();
			GameBuilder.makeOnce(support3d);
			//socketClient.sendInitStatut();
		}
		
		private static function sendInitMsg(event : GameEvent):void {
			socketClient.sendInitStatut();
		}
		
		private static function start(event : GameEvent):void {
			scenary = "ingame";
			GameBuilder.run();
		}
	}
}
