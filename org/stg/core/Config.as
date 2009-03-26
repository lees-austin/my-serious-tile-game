package org.stg.core {

	/**
	 * @author japanese cake
	 */
	 
	 
	 
	public class Config {
		
		public static var mode					: Namespace;
		
		public static var HOST_SERVER			: String;		public static var SOCKET_SERVER			: String;		public static var SFS_CONFIG_FILE		: String;		public static var BLUEBOX_SERVER		: String;
				public static var HTTP_SERVER_ADDRESS	: String;		public static var HTTP_SCRIPTS_ADDRESS	: String;		public static var HTTP_AVATAR_ADDRESS	: String;		public static var HTTP_LEVELS_ADDRESS	: String;		public static var POLICY_FILE_URL		: String;		public static var MAIN_SWF_FILE_URL		: String;
		
		offline static function setEnvPath():void {
			trace("Path :: setEnvPath to offline mode");
			HOST_SERVER				= "localhost";			SOCKET_SERVER			= "127.0.0.1";			BLUEBOX_SERVER			= "127.0.0.1";
			HTTP_SERVER_ADDRESS		= "http://"+HOST_SERVER+"/stg-as3/";
			HTTP_SCRIPTS_ADDRESS	= HTTP_SERVER_ADDRESS+"scripts/";
			HTTP_AVATAR_ADDRESS		= HTTP_SERVER_ADDRESS+"avatars/";
			HTTP_LEVELS_ADDRESS		= HTTP_SERVER_ADDRESS+"levels/";
			POLICY_FILE_URL			= HTTP_SERVER_ADDRESS+"crossdomain.xml";
			SFS_CONFIG_FILE			= HTTP_SERVER_ADDRESS+"sfs-config-offline.xml";
			MAIN_SWF_FILE_URL		= HTTP_SERVER_ADDRESS+"main.swf";
		}
		
		online static function setEnvPath():void {
			trace("Path :: setEnvPath to online mode");
			//HOST_SERVER				= "mallet.outils-de-referencement.fr";			HOST_SERVER				= "localhost";
			SOCKET_SERVER			= "192.168.1.3";
			BLUEBOX_SERVER			= "192.168.1.3";
			HTTP_SERVER_ADDRESS		= "http://"+HOST_SERVER+"/stg-as3/";
			HTTP_SCRIPTS_ADDRESS	= HTTP_SERVER_ADDRESS+"scripts/";
			HTTP_AVATAR_ADDRESS		= HTTP_SERVER_ADDRESS+"avatars/";
			HTTP_LEVELS_ADDRESS		= HTTP_SERVER_ADDRESS+"levels/";
			POLICY_FILE_URL			= HTTP_SERVER_ADDRESS+"policy.xml";
			SFS_CONFIG_FILE			= HTTP_SERVER_ADDRESS+"sfs-config-online.xml";
			MAIN_SWF_FILE_URL		= HTTP_SERVER_ADDRESS+"main.swf";
		}
	}
}
