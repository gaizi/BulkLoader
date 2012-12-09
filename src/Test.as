package
{
	import blist.BulkList;
	import blist.IBulkListItem;
	
	import comply.BulkLoader;
	import comply.BulkLoaderDefine;
	
	import events.BulkEvent;
	import events.BulkItemLoadingEvent;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class Test extends Sprite
	{
		private var _xml:XML;
		
		public function Test()
		{
			var loadList:BulkList = new BulkList();
			loadList.addEventListener(BulkEvent.ITEM_COMPLETED, onItemComplet);
			
			for (var i:int=0; i<100; i++)
				loadList.addItem("assets/1 (9).png", {});
			
			BulkLoader.to(loadList);
			
			
			//
			//
			
//			BulkLoader.execute(loadList);
		}
		
		protected function onItemComplet(event:BulkEvent):void
		{
//			trace("file:"+event.item.url, " has load complet");
			
			addChild(event.itemLoadingInfo.getBitmap());
		}
	}
}