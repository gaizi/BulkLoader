package handler
{
	import comply.IBulkFile;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.text.StyleSheet;
	import flash.utils.ByteArray;
	
	import loadinginfo.BulkItemLoadingInfo;
	
	public class BulkHandler_Binary extends BulkHandler
	{
		protected var _loader:URLStream;
		
		public function BulkHandler_Binary(bulkFile:IBulkFile, bulkLoadingInfo:BulkItemLoadingInfo)
		{
			super(bulkFile, bulkLoadingInfo);
		}
		
		override public function load():void
		{
			super.load();
			
			_loader = new URLStream();
			_loader.addEventListener(ProgressEvent.PROGRESS, onProgress, false, 0, true);
			_loader.addEventListener(Event.COMPLETE, onComplete, false, 0, true);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, onError, false, 0, true);
			_loader.addEventListener(Event.OPEN, onStarted, false, 0, true);
			
			var urlRequest:URLRequest = new URLRequest(fileInfo.fileUrl);
			try {
				_loader.load(urlRequest);
			} catch (error:Error) {
				createErrorEvent(error);
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
			var bytes:ByteArray = new ByteArray();
			_loader.readBytes(bytes);
			loadingInfo.bytes = bytes;
			super.onComplete(event);
		}
	}
}