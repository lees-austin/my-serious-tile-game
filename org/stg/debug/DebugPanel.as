package org.stg.debug {
	import flash.display.Sprite;
	import flash.text.TextField;	

	/**
	 * @author japanese cake
	 */
	public class DebugPanel extends Sprite {
		
		private static var _instance	: DebugPanel;
		
		public var mcDebugChar			: DebugChar;
		public var tfCharJump			: TextField;
		public var tfOnMovingBlockTile	: TextField;
		public var tfCharSpeed			: TextField;
		public var tfEffDirX			: TextField;
		public var tfCharDirX			: TextField;
		public var tfCharLastDirX		: TextField;
		public var tfIsOnSlope			: TextField;
		public var tfCharI				: TextField;
		public var tfCharJ				: TextField;
		
		public static function getInstance() : DebugPanel {
			return _instance;
		}

		public function DebugPanel() {
			_instance = this;
			visible = false;
		}
	}
}
