package org.stg.ui.menu {
	import fl.controls.Button;
	
	import com.asual.swfaddress.SWFAddress;
	
	import flash.events.Event;
	import flash.events.MouseEvent;	

	/**
	 * @author japanese cake
	 */
	public class HomeMenu extends Menu {
		
		public var btGotoProfile 	: Button;		public var btGotoGame	 	: Button;
		public var btHistory		: Button;

		public function HomeMenu() {
			SWFAddress.setValue('/homemenu/');
			btGotoProfile.enabled = false;
			btGotoProfile.addEventListener(MouseEvent.CLICK, gotoProfileHandler);			btGotoGame.addEventListener(MouseEvent.CLICK, gotoGameHandler);
			btHistory.addEventListener(MouseEvent.CLICK, viewHistory);
		}
		
		private function viewHistory(evt:Event):void {
//			var js:URLRequest=new URLRequest();
//			js.url="javascript:window.open('pages/history.html','Serious TileGame - History','width=380,height=620');newWindow.focus(); void(0);";
//			navigateToURL(js,'_self');
			SWFAddress.popup('pages/history.html','Serious TileGame - History',"'width=380,height=620'");
		}

		private function gotoProfileHandler(evt:Event):void {
			goto(PROFILE_MENU);
		}
		
		private function gotoGameHandler(evt:Event):void {
			goto(GAME_MENU);
		}
	}
}
