package org.stg.game.elts.tile {
	
	/**
	 * @author japanese cake
	 */
	final public class MovingTilePoint extends Object {
		
		private var _id		: Number;
		private var _j		: Number = 0;		private var _i		: Number = 0;		private var _dirX	: Number = 0;		private var _dirY	: Number = 0;		private var _speedX	: Number = 0;		private var _speedY	: Number = 0;
		
		private var _characterSpeedX : Number = 0;		private var _characterSpeedY : Number = 0;
		
		public function MovingTilePoint(properties:XML) {
			super();
			//trace("MovingTilePoint :: "+properties);
			//for (var a in o) trace(a+"->"+o[a]);
			_id = properties.@id;
			_j = Number(properties.j);
			_i = Number(properties.i);
			_dirX = Number(properties.dirX);
			_dirY = Number(properties.dirY);
			_speedX = Number(properties.speedX);			_speedY = Number(properties.speedY);
		}
		
		// GETTER
		public function get id():Number {return _id;}		public function get j():Number {return _j;}		public function get i():Number {return _i;}		public function get dirX():Number {return _dirX;}		public function get dirY():Number {return _dirY;}		public function get speedX():Number {return _speedX;}		public function get speedY():Number {return _speedY;}		public function get characterSpeedX():Number {return _characterSpeedX;}		public function get characterSpeedY():Number {return _characterSpeedY;}
		
		// SETTER
		public function set id(n:Number):void {_id=n;}		public function set j(n:Number):void {_j=n;}		public function set i(n:Number):void {_i=n;}		public function set dirX(n:Number):void {_dirX=n;}		public function set dirY(n:Number):void {_dirY=n;}		public function set speedX(n:Number):void {_speedX=n;}		public function set speedY(n:Number):void {_speedY=n;}		public function set characterSpeedX(n:Number):void {_characterSpeedX=n;}		public function set characterSpeedY(n:Number):void {_characterSpeedY=n;}
	}
	
}
