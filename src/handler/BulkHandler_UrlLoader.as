package handler
{
	import comply.BulkLoaderDefine;
	import comply.IBulkFile;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	public class BulkHandler_UrlLoader extends BulkHandler
	{
		protected var _loader:URLLoader;
		
		public function BulkHandler_UrlLoader(bulkFile:IBulkFile, bulkLoadingInfo:BulkLoadingInfo)
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
		
//		override public function onStarted(evt:Event):void
//		{
//			super.onStarted(evt);
//		}
//		
//		override public function onProgress(evt:*):void
//		{
//			super.onProgress(evt);
//		}
//		
//		override public function onComplete(evt:Event):void
//		{
//			super.onComplete(evt);
//		}
//		
//		override public function onError(evt:ErrorEvent):void
//		{
//			super.onError(evt);
//		}
	}
}