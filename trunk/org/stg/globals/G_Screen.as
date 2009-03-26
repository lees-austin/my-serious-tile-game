﻿package org.stg.globals {	

	/**
	 * @author japanese cake
	 */
	public class G_Screen extends Object {
		
		public static var GAME_WIDTH		: Number = 19;
		public static var SCREEN_WIDTH		: Number = GAME_WIDTH*G_Game.TILE_SIZE;
		public static var SCREEN_HEIGHT		: Number = GAME_HEIGHT*G_Game.TILE_SIZE;
		public static var HALF_GAME_WIDTH	: Number = Math.floor(GAME_WIDTH/2);
		public static var HALF_GAME_HEIGHT	: Number = Math.floor(GAME_HEIGHT/2);
		public static var CENTER_X			: Number = (HALF_GAME_WIDTH+1)*G_Game.TILE_SIZE-G_Game.TILE_SIZE/2;
		public static var CENTER_Y			: Number = (HALF_GAME_HEIGHT+1)*G_Game.TILE_SIZE-G_Game.TILE_SIZE/2;
		
		
		public static var MOVING_TILES	: String = "_mcMovingTiles";
		public static var SKIN_DEFAULT	: String = "_default";
		
		
		public static var FIRSTGROUND	: String;
		
		
		
		// GETTER
		public static function get TileLink():String { return TILE_LINK; }
	}

}