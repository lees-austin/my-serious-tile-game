package org.stg.ui {
	import fl.controls.Button;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;	

	/**
	 * @author japanese cake
	 */
	public class LoadingBox extends Sprite {
		
		private var _container : DisplayObjectContainer;		public var mcProgressBar : MovieClip;		public var tfStatus : TextField;		public var btAction : Button;
		
		private var _action	: String;
		
		public function LoadingBox(container : DisplayObjectContainer) {
			_container = container;
			btAction.visible = false;
			x = container.x + container.width/2;			y = container.y + container.height/2;
			btAction.addEventListener(MouseEvent.MOUSE_UP, doAction);
			hideMe();
		}

		public function showMe():void {
			visible = true;
			btAction.visible = false;
			tfStatus.text = "Téléchargement en cours...";
		}
		
		public function hideMe():void {
			visible = false;
			btAction.visible = false;
		}
		
		public function setRetry():void {
			showMe();
			_action = "Retry";
			tfStatus.text = "Erreur lors du téléchargement !";
			btAction.label = "Réessayer";
			btAction.visible = true;
			visible = true;
		}
		
		public function setComplete():void {
			_action = Event.COMPLETE;
			tfStatus.text = "Téléchargement terminé !";
			btAction.label = "Continer";
			btAction.visible = true;
			visible = true;
		}
		
		private function doAction(evt:Event):void {
			dispatchEvent(new Event(_action));
		}
	}
}
