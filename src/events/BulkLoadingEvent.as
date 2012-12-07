package events
{
	import comply.IBulkFile;
	
	import flash.events.Event;
	import handler.BulkLoadingInfo;

	public class BulkLoadingEvent extends Event
	{
		/*Event Types*/
		public static const ITEM_START:String = "start";
		public static const ITEM_PROGRESS:String = "progress";
		public static const ITEM_COMPLETED:String = "completed";
		public static const ITEM_ERROR:String = "error";
		
		/*available*/
		public var fileInfo:IBulkFile;
		public var loadingInfo:BulkLoadingInfo;
		
		public function BulkLoadingEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}