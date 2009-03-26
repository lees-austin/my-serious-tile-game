﻿package org.stg.game.elts.tile {	
	/**
	 * @author japanese cake
	 */
	import org.stg.game.elts.character.Character;
	
	import flash.display.MovieClip;	

	public class DoorTile extends Tile {
		
		// PRIVATE ATTRIBUTES
		private var _i					: Number;
		private var _enabled			: Boolean;
		
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
		
		// GETTER
		
		// SETTER
		public function set i(n:Number):void {_i=n;}
		public function set j(n:Number):void {_j=n;}
		public function set newLevelChildID(n:Number):void {_newLevelChildID=n;}
		public function set newDoorID(n:Number):void {_newDoorID=n;}
		public function set newDirX(n:Number):void {_newDirX=n;}
		
	}

}