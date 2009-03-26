package org.stg.managers {
	import org.stg.core.Config;
	import org.stg.game.elts.tile.DoorTile;
	import org.stg.level.Level;
	import org.stg.level.LevelChild;
	import org.stg.level.XMLLevelInterpreter;
	import org.stg.net.DataLoader;
	import org.stg.net.GameUser;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;	

	/**
	 * @author japanese cake
	 */
	public class LevelManager {
		
		private static var _xmlLevel			: XML;
		private static var _levelsList			: Array;
				private static var _level				: Level;
		private static var _levelChild			: LevelChild;
		private static var _levelListCallBack	: Function;		private static var _levelCallBack		: Function;		private static var _levelChildCallBack	: Function;
				public static var SELECTED_LEVEL		: int=-1;		public static var LEVELS_NUMBER			: int=-1;		public static var nextLevelChildDoor	: DoorTile;
		
		public static function getLevel():Level {
			return getLevelById(SELECTED_LEVEL);
		}
		
		public static function getLevelChild():LevelChild {
			if (_levelChild == null) _levelChild = getLevel().getLevelChild();
			return _levelChild;
		}
		
		public static function getLevelList():Array {
			return _levelsList;
		}
		
		public static function getLevelById(levelId:int):Level {
			return _levelsList[levelId-1];
		}
		
		public static function changeLevelChild(id:Number, callBack:Function = null):void {
			trace("changeLevelChild-->"+id);
			getLevel().CurrentLevelChildNo = id;
			loadCurrentLevelChild();
		}

		private static function loadCurrentLevelChild():void {
			_levelChild = getLevel().getLevelChild();
			trace("LevelManager :: loadCurrentLevelChild -> "+_levelChild.id);
		} 
	
		public static function loadXMLLevelList(callBack:Function):void {
			_levelListCallBack = callBack;

			var dataLoader : DataLoader = new DataLoader();
			dataLoader.addEventListener(Event.COMPLETE, onXMLLevelListLoaded);
			dataLoader.addEventListener(IOErrorEvent.IO_ERROR, ioerror);
			dataLoader.load(Config.HTTP_LEVELS_ADDRESS+"levels.xml");
		}
		
		public static function ioerror(evt:IOErrorEvent):void {
			trace("IOError :: IMPOSSIBLE DE CHARGER LE XML !");
			trace(evt);
		}
		
		public static function loadXMLLevel(callBack:Function):void {
			trace("LevelMnager :: loadXMLLevel","- PlayerlevelNumber="+GameUser.LEVELID,"- ServerLevelNumber=" + SELECTED_LEVEL);
			_levelCallBack = callBack;
			
			var dataLoader : DataLoader = new DataLoader();
			dataLoader.addEventListener(Event.COMPLETE, onXMLLevelLoaded);
			dataLoader.addEventListener(IOErrorEvent.IO_ERROR, ioerror);
			dataLoader.load(Config.HTTP_LEVELS_ADDRESS+getLevelById(SELECTED_LEVEL).xmlFile);
		}
			
		private static function onXMLLevelListLoaded(evt:Event):void {
			trace("LevelManager :: onXMLLevelListLoaded",evt);

			try{
				XML.ignoreWhitespace=true;
				var xml:XML = new XML(evt.target.data);
				if (xml.error.@type == "00") {
					
					LEVELS_NUMBER  = xml.levels.level.length();
					_levelsList = new Array();
					
					for each (var level in xml.levels.level) _levelsList.push(new Level(level));
					//_levelList = new XML(xml.levels);
					_levelListCallBack();
					
				}else{
					trace("LevelManager :: onXMLLevelListLoaded->ERROR="+xml.error.@type);
				}
			}catch(e:Error) {
				trace("LevelManager :: XML Error",e);
			}
		}
		
		private static function onXMLLevelLoaded(evt:Event):void {
			trace("[SUCCESS] Niveau chargé");
			XML.ignoreWhitespace=true;
        	_xmlLevel = new XML(evt.target.data);

        	loadLevelLibrary();
		}
		
		
		private static function loadLevelLibrary():void {
			trace("loadLevelLibrary");
			LibraryManager.loadSharedLibrary(Config.HTTP_LEVELS_ADDRESS + _xmlLevel.@file, onLevelLibraryLoaded);		}

		private static function onLevelLibraryLoaded():void {
			trace("onLevelLibraryLoaded");
			XMLLevelInterpreter.parseAndCreateLevel(getLevel(),_xmlLevel, onLevelBuilt);
		}
		
		public static function onLevelBuilt(data:Level):void {
			trace("Données du niveaux interprétées");
			loadCurrentLevelChild();
			_levelCallBack();
		}

		public static function clean():void {
			_xmlLevel = null;			_levelsList = null;			_level = null;			_levelChild = null;
			_levelListCallBack = null;			_levelCallBack = null;			_levelChildCallBack = null;			nextLevelChildDoor = null;
			SELECTED_LEVEL = LEVELS_NUMBER = -1;
		}
		
	}
	
}
