﻿package org.stg.net {
	import flash.display.Bitmap;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;	

	/**
	 * @author japanese cake
	 */
	public class GameUser extends EventDispatcher {

		public static var UID		: String;
		public static var GAMEPAD	: String;
		
		
		
		public static function setUserData(xml:XML):void {
			XML.ignoreWhitespace = true;
			UID = xml.uid;	
			EFF = TOTALWINS / (TOTALWINS + TOTALLOSES) * 100;
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