package handler
{
	import comply.IBulkFile;
	
	import events.BulkLoadingEvent;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	[Event(name="start", type="events.BulkLoadingEvent")]
	[Event(name="progress", type="events.BulkLoadingEvent")]
	[Event(name="completed", type="events.BulkLoadingEvent")]
	[Event(name="error", type="events.BulkLoadingEvent")]
	
	public class BulkHandler extends EventDispatcher
	{
		private var _fileInfo:IBulkFile;
		private var _loadingInfo:BulkLoadingInfo;
		
		public function BulkHandler(bulkFile:IBulkFile, bulkLoadingInfo:BulkLoadingInfo)
		{
			this._fileInfo = bulkFile;
			this._loadingInfo = bulkLoadingInfo;
		}
		
		public function get fileInfo():IBulkFile
		{
			return _fileInfo;
		}
		
		public function get loadingInfo():BulkLoadingInfo
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
		
		public function onStarted(event:Event):void
		{
			var e:BulkLoadingEvent = new BulkLoadingEvent(BulkLoadingEvent.ITEM_START);
			e.fileInfo = fileInfo;
			e.loadingInfo = loadingInfo;
			dispatchEvent(e);
		}
		
		public function onProgress(event:*):void
		{
			var e:BulkLoadingEvent = new BulkLoadingEvent(BulkLoadingEvent.ITEM_PROGRESS);
			e.fileInfo = fileInfo;
			e.loadingInfo = loadingInfo;
			dispatchEvent(e);
		}
		
		public function onComplete(event:Event):void
		{
			var e:BulkLoadingEvent = new BulkLoadingEvent(BulkLoadingEvent.ITEM_COMPLETED);
			e.fileInfo = fileInfo;
			e.loadingInfo = loadingInfo;
			dispatchEvent(e);
		}
		
		public function onError(event:ErrorEvent):void
		{
			var e:BulkLoadingEvent = new BulkLoadingEvent(BulkLoadingEvent.ITEM_ERROR);
			e.fileInfo = fileInfo;
			e.loadingInfo = loadingInfo;
			dispatchEvent(e);
		}
	}
}