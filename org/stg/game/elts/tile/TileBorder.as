package org.stg.game.elts.tile {

	/**
	 * @author japanese cake
	 */
	public class TileBorder extends Object {
		
		protected var _bWalkable	: Boolean;
		protected var _bCloud		: Boolean;
		
		public function TileBorder(walkable:Boolean=false,cloud:Boolean=false) {			
			_bWalkable	= walkable;
			_bCloud		= cloud;
		}
		
		public function toString():String {
			return "TileBorderObject";
		}
		
		// GETTER
		public function get walkable():Boolean { return _bWalkable; }
		public function get cloud():Boolean { return _bCloud; }
		
		// SETTER
		public function set walkable(b:Boolean):void { _bWalkable=b; }
		public function set cloud(b:Boolean):void { _bCloud=b; }
	}
}
