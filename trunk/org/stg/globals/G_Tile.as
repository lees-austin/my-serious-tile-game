package org.stg.globals {	
	/**
	 * @author m.mallet
	 */	public class G_Tile extends Object {
	
		public static var NB_TILE_OBJECT	: Number = 0;
		
		public static var TILE				: String = "Tile";
		
		public static var COIN_TILE_ID		: String = "Coin";
		
		public static var EMPTY_FRAME		: String = "_empty";
		public static var BLOCK_FRAME		: String = "_block";
		public static var OPTION_FRAME		: String = "_option";
		public static var BRICK_FRAME		: String = "_brick";
		public static var EMPTY_BLOCK_FRAME	: String = "_emptyBlock";
		public static var DOOR_FRAME		: String = "_door";		public static var CLOUD_FRAME		: String = "_cloud";		public static var LADDER_FRAME		: String = "_ladder";		public static var SLOPE_RIGHT_FRAME	: String = "_slopeRight";		public static var SLOPE_LEFT_FRAME	: String = "_slopeLeft";
				public static var MOVINGTILE_OUT	: String = "_movingTileOut";		public static var MOVINGTILE_OVER	: String = "_movingTileOver";			public static var ERROR_FRAME		: String = "_error";
	
		public static function getTileFrame(frameNumber:Number):String {
			switch (frameNumber)	{
				case 0x50: return SLOPE_LEFT_FRAME;break;				case 0x46: return SLOPE_RIGHT_FRAME;break;				case 0x3c: return LADDER_FRAME;break;				case 0x1e: return MOVINGTILE_OUT;break;				case 0x1d: return MOVINGTILE_OVER;break;				case 0x1c: return CLOUD_FRAME;break;				case 0x6e: return DOOR_FRAME;break;				case 0xff: return EMPTY_FRAME;break;				case 0x01: return BRICK_FRAME;break;				case 0x00: return BLOCK_FRAME;break;
				default: return ERROR_FRAME;
			}
		}
	
	}

}