package org.stg.ui {
	import fl.controls.Button;
	
	import gs.TweenLite;
	import gs.easing.Expo;
	
	import org.stg.net.NetGateway;
	import org.stg.ui.asset.GameTimerAsset;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;	

	/**
	 * @author japanese cake
	 */
	public class UserPanel extends MovieClip {
		
		public var tfUserName	: TextField;		public var tfCnxStatus	: TextField;		public var btDisconnect	: Button;		public var spGameTimer	: GameTimerAsset;
		
		private static var _instance : UserPanel;
		
		public static function getInstance():UserPanel {
			return _instance;
		}

		public function UserPanel () {
			_instance = this;
			btDisconnect.visible = false;
			spGameTimer.visible = false;
			btDisconnect.addEventListener(MouseEvent.MOUSE_UP, disconnectMe);
			tfUserName.text = "";			tfCnxStatus.text = "non connecté au serveur de jeu !";
			y = -2*height;
		}
		
		private function disconnectMe(event:MouseEvent):void {
			trace("UserPanel :: disconnectMe");
			trace(event);
			btDisconnect.enabled = false;
			NetGateway.disconnect();
		}

		public function showMe():void {
			TweenLite.to(this, 0.75, {y:height/2, ease:Expo.easeOut});
		}
		
		public function hideMe():void {
			TweenLite.to(this, 0.75, {y:-height/2, ease:Expo.easeIn});
		}
	}
}
