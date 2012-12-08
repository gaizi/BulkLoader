package blist
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	/*Event Types*/
	[Event(name="itemStart", type="events.BulkEvent")]
	[Event(name="itemProgress", type="events.BulkEvent")]
	[Event(name="itemComplete", type="events.BulkEvent")]
	[Event(name="itemError", type="events.BulkEvent")]
	[Event(name="listStart", type="events.BulkEvent")]
	[Event(name="listProgress", type="events.BulkEvent")]
	[Event(name="listComplete", type="events.BulkEvent")]
	
	public class BulkList extends EventDispatcher implements IBulkList
	{
		public function BulkList()
		{
			super();
		}
		
		public function addItem(url:String, param:Object):IBulkListItem
		{
			var item:BulkListItem = new BulkListItem(url, param);
			_items.push(item);
			
			return item;
		}
		
		public function getItems():Vector.<IBulkListItem>
		{
			return _items.concat();
		}
		
		//
		private var _items:Vector.<IBulkListItem> = new Vector.<IBulkListItem>();
	}
}