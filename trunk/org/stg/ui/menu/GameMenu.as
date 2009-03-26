package org.stg.ui.menu {
	import fl.controls.Button;
	import fl.controls.RadioButton;
	import fl.controls.RadioButtonGroup;
	
	import com.asual.swfaddress.SWFAddress;
	
	import org.stg.events.MenuEvent;
	import org.stg.net.GameUser;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;	

	/**
	 * @author japanese cake
	 */
	public class GameMenu extends Menu {
		
		public var btStartGame 		: Button;		public var btReturn 		: Button;
		public var PaddleRatioGroup : RadioButtonGroup;
				public var rbWiimote		: RadioButton;		public var rbWiimoteNunchuk	: RadioButton;
		public var rbKeyboard		: RadioButton;
		
		public var spKeyboard		: Sprite;
		public var spWiimote		: Sprite;
		public var spWiimoteNunchuk	: Sprite;

		public function GameMenu() {
			PaddleRatioGroup = new RadioButtonGroup("PaddleRatioGroup");
			btReturn.addEventListener(MouseEvent.CLICK, gotoHome);
			initClickEvent();
			SWFAddress.setValue('/gamemenu/');
		}
		
		private function initClickEvent():void {
			btStartGame.addEventListener(MouseEvent.CLICK, loadLevel);
			spKeyboard.addEventListener(MouseEvent.CLICK, onImageClicked);			spWiimote.addEventListener(MouseEvent.CLICK, onImageClicked);			spWiimoteNunchuk.addEventListener(MouseEvent.CLICK, onImageClicked);
		}

		private function onImageClicked(evt:MouseEvent):void {
			switch (evt.target) {
				case spKeyboard: rbKeyboard.selected = true;
				break;
				case spWiimote: rbWiimote.selected = true;
				break;
				case spWiimoteNunchuk: rbWiimoteNunchuk.selected = true;
				break;
			}
			
		}
		
	
		private function loadLevel(evt:Event):void {
			btStartGame.enabled = false;
			GameUser.GAMEPAD = String(PaddleRatioGroup.selectedData);
			dispatchEvent(new MenuEvent(MenuEvent.START_LOAD_GAME));
		}
		
		private function gotoHome(evt:Event):void {
			goto(HOME_MENU);
		}
	}
}
