package org.stg.ui.asset {
	import flash.display.Sprite;
	import flash.text.TextField;	

	/**
	 * @author japanese cake
	 */
	public class GameTimerAsset extends Sprite {
		
		public var tfTime			: TextField;
		public var tfTimeShadow		: TextField;
		
		public function GameTimerAsset() {
			tfTime.text = tfTimeShadow.text = "";
		}
	}
}
