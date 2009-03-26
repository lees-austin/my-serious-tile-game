	package org.stg.ui.menu {
	import fl.controls.Button;
	
	import org.stg.core.Config;
	import org.stg.net.DataLoader;
	import org.stg.net.GameUser;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;	

	/**
	 * @author japanese cake
	 */
	public class ProfileMenu extends Menu {
		
		public var btSaveProfile		: Button;		public var btReturn			 	: Button;
				public var mcAvatarContainer 	: Sprite;
		
		public var tfName				: TextField;		public var tfEmail				: TextField;		public var tfDate				: TextField;		public var tfSex				: TextField;		public var tfTotalWin			: TextField;		public var tfTotalLose			: TextField;		public var tfEff				: TextField;		public var tfCoef				: TextField;
		
		private var textFormat			: TextFormat;
		
		public function ProfileMenu() {
			btSaveProfile.addEventListener(MouseEvent.CLICK, gotoHome);
			btReturn.addEventListener(MouseEvent.CLICK, gotoHome);
			//textFormat = new TextFormat("PoliceProfil*",14,0xFFFFFF,null,null,null,null, null, TextFormatAlign.RIGHT);
			//Font.registerFont(ApplicationDomain.currentDomain.getDefinition("PoliceProfil") as Class);
			//tfName.setTextFormat(textFormat);
						tfName.text = GameUser.NAME;
			tfName.autoSize = TextFieldAutoSize.CENTER;
			
			tfEmail.text = "("+GameUser.EMAIL+")";
			tfEmail.autoSize = TextFieldAutoSize.CENTER;
						tfDate.text = "Inscrit le "+GameUser.DATE;			tfSex.text = (GameUser.SEX = "m") ? "Homme": "Femme";			
			tfEff.text = "Efficacité : "+GameUser.EFF.toString() + " %";			tfCoef.text = "Coefficient : "+GameUser.COEF.toString();			tfTotalWin.text = "Vistoires : "+GameUser.TOTALWINS.toString();			tfTotalLose.text = "Défaites : "+GameUser.TOTALLOSES.toString();
			
			loadAvatar();			
		}

		private function loadAvatar():void {
			var dataLoader : DataLoader = new DataLoader(false);
			dataLoader.addEventListener(Event.COMPLETE, completeHandler);
			dataLoader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			dataLoader.load(Config.HTTP_AVATAR_ADDRESS+GameUser.AVATAR);
		}
		
		private function completeHandler(evt:Event):void {
			var avatarBitmap : Bitmap = Bitmap(evt.target.content);
			avatarBitmap.smoothing = true;
			avatarBitmap.width = 98;			avatarBitmap.height = 98;
			avatarBitmap.x = avatarBitmap.y = 1;
			mcAvatarContainer.addChildAt(avatarBitmap,2);
			GameUser.AVATAR_BITMAP = avatarBitmap;
		}

		private function errorHandler(e:IOErrorEvent):void {
			trace(e);
		}
		
		private function gotoHome(evt:Event):void {
			goto(HOME_MENU);
		}
	}
}
