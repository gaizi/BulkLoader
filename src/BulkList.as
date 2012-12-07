package
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public dynamic class BulkList extends Array implements IEventDispatcher
	{
		
		/*Event Types*/
		[Event(name="ITEM_START", type="BulkEvent")]
		
		[Event(name="ITEM_PROGRESS", type="BulkEvent")]
		
		[Event(name="ITEM_COMPLETE", type="BulkEvent")]
		
		[Event(name="ITEM_ERROR", type="BulkEvent")]
		
		[Event(name="QUEUE_START", type="BulkEvent")]
		
		[Event(name="QUEUE_PROGRESS", type="BulkEvent")]
		
		[Event(name="QUEUE_COMPLETE", type="BulkEvent")]
		
		
		protected var _eventDispatcher:EventDispatcher = new EventDispatcher();
		
		
		public function BulkList(...parameters)
		{
			super(parameters);
			splice(0, length);
		}
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			_eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			_eventDispatcher.removeEventListener(type, listener, useCapture);
		}
		
		public function dispatchEvent(event:Event):Boolean
		{
			return _eventDispatcher.dispatchEvent(event);
		}
		
		public function hasEventListener(type:String):Boolean
		{
			return _eventDispatcher.hasEventListener(type);
		}
		
		public function willTrigger(type:String):Boolean
		{
			return _eventDispatcher.willTrigger(type);
		}
	}
}