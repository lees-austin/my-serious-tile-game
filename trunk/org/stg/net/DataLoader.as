package org.stg.net {
	import flash.system.ApplicationDomain;	
	
	import org.stg.ui.LoadingBox;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;	

	/**
	 * @author japanese cake
	 */
	public class DataLoader extends EventDispatcher {
		
		public static const RETRY		: String = "retry";		public static const POPUP_CLOSED: String = "popup_closed";		public static const COMPLETE	: String = "data_loaded";		public static const ERROR		: String = "error";
		
		private var _loadingBox			: LoadingBox;
				private var _autoCloseOnFinish	: Boolean = true;
		private var _useLoadingBox		: Boolean;		private var _useURLLoader		: Boolean;
		private var _postVars			: URLVariables;
		private var _url				: String;	
		
		public var data					: *;		public var content				: *;

		public function DataLoader(useURLLoader:Boolean = true, loadingBoxContainer : DisplayObjectContainer=null, autoCloseOnComplete:Boolean = true, target : IEventDispatcher = null) {
			super(target);
			
			if (loadingBoxContainer != null) {
				_useLoadingBox = true;
				_autoCloseOnFinish = autoCloseOnComplete;
				_loadingBox = new LoadingBox(loadingBoxContainer);
				loadingBoxContainer.addChild(_loadingBox);
			}else _useLoadingBox = false;
			
			_useURLLoader = useURLLoader;
		}
		
		public function load(url:String, postVars:URLVariables=null, dataFormat:String=URLLoaderDataFormat.TEXT):void {
			trace("DataLoader :: load");
			_postVars = postVars;
			_url = url;
			
			var urlRequest:URLRequest	= new URLRequest(url);
			
			if (_useURLLoader) {
				
				urlRequest.method			= URLRequestMethod.POST;
				urlRequest.data				= _postVars;
				
				var urlloader:URLLoader = new URLLoader();
				urlloader.dataFormat = dataFormat;
				urlloader.addEventListener(Event.COMPLETE, completeHandler);
	            urlloader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
	            urlloader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
	            urlloader.load(urlRequest);
			}else{
				var loader:Loader = new Loader();
				var loaderContext:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
				var loaderInfo : LoaderInfo = loader.contentLoaderInfo;	
				loaderInfo.addEventListener(Event.COMPLETE, completeHandler);
	            loaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler);
	            loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
	            loader.load(urlRequest,loaderContext);
			}

			if (_useLoadingBox) _loadingBox.showMe();
		}
		
		public function retry(evt:Event):void {
			load(_url, _postVars);
		}
		
		private function completeHandler(evt:Event):void {
			trace("DataLoader :: completeHandler");
			
			if (_useURLLoader) data = evt.target.data;
			else content = evt.target.content;
			
			if (_useLoadingBox) {
	            _loadingBox.setComplete();
				
				if (_autoCloseOnFinish) {
					loadingBoxClosed(evt);
				}else{
		            _loadingBox.addEventListener(Event.COMPLETE, loadingBoxClosed);
				}
			}else loadingBoxClosed(evt);
		}
		
		private function progressHandler(evt:Event):void {
			dispatchEvent(evt);
		}
		
		private function errorHandler(evt:IOErrorEvent):void {
			trace("DataLoader :: errorHandler");
			
			if (_useLoadingBox) {
				_loadingBox.addEventListener(RETRY, retry);
				_loadingBox.setRetry();
			}
			
			dispatchEvent(evt);	
		}
		
		private function loadingBoxClosed(evt:Event):void {
			trace("DataLoader :: loadingBoxClosed");
			
			if (_useLoadingBox) {
				_loadingBox.hideMe();
				_loadingBox.removeEventListener(Event.COMPLETE, loadingBoxClosed);
			}
			
			dispatchEvent(evt);
		}
		
	}
}
