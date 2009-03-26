﻿package org.stg.game.elts.tile {
	
	/**
	 * @author japanese cake
	 */
	final public class MovingTilePoint extends Object {
		
		private var _id		: Number;
		private var _j		: Number = 0;
		
		private var _characterSpeedX : Number = 0;
		
		public function MovingTilePoint(properties:XML) {
			super();
			//trace("MovingTilePoint :: "+properties);
			//for (var a in o) trace(a+"->"+o[a]);
			_id = properties.@id;
			_j = Number(properties.j);
			_i = Number(properties.i);
			_dirX = Number(properties.dirX);
			_dirY = Number(properties.dirY);
			_speedX = Number(properties.speedX);
		}
		
		// GETTER
		public function get id():Number {return _id;}
		
		// SETTER
		public function set id(n:Number):void {_id=n;}
	}
	
}