package org.stg.net {
	import org.stg.core.Config;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.text.TextField;	

	/**
	 * @author japanese cake
	 */
	public class GameLoader extends MovieClip {
		
		public static var mode		: Namespace;
		
		public var gameContainer	: Sprite;
				public var tfPercent		: TextField;		public var tfPercentShadow	: TextField;

		public function GameLoader() {
			
		    var paramObj:Object = LoaderInfo(this.root.loaderInfo).parameters;
			GameUser.SID = String(paramObj["sid"]);
			mode = Namespace(paramObj["mode"]);
			Config.mode = Namespace(paramObj["mode"]);			trace("GameLoader :: SID  = "+GameUser.SID);			trace("GameLoader :: MODE = "+Config.mode.toString());
			
			//Path.mode = mode;
			Config.mode::setEnvPath();
			Security.loadPolicyFile(Config.POLICY_FILE_URL);
			//TODO : pb sandbox xmlserver + wiimote
			//Security.loadPolicyFile("xmlsocket://localhost/policy.xml:843");

			tfPercent.text = "0";
			tfPercentShadow.text = "0";
			
			loadSWF();
		}
		
		private function loadSWF():void {
			var loader: Loader = new Loader();
			var mRequest:URLRequest = new URLRequest(Config.MAIN_SWF_FILE_URL);
			var ldrContext:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteHandler, false,0, true);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgressHandler);
			loader.load(mRequest,ldrContext);			
		}
		
		private function onProgressHandler(evt:ProgressEvent):void {
			var percent:Number = evt.bytesLoaded/evt.bytesTotal*100;
			
			tfPercent.text = percent.toFixed();			tfPercentShadow.text = percent.toFixed();
		}
		
		private function onCompleteHandler(evt:Event):void {
			trace("GameLoader :: onCompleteHandler");	
			play();
			gameContainer.addChild(evt.currentTarget.content);
		}
	}
}
