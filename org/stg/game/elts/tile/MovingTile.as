package org.stg.game.elts.tile {
	
	/**
	 * @author japanese cake
	 */
	import org.stg.globals.G_Game;
	import org.stg.globals.G_Tile;
	
	import flash.display.MovieClip;		

	final public class MovingTile extends Tile {
		
		// PRIVATE ATTRIBUTES			public var _start			: MovieClip;	
		private var _aPoints		: Array;
		private var _stepping		: MovingTilePoint;
		private var _glue			: Boolean;		private var _block			: Boolean;		private var _firstLoop		: Boolean;
		
		private var _frameOut		: String;		private var _frameOver		: String;
		private var _i				: Number;
		private var _j				: Number;		private var _ox				: Number;		private var _oy				: Number;
		private var _dir			: Number;
		private var _currentPoint	: Number;
		private var _startJ			: Number;		private var _startI			: Number;		private var _halfHeight		: Number;		private var _halfWidth		: Number;		private var _speedFixX		: Number;		private var _speedFixY		: Number;
		
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
			_i = Number(properties.@i);			_j = Number(properties.@j);
//			trace("     + i="+properties.@i);//			trace("     + j="+properties.@j);			_glue = Boolean(properties.@glue);			_block = Boolean(properties.@block);
			_frameOut = (properties.@frameOut==undefined) ? G_Tile.MOVINGTILE_OUT : G_Tile.getTileFrame(Number(properties.@frameOut));			_frameOver = (properties.@frameOver==undefined) ? G_Tile.MOVINGTILE_OVER : G_Tile.getTileFrame(Number(properties.@frameOver));
			//trace("frameOut: "+o.frameOut);			//trace("frameOver: "+_frameOver);
			_ox = _j * G_Game.TILE_SIZE+G_Game.TILE_SIZE/2;			_oy = _i * G_Game.TILE_SIZE+G_Game.TILE_SIZE/2;
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

		// GETTER		public function get frameOut():String {return _frameOut;}		public function get frameOver():String {return _frameOver;}		public function get points():Array {return _aPoints;}		public function get stepping():MovingTilePoint {return _stepping;}		public function get glue():Boolean {return _glue;}		public function get block():Boolean {return _block;}		public function get firstLoop():Boolean {return _firstLoop;}	
		public function get i():Number {return _i;}		public function get j():Number {return _j;}		public function get ox():Number {return _ox;}		public function get oy():Number {return _oy;}		public function get dir():Number {return _dir;}		public function get currentPoint():Number {return _currentPoint;}		public function get startI():Number {return _startI;}		public function get startJ():Number {return _startJ;}		public function get halfHeight():Number {return _halfHeight;}		public function get halfWidth():Number {return _halfWidth;}		public function get speedFixX():Number {return _speedFixX;}		public function get speedFixY():Number {return _speedFixY;}
		
		// SETTER
		public function set frameOut(s:String):void {_frameOut=s;}		public function set frameOver(s:String):void {_frameOver=s;}
		public function set points(a:Array):void {_aPoints=a;}
		public function set stepping(mtp : MovingTilePoint) : void {_stepping=mtp;}		public function set glue(b:Boolean) : void {_glue=b;}		public function set block(b:Boolean) : void {_block=b;}		public function set firstLoop(b:Boolean) : void {_firstLoop=b;}
		public function set i(n:Number):void {_i=n;}
		public function set j(n:Number):void {_j=n;}		public function set ox(n:Number):void {_ox=n;}		public function set oy(n:Number):void {_oy=n;}
		public function set dir(n:Number):void {_dir=n;}
		public function set currentPoint(n:Number):void {_currentPoint=n;}
		public function set startI(n:Number):void {_startI=n;}
		public function set startJ(n:Number):void {_startJ=n;}
		public function set halfHeight(n:Number):void {_halfHeight=n;}
		public function set halfWidth(n:Number):void {_halfWidth=n;}		public function set speedFixX(n:Number):void {_speedFixX=n;}		public function set speedFixY(n:Number):void {_speedFixY=n;}
		
		override public function toString():String {
			return ("MovingTileObject");
		}
		
	}

}