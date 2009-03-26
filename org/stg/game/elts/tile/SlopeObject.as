﻿package org.stg.game.elts.tile {
	
	/**
	 * @author japanese cake
	 */
	public class SlopeObject extends Object {
		
		private var _left	: Boolean;
		private var _right	: Boolean;
		
		public function SlopeObject(left:Boolean=false,right:Boolean=false) {
			_left = left;
		}
				
		// GETTER
		public function get left():Boolean { return _left; }
		
		// SETTER
		public function set left(b:Boolean):void { _left=b; }
	}

}