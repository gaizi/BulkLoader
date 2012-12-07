package handler
{
	import comply.IBulkFile;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;

	public class BulkHandler_NetStream extends BulkHandler
	{
		public function BulkHandler_NetStream(bulkFile:IBulkFile, bulkLoadingInfo:BulkLoadingInfo)
		{
			super(bulkFile, bulkLoadingInfo);
		}
		
		override public function load():void
		{
			super.load();
		}
		
		override public function onStarted(evt:Event):void
		{
			super.onStarted(evt);
		}
		
		override public function onProgress(evt:*):void
		{
			super.onProgress(evt);
		}
		
		override public function onComplete(evt:Event):void
		{
			super.onComplete(evt);
		}
		
		override public function onError(evt:ErrorEvent):void
		{
			super.onError(evt);
		}
	}
}