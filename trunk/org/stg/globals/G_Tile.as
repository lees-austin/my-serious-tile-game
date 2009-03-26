﻿package org.stg.globals {	
	/**
	 * @author m.mallet
	 */
	
		public static var NB_TILE_OBJECT	: Number = 0;
		
		public static var TILE				: String = "Tile";
		
		public static var COIN_TILE_ID		: String = "Coin";
		
		public static var EMPTY_FRAME		: String = "_empty";
		public static var BLOCK_FRAME		: String = "_block";
		public static var OPTION_FRAME		: String = "_option";
		public static var BRICK_FRAME		: String = "_brick";
		public static var EMPTY_BLOCK_FRAME	: String = "_emptyBlock";
		public static var DOOR_FRAME		: String = "_door";
		
	
		public static function getTileFrame(frameNumber:Number):String {
			switch (frameNumber)	{
				case 0x50: return SLOPE_LEFT_FRAME;break;
				default: return ERROR_FRAME;
			}
		}
	
	}

}