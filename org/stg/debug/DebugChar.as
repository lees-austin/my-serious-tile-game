package org.stg.debug {
	import org.stg.game.elts.character.Character;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;	

	/**
	 * @author japanese cake
	 */
	public class DebugChar extends Sprite {
		
		public var upLeft		: MovieClip;		public var upRight		: MovieClip;		public var downLeft		: MovieClip;		public var downRight	: MovieClip;
		
		public function DebugChar() {
			super();
		}
		
		public function updateCharCorner(char:Character):void {
				if (char.cornerUpLeft) upLeft.gotoAndStop("free");
				else upLeft.gotoAndStop("full");
				
				if (char.cornerUpRight) upRight.gotoAndStop("free");
				else upRight.gotoAndStop("full");
				
				if (char.cornerDownLeft) downLeft.gotoAndStop("free");
				else downLeft.gotoAndStop("full");
				
				if (char.cornerDownRight) downRight.gotoAndStop("free");
				else downRight.gotoAndStop("full");
		}
	}
}
