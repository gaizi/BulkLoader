package
{
	import comply.BulkLoader;
	import comply.BulkLoaderDefine;
	
	import events.BulkEvent;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import blist.BulkList;
	
	public class Main extends Sprite
	{
		private var _xml:XML;
		
		public function Main()
		{
			var loadList:BulkList = new BulkList();
			for (var i:int=1; i<11; i++)
				loadList.addItem("assets/1 ("+i+").swf", {});
			BulkLoader.execute(loadList);
		}
	}
}