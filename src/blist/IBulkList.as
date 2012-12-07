package blist
{
	import flash.events.IEventDispatcher;
	
	public interface IBulkList extends IEventDispatcher
	{
		function addItem(url:String, param:Object):IBulkListItem;
		function getItems():Vector.<IBulkListItem>;
	}
}