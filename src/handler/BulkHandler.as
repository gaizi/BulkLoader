package handler
{
	import comply.IBulkFile;
	
	import events.BulkItemLoadingEvent;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import loadinginfo.BulkItemLoadingInfo;
	
	[Event(name="itemStart", type="events.BulkItemLoadingEvent")]
	[Event(name="itemProgress", type="events.BulkItemLoadingEvent")]
	[Event(name="itemCompleted", type="events.BulkItemLoadingEvent")]
	[Event(name="itemError", type="events.BulkItemLoadingEvent")]
	
	public class BulkHandler extends EventDispatcher
	{
		private var _fileInfo:IBulkFile;
		private var _loadingInfo:BulkItemLoadingInfo;
		
		public function BulkHandler(bulkFile:IBulkFile, bulkLoadingInfo:BulkItemLoadingInfo)
		{
			this._fileInfo = bulkFile;
			this._loadingInfo = bulkLoadingInfo;
		}
		
		public function get fileInfo():IBulkFile
		{
			return _fileInfo;
		}
		
		public function get loadingInfo():BulkItemLoadingInfo
		{
			return _loadingInfo;
		}
		
		protected function createErrorEvent(e:Error):ErrorEvent
		{
			return new ErrorEvent(ErrorEvent.ERROR, false, false, e.message);
		}
		
		public function load():void
		{
			
		}
		
		public function stop():void
		{
			
		}
		
		public function dispose():void
		{
			
		}
		
		public function onStarted(event:Event):void
		{
			loadingInfo.bytesLoaded = 0;
			
			var e:BulkItemLoadingEvent = new BulkItemLoadingEvent(BulkItemLoadingEvent.ITEM_START);
			e.fileInfo = fileInfo;
			e.loadingInfo = loadingInfo;
			dispatchEvent(e);
		}
		
		public function onProgress(event:*):void
		{
			var e:BulkItemLoadingEvent = new BulkItemLoadingEvent(BulkItemLoadingEvent.ITEM_PROGRESS);
			e.fileInfo = fileInfo;
			e.loadingInfo = loadingInfo;
			dispatchEvent(e);
		}
		
		public function onComplete(event:Event):void
		{
			var e:BulkItemLoadingEvent = new BulkItemLoadingEvent(BulkItemLoadingEvent.ITEM_COMPLETED);
			e.fileInfo = fileInfo;
			e.loadingInfo = loadingInfo;
			dispatchEvent(e);
		}
		
		public function onError(event:ErrorEvent):void
		{
			var e:BulkItemLoadingEvent = new BulkItemLoadingEvent(BulkItemLoadingEvent.ITEM_ERROR);
			e.fileInfo = fileInfo;
			e.loadingInfo = loadingInfo;
			dispatchEvent(e);
		}
	}
}