﻿package org.stg.game.elts.tile {
	
	/**
	 * @author japanese cake
	 */
	import org.stg.globals.G_Game;
	import org.stg.globals.G_Tile;
	
	import flash.display.MovieClip;		

	final public class MovingTile extends Tile {
		
		// PRIVATE ATTRIBUTES	
		private var _aPoints		: Array;
		private var _stepping		: MovingTilePoint;
		private var _glue			: Boolean;
		
		private var _frameOut		: String;
		private var _i				: Number;
		private var _j				: Number;
		private var _dir			: Number;
		private var _currentPoint	: Number;
		private var _startJ			: Number;
		
		public static function copy(mt : MovingTile) : MovingTile {
			return mt;	
		}

		
		// CONSTRUCTOR
		public function MovingTile(properties:XMLList) {
			super();
			//trace("MovingTile :: id="+properties.@id);
			_mc = null;
			_firstLoop = true;
			_currentPoint = 0;
			_dir = 0;
			_i = Number(properties.@i);
//			trace("     + i="+properties.@i);
			_frameOut = (properties.@frameOut==undefined) ? G_Tile.MOVINGTILE_OUT : G_Tile.getTileFrame(Number(properties.@frameOut));
			//trace("frameOut: "+o.frameOut);
			_ox = _j * G_Game.TILE_SIZE+G_Game.TILE_SIZE/2;
			_halfHeight = _halfWidth = G_Game.TILE_SIZE/2;
			_dir = 1;
			_currentPoint = 0;
			_startJ = properties.@j;
			_startI = properties.@i;
			
			_aPoints = new Array();
			for (var i:Number=0;i<properties.points.point.length();i++) {
				addPoint(properties.points.point[i]);
			}
		}
		
		private function addPoint(point:XML):void {
			//trace("MovingTile :: addPoint ="+point);
			_aPoints.push(new MovingTilePoint(point));
		}

		// GETTER
		public function get i():Number {return _i;}
		
		// SETTER
		public function set frameOut(s:String):void {_frameOut=s;}
		public function set points(a:Array):void {_aPoints=a;}
		public function set stepping(mtp : MovingTilePoint) : void {_stepping=mtp;}
		public function set i(n:Number):void {_i=n;}
		public function set j(n:Number):void {_j=n;}
		public function set dir(n:Number):void {_dir=n;}
		public function set currentPoint(n:Number):void {_currentPoint=n;}
		public function set startI(n:Number):void {_startI=n;}
		public function set startJ(n:Number):void {_startJ=n;}
		public function set halfHeight(n:Number):void {_halfHeight=n;}
		public function set halfWidth(n:Number):void {_halfWidth=n;}
		
		override public function toString():String {
			return ("MovingTileObject");
		}
		
	}

}