package org.stg.game.elts.tile {
	
	/**
	 * @author japanese cake
	 */
	public class SlopeObject extends Object {
		
		private var _left	: Boolean;
		private var _right	: Boolean;
		
		public function SlopeObject(left:Boolean=false,right:Boolean=false) {
			_left = left;			_right = right;
		}
				
		// GETTER
		public function get left():Boolean { return _left; }		public function get right():Boolean { return _right; }
		
		// SETTER
		public function set left(b:Boolean):void { _left=b; }		public function set right(b:Boolean):void { _right=b; }
	}

}