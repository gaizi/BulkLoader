package handler
{
	import comply.BulkLoaderDefine;
	import comply.IBulkFile;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	import loadinginfo.BulkItemLoadingInfo;
	
	public class BulkHandler_Sound extends BulkHandler
	{
		protected var _loader:Sound;
		
		public function BulkHandler_Sound(bulkFile:IBulkFile, bulkLoadingInfo:BulkItemLoadingInfo)
		{
			super(bulkFile, bulkLoadingInfo);
		}
		
		override public function load():void
		{
			super.load();
			
			_loader = new Sound();
			_loader.addEventListener(ProgressEvent.PROGRESS, onProgress, false, 0, true);
			_loader.addEventListener(Event.COMPLETE, onComplete, false, 0, true);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, onError, false, 0, true);
			_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError, false, 0, true);
			_loader.addEventListener(Event.OPEN, onStarted, false, 0, true);
			
			var urlRequest:URLRequest = new URLRequest(fileInfo.fileUrl);
			
			try {
				_loader.load(urlRequest/*, SoundLoaderContext*/);/*TODO: test for security error thown*/
			} catch(e:SecurityError) {
				onError(createErrorEvent(e));
			}
		}
		
		override public function onStarted(event:Event):void
		{
			loadingInfo.sound = _loader;
			super.onStarted(event);
		}
		
		override public function onProgress(event:*):void
		{
			loadingInfo.bytesLoaded = event.bytesLoaded;
			loadingInfo.bytesTotal = event.bytesTotal;
			super.onProgress(event);
		}
	}
}