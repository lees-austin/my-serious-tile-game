package org.stg.globals {
	
	/**
	 * @author japanese cake
	 */	public class G_Character {
	
		public static var STOP_RIGHT_FRAME	: String = "_stop_right";
		public static var STOP_LEFT_FRAME	: String = "_stop_left";
		public static var WALK_RIGHT_FRAME	: String = "_walk_right";
		public static var WALK_LEFT_FRAME	: String = "_walk_left";
		public static var JUMP_RIGHT_FRAME	: String = "_jump_right";
		public static var JUMP_LEFT_FRAME	: String = "_jump_left";
		public static var CLIMB_RIGHT_FRAME	: String = "_climb_right";
		public static var CLIMB_LEFT_FRAME	: String = "_climb_left";		public static var DRIFT_LEFT_FRAME	: String = "_driftLeft";		public static var DRIFT_RIGHT_FRAME	: String = "_driftRight";
		
		public static var UP_FRAME			: String = "_up";
		public static var DOWN_FRAME		: String = "_down";
		
		public static var MAX_SPEED_X		: Number = 8;
		public static var MAX_SPEED_Y		: Number = -18;
		public static var RUN_SPEED			: Number = 14;		public static var CLIMB_SPEED		: Number = 4;		public static var WALK_SPEED		: Number = 10;
		public static var ACCX				: Number = 0.4;
		public static var ACCY				: Number = 4;
		public static var K					: Number = 0.5;
		public static var F					: Number = 1.2;	
	}

}