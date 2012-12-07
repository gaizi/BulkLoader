package
{
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
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, xmlConfigLoadCompleteHandler);
			loader.load(new URLRequest("assets/config.xml?v=" + Math.random()));
		}
		
		protected function xmlConfigLoadCompleteHandler(event:Event):void
		{
			event.target.removeEventListener(Event.COMPLETE, xmlConfigLoadCompleteHandler);
			
			_xml = new XML(event.target.data);
			loadConf();
		}
		
		private function loadConf():void
		{
			var loadList:BulkList = new BulkList();
			
			var _modules:Object = {};
			for each (var item:XML in _xml.files.item)
			{
				var module:Object = {};
				module.name = String(item.@name);
				module.url = String(item.@url) + "?v=" + Math.random()/*item.@version*/;
				module.version = String(item.@version);
				module.title = String(item.@title);
				_modules[module.title] = module;
			}
			
			for each (var moduleT:Object in _modules)
			{
				var info:Object = { key:moduleT.title, url:moduleT.url };
				if (moduleT.title == "gamedata")
					info.mimeType = BulkLoaderConst.FILE_BINARY;
				
				loadList.push(info);
			}
			
			
			BulkLoader.loadList(loadList);
		}
	}
}