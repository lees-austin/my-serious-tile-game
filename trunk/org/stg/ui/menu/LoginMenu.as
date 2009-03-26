package org.stg.ui.menu {
	import fl.controls.Button;
	import fl.controls.ComboBox;
	import fl.controls.TextInput;
	
	import org.stg.core.Main;
	import org.stg.core.Config;
	import org.stg.events.MenuEvent;
	import org.stg.net.DataLoader;
	import org.stg.net.GameUser;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLVariables;
	import flash.text.TextField;	

	/**
	 * @author japanese cake
	 */
	public class LoginMenu extends Menu {
		
		public var btLogin : Button;		public var cbUserList : ComboBox;		public var tfLogin : TextInput;		public var tfPassword : TextInput;		public var tfStatut : TextField;
		
		public function LoginMenu() {
			
			cbUserList.addEventListener(Event.CHANGE, selectUserAccount);
			
			btLogin.addEventListener(MouseEvent.CLICK, checkLogin);
			
			tfLogin.text = "";			tfLogin.condenseWhite = true;
			
			tfPassword.text = "";
			tfPassword.condenseWhite = true;
			tfPassword.displayAsPassword = true;
			
			tfStatut.text = "";			
		}
		
		private function selectUserAccount(event:Event):void {
			var cb : ComboBox = ComboBox(event.target);
			tfLogin.text = cb.selectedItem.label;			tfPassword.text = cb.selectedItem.data;
		}
		
		private function checkLogin(evt:Event):void {
			btLogin.enabled = false;
			
			if (tfLogin.text.length > 1 && tfPassword.text.length > 1) {
				var postVars : URLVariables = new URLVariables();
	            postVars.email	= tfLogin.text;
	            postVars.password = tfPassword.text;	            postVars.sid = GameUser.SID;
				
				var dataLoader : DataLoader = new DataLoader();
				dataLoader.addEventListener(Event.COMPLETE, _onXmlLoaded,false,0,true);
				dataLoader.addEventListener(IOErrorEvent.IO_ERROR, ioerror);
				dataLoader.load(Config.HTTP_SCRIPTS_ADDRESS+"?script=logUser",postVars);
			}else{
				trace("LoginMenu :: checkLogin->champs vides");
				tfStatut.text = "Veuillez remplir tous les champs !";
				btLogin.enabled = true;
			}
		}

		private function gotoHome(evt:Event=null):void {
			goto(HOME_MENU);
		}
		
		private function _onXmlLoaded(evt : Event) : void{
			
			try{
        		var xml:XML = new XML(evt.target.data);
			
				if (xml.error.@type == "00") {			
					GameUser.setUserData(xml);
					Main.setStatut({userName:GameUser.NAME});
					Main.getInstance().userPanel.showMe();
					tfStatut.text = "login réussit !";
					dispatchEvent(new MenuEvent(MenuEvent.AUTHENTIFIED));
				}else{
					trace("XML:: error=" + xml.error.@type);
					tfStatut.text = GameUser.clearCDATA(xml.error);
					btLogin.enabled = true;
				}
			}catch(e:Error) {
				trace("LoginMenu :: XML Error");
				trace(e);
				tfStatut.text = "Erreur lors du chargement des données !";
				btLogin.enabled = true;
			}
		}
		
		private function ioerror(e:IOErrorEvent):void {
			trace("LoginMenu :: ioerror");			trace(e);
			tfStatut.text = "Erreur lors du chargement des données !";
			btLogin.enabled = true;
		}
	}
}
