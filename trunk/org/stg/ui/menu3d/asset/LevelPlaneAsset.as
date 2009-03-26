package org.stg.ui.menu3d.asset {
	import org.stg.core.Support3D;
	import org.stg.net.GameUser;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;	

	/**
	 * @author japanese cake
	 */
	public class LevelPlaneAsset extends MovieClip {
		
		private var _id			: int;		public var active		: Boolean;
		public var sbJouer		: SimpleButton;		public var tfName 		: TextField;		public var tfNameShadow : TextField;

		
		public function LevelPlaneAsset(id : int, name:String) {
			sbJouer.addEventListener(MouseEvent.CLICK, chooseMe);			sbJouer.addEventListener(MouseEvent.MOUSE_OVER, changeToButtonCursor);			sbJouer.addEventListener(MouseEvent.MOUSE_OUT, changeToNormalCursor);

			tfName.text = tfNameShadow.text = name;
			_id = id;
			active = false;
		}

		public function chooseMe(event:MouseEvent = null, enableEvent:Boolean = true):void {
			if (active || event==null) {
				trace("LevelPlaneAsset :: chooseMe (" + _id +")");
				gotoAndStop(3);
				active = false;
				GameUser.LEVELID = _id;
				
				sbJouer.removeEventListener(MouseEvent.CLICK, chooseMe);
				
				if (enableEvent) dispatchEvent(new Event(Support3D.LEVEL_SELECTED));
			}
		}
		
		private function changeToButtonCursor(event:MouseEvent):void {
			Mouse.cursor = MouseCursor.BUTTON;
		}
		
		private function changeToNormalCursor(event:MouseEvent):void {
			Mouse.cursor = MouseCursor.AUTO;
		}

		public function get id():int { return _id; }
	}
}
