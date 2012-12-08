package events
{
	import comply.IBulkFile;
	
	import flash.events.Event;
	
	import loadinginfo.IBulkItemLoadingInfo;

	public class BulkItemLoadingEvent extends Event
	{
		/*Event Types*/
		public static const ITEM_START:String = "itemStart";
		public static const ITEM_PROGRESS:String = "itemProgress";
		public static const ITEM_COMPLETED:String = "itemCompleted";
		public static const ITEM_ERROR:String = "itemError";
		
		/*available*/
		public var fileInfo:IBulkFile; /*加载的文件*/
		public var loadingInfo:IBulkItemLoadingInfo; /*文件加载过程中的所有数据*/
		
		public function BulkItemLoadingEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}