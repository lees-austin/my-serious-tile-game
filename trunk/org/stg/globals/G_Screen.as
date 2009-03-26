package org.stg.globals {	

	/**
	 * @author japanese cake
	 */
	public class G_Screen extends Object {
		
		public static var GAME_WIDTH		: Number = 19;		public static var GAME_HEIGHT		: Number = 11;
		public static var SCREEN_WIDTH		: Number = GAME_WIDTH*G_Game.TILE_SIZE;
		public static var SCREEN_HEIGHT		: Number = GAME_HEIGHT*G_Game.TILE_SIZE;
		public static var HALF_GAME_WIDTH	: Number = Math.floor(GAME_WIDTH/2);
		public static var HALF_GAME_HEIGHT	: Number = Math.floor(GAME_HEIGHT/2);
		public static var CENTER_X			: Number = (HALF_GAME_WIDTH+1)*G_Game.TILE_SIZE-G_Game.TILE_SIZE/2;
		public static var CENTER_Y			: Number = (HALF_GAME_HEIGHT+1)*G_Game.TILE_SIZE-G_Game.TILE_SIZE/2;
				public static var GAME			: String = "_mcGame";		public static var GAMESCREENMASK : String = "_gameScreenMask";		public static var CHARACTERS	: String = "_mcCharacters";		public static var PLAYER		: String = "_mcCharacter";
				public static var DEBUG		: String = "_mcDebug";		public static var DEBUG_PANEL	: String = "_mcDebugPanel";		public static var GRID			: String = "_mcGrid";		public static var ELEMENTS		: String = "_mcElts";		public static var LAYERS		: String = "_mcLayers";		public static var TILES		: String = "_mcTiles";
		public static var MOVING_TILES	: String = "_mcMovingTiles";		public static var TRANSITIONS	: String = "_mcTransitions";		public static var CONTAINER		: String = "_mcContainer";		
		public static var SKIN_DEFAULT	: String = "_default";				public static var TILE_LINK				: String;		public static var TILE_LINK_PREFIX			: String = "Tile";
				public static var MOVINGTILE_LINK			: String;		public static var MOVINGTILE_LINK_PREFIX	: String = "MovingTile";
				public static var FRAME		: String = "_mcFrame";		public static var GAME_BACKGROUND	: String = "_mcGameBackGround";		public static var BACKGROUND	: String = "_mcBackGround";		public static var MEDIUMGROUND	: String = "_mcMediumGround";
		public static var FIRSTGROUND	: String;
		
		
		
		// GETTER
		public static function get TileLink():String { return TILE_LINK; }		public static function get MovingTileLink():String { return MOVINGTILE_LINK; }		public static function get BgLink():String { return BACKGROUND; }		public static function get MgLink():String { return MEDIUMGROUND; }		public static function get SkinDefaultLink():String { return SKIN_DEFAULT; }
	}

}