﻿package org.stg.game.elts.tile {
	
	/**
	 * @author japanese cake
	 */
	import flash.display.MovieClip;	

	public class Tile extends Object {

		public var upBorder			: TileBorder;

		protected var _mc			: MovieClip;
		
		protected var _sFrame		: String;
		
		protected var _bDoor		: Boolean;
		
		public function Tile(walkable:Boolean=false,cloud:Boolean=false,door:Boolean=false,ladder:Boolean=false,slope:SlopeObject=null) {
			super();
			
			upBorder = new TileBorder(walkable,cloud);
			
			_bWalkable	= walkable;
			_slope		= (slope==null) ? new SlopeObject() : slope;
		}
		
		public function isSlope():Boolean {
			return (_slope.left || _slope.right);
		}
		
		public function copy(tile:Tile):void {
			for each (var p : String in tile) {
				this[p] = tile[p];
			}
		}
		
		public function toString():String {
			return "TileObject";
		}
		
		// GETTER
		public function get mc():MovieClip { return _mc; }
		
		// SETTER
		public function set mc(mc:MovieClip):void { _mc=mc; }
	}

}