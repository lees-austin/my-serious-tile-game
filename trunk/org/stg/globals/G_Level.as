package org.stg.globals {

	/**
	 * @author japanese cake
	 */
	 
	public class G_Level {
	
		public static var LEVELS_NUMBER		: Number;
		public static var SELECTED_LEVEL	: Number;
		public static var CURRENT_LEVELCHILD : Number;

		// LENGTH
		public static const TILE_HEX_LENGTH			: Number = 4;
		public static const FRAME_HEX_LENGTH			: Number = 2;
		public static const PROPERTIES_HEX_LENGTH	: Number = 2;
		
		// OFFSET
		public static const FRAME_OFFSET			: Number = 0;
		public static const PROPERTIES_OFFSET	: Number = 2;
		public static const WALKABLE_OFFSET		: Number = 0;
		public static const CLOUD_OFFSET			: Number = 1;
		public static const SLOPE_OFFSET			: Number = 2;
		public static const LADDER_OFFSET		: Number = 3;
		public static const DOOR_OFFSET			: Number = 4;
		
		
		public static function get LevelsNumber():Number {
			return LEVELS_NUMBER;
		}
	
		public static function get CurrentLevel():Number {
			return SELECTED_LEVEL;
		}
		
		public static function get CurrentLevelChild():Number {
			return CURRENT_LEVELCHILD;
		}
		
		public static function set CurrentLevel(n:Number):void {
			SELECTED_LEVEL = n;
		}
		
		public static function set CurrentLevelChild(n:Number):void {
			CURRENT_LEVELCHILD = n;
		}
	}
}
