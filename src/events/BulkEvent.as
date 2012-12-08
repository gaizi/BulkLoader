package events
{
	import blist.IBulkList;
	import blist.IBulkListItem;
	
	import flash.events.Event;
	
	import loadinginfo.IBulkItemLoadingInfo;
	import loadinginfo.IBulkListLoadingInfo;
	
	public class BulkEvent extends Event
	{
		/*Event Types*/
		public static const ITEM_START : String = "itemStart";
		public static const ITEM_PROGRESS : String = "itemProgress";
		public static const ITEM_COMPLETE : String = "itemComplete";
		public static const ITEM_ERROR : String = "itemError";
		public static const LIST_START : String = "listStart";
		public static const LIST_PROGRESS : String = "listProgress";
		public static const LIST_COMPLETE : String = "listComplete";
		
		/*available*/
		public var item:IBulkListItem;
		public var itemLoadingInfo:IBulkItemLoadingInfo;
		
		public var list:IBulkList;
		public var listLoadingInfo:IBulkListLoadingInfo;
		
		public function BulkEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}