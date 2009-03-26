package org.stg.core {
	import gs.TweenLite;
	import gs.easing.Expo;
	
	import com.asual.swfaddress.SWFAddress;
	
	import org.stg.core.Support3D;
	import org.stg.debug.DebugPanel;
	import org.stg.events.GameEvent;
	import org.stg.events.MenuEvent;
	import org.stg.game.GameBuilder;
	import org.stg.managers.LevelManager;
	import org.stg.net.NetGateway;
	import org.stg.net.socket.SocketClient;
	import org.stg.ui.GamePanel;
	import org.stg.ui.LoadingBox;
	import org.stg.ui.UserPanel;
	import org.stg.ui.asset.GameTimerAsset;
	import org.stg.ui.menu.MainMenu;
	
	import flash.display.DisplayObject;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;	

	/**
	 * @author japanese cake
	 */	
	 
	[SWF(width="900", height="520", backgroundColor="#cc3300", frameRate="31")]
	public class Main extends MovieClip {

		private static var _instance : Main;
		
		public static var mode 		: Namespace;

		// UI
		public var gameTimerAsset	: GameTimerAsset;		public var gameMenu			: MainMenu;		public var gamePanel		: GamePanel;
		public var userPanel		: UserPanel;				public var debugPanel		: DebugPanel;		
		public var loadingBox		: LoadingBox;
				public var support3d		: Support3D;		public var sfs_client		: SocketClient;


		/******************************************************************************************
		 *** PUBLIC STATIC METHODS ****************************************************************
		 ******************************************************************************************/

		public static function getInstance():Main {
			return _instance;
		}		

		public static function setStatut(o:Object):void {
			if (o.cnxStatut != null) getInstance().userPanel.tfCnxStatus.text = o.cnxStatut;
			if (o.userName != null) getInstance().userPanel.tfUserName.text = o.userName;
		}

		/******************************************************************************************		 *** PUBLIC METHODS ***********************************************************************		 ******************************************************************************************/
		public function Main() {
			super();
			_instance = this;

			if (Config.mode == null) {
				Config.mode = Namespace(LoaderInfo(this.root.loaderInfo).parameters["mode"]);
				trace("Main :: NO LOADER USED");
				try {
					mode = Config.mode;
					Config.mode::setEnvPath();
				}catch (error:Error) {}
				finally {
					mode = Config.mode = offline;
					Config.mode::setEnvPath();
				}
			}else mode = Config.mode;
			
			if (mode == offline) debugPanel.visible = true;
			
			initSupport3D();
			NetGateway.initialize(this, support3d);
			addEventListener(Event.ADDED_TO_STAGE, initHandler);
		}

		public function showCoverFlow():void {
			trace("Main :: loadLevelList");
			LevelManager.loadXMLLevelList(loadLevelListHandler);			
		}
		
		public function loadGame(evt:Event = null):void {
			trace("Main :: loadGame");
			support3d.createGameSupport();
			addEventListener(GameEvent.INITIALIZED, startGame);
			GameBuilder.makeOnce(this);
		}
		
		/* MENUS INTERACTIONS */
		public function showMenu():void {
			gameMenu.visible = true;
			gameMenu.x = -gameMenu.width;
			TweenLite.to(gameMenu, 1.25, {x:stage.stageWidth / 2, ease:Expo.easeOut});
		}
		
		public function showGamePanel():void {
			gamePanel.visible = true;
			gamePanel.x = - (2*gamePanel.width + 10);
			TweenLite.to(gamePanel, 1.25, {x:10, ease:Expo.easeOut});
		}
		
		public function hideGamePanel(callBack:Function=null):void {
			gamePanel.x = 10;
			TweenLite.to(gamePanel, 1.25, {x:-(2*gamePanel.width + 10), ease:Expo.easeOut, onComplete:hideGamePanelHandler, onCompleteParams:[callBack]});
		}
				
		public function hideMenu(callBack:Function=null):void {
			gameMenu.x = stage.stageWidth / 2;
			TweenLite.to(gameMenu, 1.25, {x:2*stage.stageWidth, ease:Expo.easeOut, onComplete:hideMenuHandler, onCompleteParams:[callBack]});
		}

		/******************************************************************************************
		 *** PRIVATE METHODS **********************************************************************
		 ******************************************************************************************/

		private function initSupport3D():void {
			support3d = new Support3D(this);
			swapChildren(support3d, gamePanel);
			swapChildren(support3d, debugPanel);		}
		
				
		private function startGame(evt:GameEvent):void {
			GameBuilder.run();
		}
		
		/* HANDLERS */
		private function initHandler(evt:Event):void {
			trace("Main :: openHome");
			gameMenu.addEventListener(MenuEvent.START_LOAD_GAME, startLoadGameHandler);
			gameMenu.addEventListener(MenuEvent.AUTHENTIFIED, authentifiedHanlder);
			showMenu();
		}
		
		private function startLoadGameHandler(evt:MenuEvent):void {
			trace("Main :: startLoadGameHandler");
			hideMenu(initGameEnvironmentHandler);
		}
		
		private function initGameEnvironmentHandler():void {
			trace("Main :: initGameEnvironment");
			SWFAddress.setTitle("[STG] Now playing...");			NetGateway.connect();
		}
		
		private function loadLevelListHandler():void {
			trace("Main :: loadLevelListHandler");
			support3d.createCoverFlow(LevelManager.getLevelList().length);
		}
		
		private function authentifiedHanlder(evt:MenuEvent=null):void {
			gameMenu.gotoHomeMenu();
			userPanel.btDisconnect.enabled = true;
			userPanel.btDisconnect.visible = true;
		}
		
		private function hideMenuHandler(callBack:Function = null):void {
			gameMenu.visible = false;
			//gamePanel.x =  - (2*gamePanel.width + 10);;
			//gameMenu.x = -gameMenu.width;
			if (callBack != null) callBack();
		}
		
		private function hideGamePanelHandler(callBack:Function = null):void {
			gamePanel.visible = false;
			//gameMenu.x = -gameMenu.width;
			if (callBack != null) callBack();
		}

	}
}
