package org.stg.net.socket {
	import it.gotoandplay.smartfoxserver.SFSEvent;
	import it.gotoandplay.smartfoxserver.SmartFoxClient;
	import it.gotoandplay.smartfoxserver.data.Room;
	import it.gotoandplay.smartfoxserver.data.User;
	
	import org.stg.core.Main;
	import org.stg.core.Config;
	import org.stg.events.GameEvent;
	import org.stg.net.GameUser;
	import org.stg.ui.GamePanel;
	
	import flash.events.Event;	

	/**
	 * @author japanese cake
	 */
	public class SocketClient extends SmartFoxClient {
		
		private static var _instance	: SocketClient;
		
		private static var ZONE			: String = "stg";		private static var GAME_XT		: String = "Game";		private static var LOGIN_XT		: String = "Login";
		
		public static var CONNECTED			: String = "_connected";		public static var DISCONNECTED		: String = "_disconnected";		public static var NEW_USER			: String = "_newUser";		public static var ENOUGHT_USERS		: String = "_enoughtUsers";		public static var LEVEL_SELECTED	: String = "_levelSelected";		public static var START				: String = "_start";
				public var 	userList				: Array;		public static const minPlayers		: uint = 2;
		
		public var updateObj				: Array;
		
		public static function getInstance():SocketClient {
			return _instance;
		}
		
		public function SocketClient(debug : Boolean = false) {
			super(debug);
			_instance = this;
			
			loadConfig(Config.SFS_CONFIG_FILE, false);
					
			blueBoxIpAddress = Config.BLUEBOX_SERVER;
			
			addEventListener(SFSEvent.onConfigLoadSuccess, onConfigLoadSuccess);
			addEventListener(SFSEvent.onConfigLoadFailure, onConfigLoadFailure);			addEventListener(SFSEvent.onConnection, connectHandler);			addEventListener(SFSEvent.onConnectionLost, connectErrorHandler);
			addEventListener(SFSEvent.onExtensionResponse, extensionResponseHandler);
			addEventListener(SFSEvent.onRoomListUpdate, roomListUpdateHandler);			addEventListener(SFSEvent.onUserEnterRoom, userEnterRoomHandler);			addEventListener(SFSEvent.onUserLeaveRoom, userLeaveRoomHandler);			addEventListener(SFSEvent.onJoinRoom, joinRoomHandler);			addEventListener(SFSEvent.onJoinRoomError, joinRoomErrorHandler);
			addEventListener(SFSEvent.onObjectReceived, ObjReceivedHandler);
			
			updateObj = new Array();
			Main.setStatut({cnxStatut:"non connecté"});
		}
		
		public function askLevel(levelId:int):void {
			Main.setStatut({cnxStatut:"Validation du niveau sur le serveur..."});
			var params:Object = new Object();
			params.id = [levelId];
			sendXtMessage(GAME_XT, "lvs", [levelId], XTMSG_TYPE_STR);
		}
		
		public function checkIfEnoughtUsers():void {
			if (getActiveRoom().getUserCount() >= minPlayers) dispatchEvent(new Event(ENOUGHT_USERS));
		}
		
		public function sendInitStatut():void {
			sendXtMessage(GAME_XT, "init", [], XTMSG_TYPE_STR);
		}
		
		public function sendCharacter(object:Object):void {
			sendObject(object);
		}
		
		public function get playerid():uint { return playerId; }
		
		private function onConfigLoadSuccess(evt : SFSEvent):void {
			Main.setStatut({cnxStatut:"Fichier de configuration chargé."});
			connect(ipAddress, port);
		}
		
		private function onConfigLoadFailure(evt : SFSEvent):void {
			Main.setStatut({cnxStatut:"Impossible de charger le fichier de configuration"});
		}
		
		private function connectHandler(evt:SFSEvent):void {
			trace("SocketClient :: connectHandler");
			removeEventListener(SFSEvent.onConnection, connectHandler);
			
			if (evt.params.success) {
				Main.setStatut({cnxStatut:"connexion réussit"});
				login(ZONE, GameUser.NAME, GameUser.SID);
			}else{
				 Main.setStatut({cnxStatut:"la connexion a échouée"});
			}
		}
		
		private function connectErrorHandler(evt:SFSEvent = null):void {
			trace("SocketClient :: connectErrorHandler",evt);
			Main.setStatut({cnxStatut:"vous avez été déconnecté !"});
			removeEventListener(SFSEvent.onConnection, connectHandler);
			removeEventListener(SFSEvent.onConnectionLost, connectErrorHandler);
			removeEventListener(SFSEvent.onExtensionResponse, extensionResponseHandler);
			removeEventListener(SFSEvent.onRoomListUpdate, roomListUpdateHandler);
			removeEventListener(SFSEvent.onJoinRoom, joinRoomHandler);
			dispatchEvent(new Event(DISCONNECTED));
		}
		
		private function roomListUpdateHandler(evt:SFSEvent):void {
			trace("SocketClient :: roomListUpdateHandler", evt);
			removeEventListener(SFSEvent.onRoomListUpdate, roomListUpdateHandler);
			sendXtMessage(LOGIN_XT, "jme", [], "str");
		}
		
		private function joinRoomHandler(evt:SFSEvent):void {
			var currentRoom : Room = Room(evt.params.room);

			trace("SocketClient :: joinRoomHandler", currentRoom.getName());
			
			GameUser.PLAYERID = playerId;			
			userList = currentRoom.getUserList();

			Main.getInstance().gamePanel.ltUsers.removeAll();

			for (var u:String in userList) {
				Main.getInstance().gamePanel.ltUsers.addItem({label:userList[u].getName(),data:userList[u].getPlayerId()});
			}
			
			removeEventListener(SFSEvent.onJoinRoom, joinRoomHandler);
			Main.setStatut({cnxStatut:"vous êtes connecté au serveur de jeu !"});

			dispatchEvent(new Event(CONNECTED));
		}
		
		private function joinRoomErrorHandler(evt:SFSEvent):void {
			trace("SocketClient :: joinRoomError", evt);
		}
		
		private function userEnterRoomHandler(evt:SFSEvent):void {
			trace("SocketClient :: userEnterRoomHandler", evt);
			
			var newUser : User = User(evt.params.user);
			userList.push(newUser);
			
			trace("Joueur " + newUser.getName() + "(id="+newUser.getPlayerId()+") viens d'arriver !");
			
			Main.getInstance().gamePanel.ltUsers.addItem({label:newUser.getName(),data:newUser.getPlayerId()});
			
			//checkIfEnoughtUsers();
			dispatchEvent(new Event(NEW_USER));
		}

		private function userLeaveRoomHandler(evt:SFSEvent):void {
			trace("SocketClient :: userLeaveRoomHandler", evt);
			Main.getInstance().gamePanel.ltUsers.removeItem({label:evt.params.userName});
			
			if (getActiveRoom().getUserCount() < minPlayers) {
				trace("SocketClient :: userCount="+getActiveRoom().getUserCount());
				disconnect();
				dispatchEvent(new Event(DISCONNECTED));
			}
			
		}

		private function extensionResponseHandler(evt:SFSEvent):void {
			trace("SocketClient :: extensionResponseHandler ("+evt.params.dataObj._cmd+")");
			var type:String = evt.params.type;
			var data:Object = evt.params.dataObj;
			var command:String = data._cmd;			trace("type: "+type);			trace("data: "+data);
			trace("cmd : "+command);
			if (command == "logOK") {
				Main.setStatut({cnxStatut:"succès de l'authentification"});
				//addEventListener(SFSEvent.onRoomListUpdate, roomListUpdateHandler);
				getRoomList();
			}else if (command == "lvsOK") {
				Main.setStatut({cnxStatut:"Niveau "+data.selectedLevel+" choisi !"});
				dispatchEvent(new GameEvent(LEVEL_SELECTED, data));
			}else if (command == "initOK") {
				Main.setStatut({cnxStatut:"Démarrage de la partie !"});
				dispatchEvent(new GameEvent(START));
			}
			
		}
		
		private function ObjReceivedHandler(event : SFSEvent):void {
			var o : Object = Object(event.params);
			updateObj.push(o);
		}
		
	}
}
