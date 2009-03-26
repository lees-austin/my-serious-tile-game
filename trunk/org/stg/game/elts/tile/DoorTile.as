package org.stg.game.elts.tile {	
	/**
	 * @author japanese cake
	 */
	import org.stg.game.elts.character.Character;
	
	import flash.display.MovieClip;	

	public class DoorTile extends Tile {
		
		// PRIVATE ATTRIBUTES		private var _id					: Number;
		private var _i					: Number;		private var _j					: Number;		private var _newLevelChildID	: Number;		private var _newDoorID			: Number;		private var _newDirX			: Number;		private var _dir				: Number;
		private var _enabled			: Boolean;		private var _lock				: Boolean;
		
		private var _character			: Character;
		

		
		// CONSTRUCTOR
		public function DoorTile(o:Object) {
			super();
			walkable = true;
		}
		
		public override function toString():String {
			return "DoorTile";
		}
		
		public function addDoorProperties(o:XML):void {
			_bDoor = true;
			_id = Number(o.attributes.id);	
			_enabled = (o.attributes.enabled==undefined) ? true:Boolean(o.attributes.enabled);
			_lock = (o.attributes.lock==undefined) ? false:Boolean(o.attributes.lock);
			_i = Number(o.i);	
			_j = Number(o.j);
			trace("DOOR : i="+_i+" | j="+_j);
			_newLevelChildID = Number(o.targetLevelChildId);	
			_newDoorID = Number(o.targetLevelChildDoorId);	
			_newDirX = Number(o.targetDirX);
			_nFrame = Number(o.frame);	
		}
		
		// GETTER		public function get id():Number {return _id;}		public function get i():Number {return _i;}		public function get j():Number {return _j;}		public function get newLevelChildID():Number {return _newLevelChildID;}		public function get newDoorID():Number {return _newDoorID;}		public function get newDirX():Number {return _newDirX;}		public function get dir():Number {return _dir;}		public function get enabled():Boolean {return _enabled;}		public function get lock():Boolean {return _lock;}		public function get character():Character {return _character;}
		
		// SETTER		public function set id(n:Number):void {_id=n;}
		public function set i(n:Number):void {_i=n;}
		public function set j(n:Number):void {_j=n;}
		public function set newLevelChildID(n:Number):void {_newLevelChildID=n;}
		public function set newDoorID(n:Number):void {_newDoorID=n;}
		public function set newDirX(n:Number):void {_newDirX=n;}		public function set dir(n:Number):void {_dir=n;}		public function set enabled(b:Boolean):void {_enabled=b;}		public function set lock(b:Boolean):void {_lock=b;}		public function set character(char:Character):void {_character=char;}
		
	}

}