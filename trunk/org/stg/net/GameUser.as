package org.stg.net {
	import flash.display.Bitmap;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;	

	/**
	 * @author japanese cake
	 */
	public class GameUser extends EventDispatcher {

		public static var UID		: String;		public static var SID		: String;		public static var PLAYERID	: int;		public static var NAME		: String;		public static var EMAIL		: String;		public static var DATE		: String;		public static var PASSWORD	: String;		public static var AVATAR	: String;		public static var SEX		: String;		public static var COEF		: Number;		public static var EFF		: Number;		public static var TOTALWINS	: Number;		public static var TOTALLOSES: Number;		
		public static var GAMEPAD	: String;
				public static var AVATAR_BITMAP	: Bitmap;
				public static var LEVELID	: Number;
		
		public static function setUserData(xml:XML):void {
			XML.ignoreWhitespace = true;
			UID = xml.uid;				NAME = clearCDATA(xml.name);				EMAIL = clearCDATA(xml.email);				DATE = clearCDATA(xml.date);				PASSWORD = xml.password;				AVATAR = clearCDATA(xml.avatar);				SEX = clearCDATA(xml.sex);				COEF = xml.coef;				TOTALWINS = xml.totalWins;				TOTALLOSES = xml.totalLoses;
			EFF = TOTALWINS / (TOTALWINS + TOTALLOSES) * 100;			EFF = Number(EFF.toFixed(2));
			//trace("USER DATA: "+xml);
		}
		
		public static function clearUserData():void {
			AVATAR_BITMAP = null;
			UID = NAME = EMAIL = DATE = "";
			PASSWORD = AVATAR = SEX = "";
			PLAYERID = COEF = TOTALWINS = TOTALLOSES = EFF = NaN;
		}
		
		private static function errorHandler(e:IOErrorEvent):void {
			trace("GameUser :: "+e);
		}
		
		public static function clearCDATA(s:String):String {
			return s.substring(7, s.length-2);
		}
	}

	
}