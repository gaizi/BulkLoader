package handler
{
	import comply.BulkLoaderDefine;
	import comply.IBulkFile;
	
	import flash.display.Loader;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	public class BulkHandler_Loader extends BulkHandler
	{
		protected var _loader:Loader;
		
		public function BulkHandler_Loader(bulkFile:IBulkFile, bulkLoadingInfo:BulkLoadingInfo)
		{
			super(bulkFile, bulkLoadingInfo);
		}
		
		override public function load():void
		{
			super.load();
			
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress/*, false, 0, true*/);
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete/*, false, 0, true*/);
			_loader.contentLoaderInfo.addEventListener(Event.INIT, onStarted/*, false, 0, true*/);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError/*, false, 100, true*/);
			_loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError/*, false, 0, true*/);
			_loader.contentLoaderInfo.addEventListener(Event.OPEN, onStarted/*, false, 0, true*/);
			
			var urlRequest:URLRequest = new URLRequest(fileInfo.fileUrl);
			var context:LoaderContext = BulkLoaderDefine.getLoaderContext();
			
			try {
				_loader.load(urlRequest, context);/*TODO: test for security error thown*/
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