package events
{
	import flash.events.Event;
	
	public class BulkEvent extends Event
	{
		/*Event Types*/
		public static var ITEM_START : String = "itemStart";
		public static var ITEM_PROGRESS : String = "itemProgress";
		public static var ITEM_COMPLETE : String = "itemComplete";
		public static var ITEM_ERROR : String = "itemError";
		public static var BULK_START : String = "queueStart";
		public static var QUEUE_PROGRESS : String = "queueProgress";
		public static var BULK_COMPLETE : String = "queueComplete";
		
		/*available*/
		public var content:*;
		
		public function BulkEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}