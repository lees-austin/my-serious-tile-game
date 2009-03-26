package org.stg.managers {
	import org.stg.core.Main;
	import org.stg.level.Level;
	import org.stg.level.LevelChild;
	import org.stg.net.DataLoader;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoaderDataFormat;
	import flash.system.ApplicationDomain;	

	/**
	 * @author japanese cake
	 */
	public class LibraryManager extends EventDispatcher {

		private static var _callBack			:Function;
				public static var _classDefinitions	:Array;
		
		public static function loadSharedLibrary(libraryUrl:String, callBack:Function=null):void {
			trace("loadSharedLibrary :: try->"+libraryUrl);
			_callBack = callBack;
			_classDefinitions = new Array();
			var dataLoader : DataLoader = new DataLoader(false,Main.getInstance().gameMenu);
			dataLoader.addEventListener(Event.COMPLETE, completeHandler);
			dataLoader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);			dataLoader.load(libraryUrl);
		}

		public static function completeHandler(evt:Event):void {
			_callBack();
		}
		
		private static function errorHandler(evt:Event):void {
			trace(evt);
		}
		
		public static function setClassDefinition(levelChildId : Number, levelChildClassDef : XMLList):void {
			try{
				_classDefinitions[levelChildId]					= new Object();
				_classDefinitions[levelChildId].tile			= Class(getClassRef(levelChildClassDef.tile));				_classDefinitions[levelChildId].movingTile 		= Class(getClassRef(levelChildClassDef.movingTile));				_classDefinitions[levelChildId].character		= Class(getClassRef(levelChildClassDef.character));				_classDefinitions[levelChildId].background		= Class(getClassRef(levelChildClassDef.background));				_classDefinitions[levelChildId].mediumground	= Class(getClassRef(levelChildClassDef.mediumground));
			} catch (e:Error) {
				trace("LibraryManager :: une référence de classe est manquante");	
			}
		}
		
		public static function get TileClassRef():Class {
			return _classDefinitions[LevelManager.getLevel().getLevelChild().id].tile as Class;
		}
		
		public static function get MovingTileClassRef():Class {
			return _classDefinitions[LevelManager.getLevel().getLevelChild().id].movingTile as Class;
		}
				
		public static function get CharacterClassRef():Class {
			return _classDefinitions[LevelManager.getLevel().getLevelChild().id].character as Class;
		}
		
		public static function get BackgroundClassRef():Class {
			return _classDefinitions[LevelManager.getLevel().getLevelChild().id].background as Class;
		}
		
		public static function get MediumgroundClassRef():Class {
			return _classDefinitions[LevelManager.getLevel().getLevelChild().id].mediumground as Class;
		}

		private static function getClassRef(className:String):Class {
						
			try {
            	return ApplicationDomain.currentDomain.getDefinition(className) as Class;
	        } catch (e:Error) {
	            //throw new IllegalOperationError(className + " definition not found");
	            return MovieClip;
	        }
	        
	        return null as Class;
	        
		}
		
	}
}
