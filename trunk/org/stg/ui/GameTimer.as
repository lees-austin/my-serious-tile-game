package org.stg.ui {
	import org.stg.ui.asset.GameTimerAsset;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;	

	/**
	 * @author japanese cake
	 */
	public class GameTimer extends EventDispatcher {

		public static const TIMEOUT	: String = "timeout";
		
		private static var _instance	: GameTimer; 
		
		private var _lifeTime		: int;		private var _lastSecond		: Boolean;		private var _timer			: Timer;
				private var _callBack		: Function;
		private var _callBackParams	: Array;
		
		private var _visible			: Boolean;
		
		public var asset			: GameTimerAsset;

		public static function getInstance():GameTimer {
			return _instance;
		}

		public function GameTimer(time_to_live : int, callBack : Function, callBackParams : Array = null,lastSecondOnly : Boolean = false, visible = true) {
			_instance = this;
			_lifeTime = time_to_live;
			_callBack = callBack;
			_callBackParams = callBackParams;
			_lastSecond = lastSecondOnly;
			_visible = visible;
			
			asset = UserPanel.getInstance().spGameTimer;			asset.visible = _visible;
			_timer = new Timer(1000,_lifeTime);
			_timer.addEventListener(TimerEvent.TIMER, onTimerEvent);			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerCompleteEvent);
			_timer.start();
		}
		
		public function kill():void {
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerCompleteEvent);
			_timer.stop();
			asset.visible = false;
		}

		private function onTimerEvent(event:TimerEvent):void {
			var currentLeftTime : Number = _lifeTime - event.target.currentCount;		

			if (currentLeftTime < 10) asset.tfTime.text = asset.tfTimeShadow.text = "0" + currentLeftTime.toString();
			else asset.tfTime.text = asset.tfTimeShadow.text = currentLeftTime.toString();
			
			asset.tfTime.visible = asset.tfTimeShadow.visible = (!_lastSecond || (_lastSecond && currentLeftTime <=5) && _visible) ? true : false;

		}
		
		private function onTimerCompleteEvent(event:TimerEvent):void {
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerCompleteEvent);
			_callBack.apply(null, _callBackParams);
			asset.visible = false;
		}
	}
}
