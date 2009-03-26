package org.stg.game {
	import org.stg.core.Main;
	import org.stg.events.GameEvent;
	import org.wiiflash.Wiimote;
	import org.wiiflash.events.ButtonEvent;
	import org.wiiflash.events.WiimoteEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;	

	/**
	 * @author japanese cake
	 */
	public class GamePad extends EventDispatcher {

		// GAMEPAD TYPES
		public static const KEYBOARD			: String = "keyboard";		public static const WIIMOTE				: String = "wiimote";		public static const WIIMOTE_NUNCHUNK	: String = "wiimote_nunchuk";
		
		
		// GAME KEYBOARD KEY CODES
		private static var UP		: Number = 38;
		private static var DOWN		: Number = 40;
		private static var RIGHT	: Number = 39;
		private static var LEFT		: Number = 37;
		private static var JUMP		: Number = 67;
		private static var RUN		: Number = 86;
		
		// GAME CONTROL BOOLEANS
		private var keyPressedUp	: Boolean;
		private var keyPressedDown	: Boolean;
		private var keyPressedRight	: Boolean;
		private var keyPressedLeft	: Boolean;
		private var keyPressedRun	: Boolean;
		private var keyPressedJump	: Boolean;
		
		// GAME CONTROL LOCKER
		private var lockJumpKey		: Boolean;
		
		public var enable			: Boolean;
		public var type				: String;
		
		private var _wiimote	: Wiimote;
		
		private static var _instance	: GamePad;
		
		public static function getInstance():GamePad {
			return _instance;
		}
		
		public function GamePad() {
			addEventListener(Event.DEACTIVATE, initializeControlButton);
			_instance = this;
			enable = true;
		}
		
		public function initialize(type:String):void {
			this.type = type;
			
			switch (type) { 
				case KEYBOARD:
					trace("GamePad :: Keyboard");
//					Screen.getInstance().stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDownListener);					Main.getInstance().stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDownListener);
//					Screen.getInstance().stage.addEventListener(KeyboardEvent.KEY_UP,keyUpListener);					Main.getInstance().stage.addEventListener(KeyboardEvent.KEY_UP,keyUpListener);
					dispatchEvent(new GameEvent(GameEvent.GAMEPAD_INITIALIZED));
				break;
				
				case WIIMOTE:
					trace("GamePad :: Wiimote");
					initializeWiimoteOnly();				
				break;
				
				case WIIMOTE_NUNCHUNK:
					trace("GamePad :: Wiimote Nunchuk");
					initializeWiimoteNunchuk();
				break;
				
				default: initialize(KEYBOARD);
						 this.type = KEYBOARD;
				break;
			}
		}
		
		private function initializeControlButton(evt:Event = null):void {
			keyPressedLeft = keyPressedRight =
			keyPressedUp = keyPressedDown =
			keyPressedRun =	keyPressedJump = false;
		}
		
		private function keyDownListener(e:KeyboardEvent):void {
			switch (e.keyCode) {
				case LEFT: 
					keyPressedLeft=true;
					keyPressedRight=false;
					break;
				case RIGHT:
					keyPressedRight=true;
					keyPressedLeft=false;
					break;
				case UP:
					keyPressedUp=true;
					keyPressedDown=false;
					break;
				case DOWN:
					keyPressedDown=true;
					keyPressedUp=false;
					break;
				case RUN:
					keyPressedRun=true;
					break;
				case JUMP:
					keyPressedJump=!lockJumpKey;
					lockJumpKey = true;
					break;
			}
		}
	
		private function keyUpListener(e:KeyboardEvent):void {
			switch (e.keyCode) {
				case LEFT: 
					keyPressedLeft=false;
					break;
				case RIGHT:
					keyPressedRight=false;
					break;
				case UP:
					keyPressedUp=false;
					break;
				case DOWN:
					keyPressedDown=false;
					break;
				case RUN:
					keyPressedRun=false;
					break;
				case JUMP:
					keyPressedJump=false;
					lockJumpKey = false;
					break;
			}
		}
		
		private function initializeWiimote():void {
			_wiimote = new Wiimote();
			_wiimote.addEventListener(Event.CONNECT, onWiimoteConnect);
			_wiimote.addEventListener(Event.CLOSE, onWiimoteDisconnect);
			_wiimote.addEventListener(IOErrorEvent.IO_ERROR, onWiimoteConnectError);
		}
		
		private function initializeWiimoteOnly():void {
			initializeWiimote();
			
			_wiimote.addEventListener(ButtonEvent.TWO_PRESS, onAPressed);
			_wiimote.addEventListener( ButtonEvent.TWO_RELEASE, onAReleased);
			
			_wiimote.addEventListener(ButtonEvent.ONE_PRESS, onBPressed);
			_wiimote.addEventListener( ButtonEvent.ONE_RELEASE, onBReleased);
			
			_wiimote.addEventListener( ButtonEvent.UP_PRESS, onUpPressed);
			_wiimote.addEventListener( ButtonEvent.UP_RELEASE, onUpReleased);
			
			_wiimote.addEventListener( ButtonEvent.DOWN_PRESS, onDownPressed);
			_wiimote.addEventListener( ButtonEvent.DOWN_RELEASE, onDownReleased);
						_wiimote.addEventListener( ButtonEvent.LEFT_PRESS, onLeftPressed);			_wiimote.addEventListener( ButtonEvent.LEFT_RELEASE, onLeftReleased);
						_wiimote.addEventListener( ButtonEvent.RIGHT_PRESS, onRightPressed);			_wiimote.addEventListener( ButtonEvent.RIGHT_RELEASE, onRightReleased);
			
			_wiimote.connect();
		}
		
		private function initializeWiimoteNunchuk():void {
			initializeWiimote();
			
			_wiimote.addEventListener(WiimoteEvent.UPDATE, onUpdated);
			_wiimote.addEventListener(WiimoteEvent.NUNCHUK_CONNECT, onNunchukConnected);
			_wiimote.addEventListener(WiimoteEvent.NUNCHUK_DISCONNECT, onNunchukDisconnected);
			_wiimote.addEventListener(ButtonEvent.A_PRESS, onAPressed);
			_wiimote.addEventListener( ButtonEvent.A_RELEASE, onAReleased);
			_wiimote.addEventListener(ButtonEvent.B_PRESS, onBPressed);
			_wiimote.addEventListener( ButtonEvent.B_RELEASE, onBReleased);
			
			_wiimote.nunchuk.addEventListener(ButtonEvent.C_PRESS, onCEvent);
			_wiimote.nunchuk.addEventListener(ButtonEvent.C_RELEASE, onCEvent);
			_wiimote.nunchuk.addEventListener(ButtonEvent.Z_PRESS, onZPressed);
			_wiimote.nunchuk.addEventListener(ButtonEvent.Z_RELEASE, onZReleased);
			
			_wiimote.connect();
		}
		
		private function onWiimoteConnect(evt:Event):void {
			trace("GamePad :: Wiimote connectée !");
			_wiimote.removeEventListener(Event.CONNECT, onWiimoteConnect);
			if (type == WIIMOTE) dispatchEvent(new GameEvent(GameEvent.GAMEPAD_INITIALIZED));	
		}
		
		private function onNunchukConnected(evt:Event):void {
			trace("GamePad :: Nunchuk détecté !");	
			dispatchEvent(new GameEvent(GameEvent.GAMEPAD_INITIALIZED));
		}
		
		private function onWiimoteDisconnect(evt:Event):void {
			trace("GamePad :: Wiimote déconnectée !");	
		}
		
		private function onWiimoteConnectError(evt:Event):void {
			trace("GamePad :: Erreur de connection avec la Wiimote !");	
		}
		
		private function onAPressed(evt : ButtonEvent) : void {
			keyPressedJump = true;
		}
		
		private function onAReleased(evt : ButtonEvent) : void {
			keyPressedJump = false;
		}
		
		private function onBPressed(evt : ButtonEvent) : void {
			keyPressedRun = true;
		}
		
		private function onBReleased(evt : ButtonEvent) : void {
			keyPressedRun = false;
		}
		
		private function onUpReleased(evt : ButtonEvent) : void {
			keyPressedLeft = false;
		}

		private function onUpPressed(evt : ButtonEvent) : void {
			keyPressedLeft = true;
			keyPressedRight = false;
		}
		
		private function onDownReleased(evt : ButtonEvent) : void {
			keyPressedRight = false;
		}

		private function onDownPressed(evt : ButtonEvent) : void {
			keyPressedRight = true;
			keyPressedLeft = false;
		}
		
		private function onLeftReleased(evt : ButtonEvent) : void {
			keyPressedDown = false;
		}

		private function onLeftPressed(evt : ButtonEvent) : void {
			keyPressedDown = true;
			keyPressedUp = false;
		}
		
		private function onRightReleased(evt : ButtonEvent) : void {
			keyPressedUp = false;
		}

		private function onRightPressed(evt : ButtonEvent) : void {
			keyPressedUp = true;
			keyPressedDown = false;
		}
		
		private function onNunchukDisconnected(evt:Event):void {
			trace("GamePad :: Nunchuk déconnecté !");	
		}
		
		private function onZPressed(evt:ButtonEvent):void {
			keyPressedRun = true;
		}

		private function onZReleased(evt:ButtonEvent):void {
			keyPressedRun = false;
		}
		
		private function onCEvent(evt:ButtonEvent):void {
			trace("GamePad :: Nunchuk->C");
		}
		
		private function onUpdated(evt:WiimoteEvent):void {
			// X
			if (evt.target.nunchuk.stickX < -0.15) {
				keyPressedLeft = true;				keyPressedRight = false;
			}else  keyPressedLeft = false;
						if (evt.target.nunchuk.stickX > 0.15) {
				keyPressedRight = true;
				keyPressedLeft = false;
			}else keyPressedRight = false;
			
			// Y
			if (evt.target.nunchuk.stickY < -0.15) {
				keyPressedDown = true;				keyPressedUp = false;
			}else  keyPressedDown = false;
			
			if (evt.target.nunchuk.stickY > 0.15) {
				keyPressedUp = true;				keyPressedDown = false;
			}else keyPressedUp = false;
		}
		
		// CONTROL ACTION BOOLEAN GETTERS
		public function get left():Boolean {
			return (enable && keyPressedLeft);
		}
		public function get right():Boolean {
			return (enable && keyPressedRight);
		}
		public function get up():Boolean {
			return (enable && keyPressedUp);
		}
		public function get down():Boolean {
			return (enable && keyPressedDown);
		}
		public function get jump():Boolean {
			return (enable && keyPressedJump);
		}
		public function get run():Boolean {
			return (enable && keyPressedRun);
		}
		
		public function get keyPressed():Boolean {
			return 	(keyPressedUp || keyPressedDown || keyPressedLeft || keyPressedRight || keyPressedJump);
		}
		
	}
}
