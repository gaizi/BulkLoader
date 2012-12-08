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
	
	public class Main extends Sprite
	{
		private var _xml:XML;
		
		public function Main()
		{
			var loadList:BulkList = new BulkList();
			loadList.addEventListener(BulkEvent.ITEM_COMPLETE, onItemComplet);
			
			for (var i:int=0; i<1; i++)
				loadList.addItem("assets/1 (9).png", {});
			
			BulkLoader.execute(loadList);
			
			
			//
			//
			
//			BulkLoader.execute(loadList);
		}
		
		protected function onItemComplet(event:BulkEvent):void
		{
			trace("file:"+event.item.url, " has load complet");
			
			addChild(event.itemLoadingInfo.getBitmap());
		}
	}
}