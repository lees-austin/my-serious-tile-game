package org.stg.game.elts.tile {
	
	/**
	 * @author japanese cake
	 */
	import flash.display.MovieClip;	

	public class Tile extends Object {

		public var upBorder			: TileBorder;		public var downBorder		: TileBorder;		public var leftBorder		: TileBorder;		public var rightBorder		: TileBorder;

		protected var _mc			: MovieClip;
		
		protected var _sFrame		: String;		protected var _nFrame		: Number;
				protected var _bWalkable	: Boolean;		protected var _bCloud		: Boolean;		protected var _bLadder		: Boolean;
		protected var _bDoor		: Boolean;		protected var _slope		: SlopeObject;
		
		public function Tile(walkable:Boolean=false,cloud:Boolean=false,door:Boolean=false,ladder:Boolean=false,slope:SlopeObject=null) {
			super();
			
			upBorder = new TileBorder(walkable,cloud);			downBorder = new TileBorder(walkable,cloud);			leftBorder = new TileBorder(walkable,cloud);			rightBorder = new TileBorder(walkable,cloud);
			
			_bWalkable	= walkable;			_bCloud		= cloud;			_bDoor		= door;			_bLadder	= ladder;
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
		public function get mc():MovieClip { return _mc; }		public function get frameNumber():Number { return _nFrame; }		public function get frameName():String { return _sFrame; }		public function get walkable():Boolean { return _bWalkable; }		public function get cloud():Boolean { return _bCloud; }		public function get door():Boolean { return _bDoor; }		public function get ladder():Boolean { return _bLadder; }		public function get slope():SlopeObject { return _slope; }
		
		// SETTER
		public function set mc(mc:MovieClip):void { _mc=mc; }		public function set frameNumber(n:Number):void { _nFrame=n; }		public function set frameName(s:String):void { _sFrame=s; }		public function set walkable(b:Boolean):void { _bWalkable=b; }		public function set cloud(b:Boolean):void { _bCloud=b; }		public function set door(b:Boolean):void { _bDoor=b; }		public function set ladder(b:Boolean):void { _bLadder=b; }		public function set slope(so:SlopeObject):void { _slope=so; }
	}

}
