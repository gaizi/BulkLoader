package handler
{
	import comply.IBulkFile;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.StyleSheet;
	
	import loadinginfo.BulkItemLoadingInfo;
	
	public class BulkHandler_Css extends BulkHandler
	{
		protected var _loader:URLLoader;
		
		public function BulkHandler_Css(bulkFile:IBulkFile, bulkLoadingInfo:BulkItemLoadingInfo)
		{
			super(bulkFile, bulkLoadingInfo);
		}
		
		override public function load():void
		{
			super.load();
			
			_loader = new URLLoader();
			_loader.addEventListener(ProgressEvent.PROGRESS, onProgress, false, 0, true);
			_loader.addEventListener(Event.COMPLETE, onComplete, false, 0, true);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, onError, false, 0, true);
			_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError, false, 0, true);
			_loader.addEventListener(Event.OPEN, onStarted, false, 0, true);
			
			var urlRequest:URLRequest = new URLRequest(fileInfo.fileUrl);
			
			try {
				_loader.load(urlRequest);/*TODO: test for security error thown*/
			} catch(e:SecurityError) {
				onError(createErrorEvent(e));
			}
		}
		
		override public function onProgress(event:*):void
		{
			loadingInfo.bytesLoaded = event.bytesLoaded;
			loadingInfo.bytesTotal = event.bytesTotal;
			super.onProgress(event);
		}
		
		override public function onComplete(event:Event):void
		{
			var css:StyleSheet = new StyleSheet();
			css.parseCSS(_loader.data);
			loadingInfo.css = css;
			super.onComplete(event);
		}
	}
}