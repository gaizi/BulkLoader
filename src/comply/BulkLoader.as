package comply
{
	
	import blist.BulkList;
	import blist.IBulkList;
	import blist.IBulkListItem;
	
	import events.BulkEvent;
	import events.BulkLoadingEvent;
	
	import flash.utils.Dictionary;
	
	import handler.BulkHandler;
	import handler.BulkHandler_Loader;
	import handler.BulkHandler_NetStream;
	import handler.BulkHandler_Sound;
	import handler.BulkHandler_UrlLoader;
	import handler.BulkHandler_UrlStream;
	import handler.BulkLoadingInfo;

	public class BulkLoader
	{
		private static var _instance:BulkLoader = new BulkLoader();
		public function BulkLoader()
		{
			if (_instance)
				new Error("BulkLoader is single instance.");
			
			inits();
		}
		
		private function inits():void
		{
			_fileToHandlerCls = new Dictionary(true);
			_fileToHandlerCls[BulkLoaderDefine.FILE_BINARY] = BulkHandler_UrlLoader;
			_fileToHandlerCls[BulkLoaderDefine.FILE_CSS] = BulkHandler_UrlLoader;
			_fileToHandlerCls[BulkLoaderDefine.FILE_FLV] = BulkHandler_NetStream;
			_fileToHandlerCls[BulkLoaderDefine.FILE_IMAGE] = BulkHandler_Loader;
			_fileToHandlerCls[BulkLoaderDefine.FILE_MP3] = BulkHandler_Sound;
			_fileToHandlerCls[BulkLoaderDefine.FILE_SWF] = BulkHandler_Loader;
			_fileToHandlerCls[BulkLoaderDefine.FILE_WAV] = BulkHandler_Sound;
			_fileToHandlerCls[BulkLoaderDefine.FILE_XML] = BulkHandler_UrlLoader;
			_fileToHandlerCls[BulkLoaderDefine.FILE_ZIP] = BulkHandler_UrlStream;
		}
		
		private var _loadedProcessIn:uint = 0; /*文件池加载进度*/
		private var _loadedLinePool:Vector.<IBulkFile> = new Vector.<IBulkFile>(); /*文件池*/
		private var _loading:Vector.<int> = new Vector.<int>(); /*正在加载的文件*/
		
		private var _fileToList:Dictionary = new Dictionary(true);
		private var _fileToHandlerCls:Dictionary;
		private var _fileToLoadingInfo:Dictionary = new Dictionary(true);
		private var _fileToListItem:Dictionary = new Dictionary(true);

		
		private function addIntoLoadedLine(bulkList:IBulkList):void
		{
			var items:Vector.<IBulkListItem> = bulkList.getItems();
			for (var i:int=0; i<items.length; i++)
			{
				var file:IBulkFile = new BulkFile(items[i]);
				_loadedLinePool.push(file);
				
				_fileToList[file] = bulkList;
				_fileToListItem[file] = items[i];
			}
		}
		
		private function activeLoader():void
		{
			while (_loadedLinePool.length > _loadedProcessIn)/*文件池有文件加载*/
			{
				if (_loading.length >= BulkLoaderDefine.MAX_CONCURRENT) /*加载达到最大并发量*/
					break;
					
				var file:IBulkFile = _loadedLinePool[_loadedProcessIn];
				gotoLoadFile(file);
				
				_loading.push(file); /*更新计数器*/
				_loadedProcessIn ++;
			}
			
//			trace("_loading.length:" + _loading.length);
		}
		
		private function gotoLoadFile(file:IBulkFile):void
		{
			var handlerCls:Class = _fileToHandlerCls[file.fileType];
			if (!handlerCls) /*找不到该文件类型的加载处理程序*/
			{
				handlerCls = _fileToHandlerCls[BulkLoaderDefine.FILE_BINARY];
				// or to new error,,
			}
			
			var loadingInfo:BulkLoadingInfo = new BulkLoadingInfo();
			_fileToLoadingInfo[file] = loadingInfo;

			var loadHandler:BulkHandler = new handlerCls(file, loadingInfo);
			loadHandler.addEventListener(BulkLoadingEvent.ITEM_START, onItemStart);
			loadHandler.addEventListener(BulkLoadingEvent.ITEM_PROGRESS, onItemProgress);
			loadHandler.addEventListener(BulkLoadingEvent.ITEM_COMPLETED, onItemComplete);
			loadHandler.addEventListener(BulkLoadingEvent.ITEM_ERROR, onItemError);
			loadHandler.load();
		}
		
		protected function onItemError(event:BulkLoadingEvent):void
		{
			var file:IBulkFile = event.fileInfo;
			var listItem:IBulkListItem = _fileToListItem[file];
			var list:BulkList = _fileToList[file];
			
			/*更新计数*/
			var index:int = _loading.indexOf(file);
			if (index != -1)
			{
				_loading.splice(index, 1);
				activeLoader();
			}
			
			/*throw event*/
			var bulkEvent:BulkEvent;
			var errorEvent:BulkEvent = new BulkEvent(BulkEvent.ITEM_ERROR);
			var isFirstItemOfList:Boolean = isFirstItemOfList(listItem, list);
			var isEndItemOfList:Boolean = isEndItemOfList(listItem, list);
			if (!isFirstItemOfList && !isEndItemOfList)
			{
				list.dispatchEvent(errorEvent);
			}
			else
			{
				if (isFirstItemOfList)
				{
					bulkEvent = new BulkEvent(BulkEvent.BULK_START);
					list.dispatchEvent(bulkEvent);
					
					list.dispatchEvent(errorEvent);
				}
				
				if (isEndItemOfList)
				{
					list.dispatchEvent(errorEvent);
					
					bulkEvent = new BulkEvent(BulkEvent.BULK_COMPLETE);
					list.dispatchEvent(bulkEvent);
				}
			}
		}
		
		protected function onItemComplete(event:BulkLoadingEvent):void
		{
			var file:IBulkFile = event.fileInfo;
			var listItem:IBulkListItem = _fileToListItem[file];
			var list:BulkList = _fileToList[file];
			
			/*更新计数*/
			var index:int = _loading.indexOf(file);
			if (index != -1)
			{
				_loading.splice(index, 1);
				activeLoader();
			}
			
			/*throw event*/
			var itemEvent:BulkEvent = new BulkEvent(BulkEvent.ITEM_COMPLETE);
			list.dispatchEvent(itemEvent);
			
			if (isEndItemOfList(listItem, list))
			{
				var bulkEvent:BulkEvent = new BulkEvent(BulkEvent.BULK_COMPLETE);
				list.dispatchEvent(bulkEvent);
			}
		}
		
		protected function onItemStart(event:BulkLoadingEvent):void
		{
			var file:IBulkFile = event.fileInfo;
			var listItem:IBulkListItem = _fileToListItem[file];
			var list:BulkList = _fileToList[file];
			
			/*throw event*/
			if (isFirstItemOfList(listItem, list))
			{
				var bulkEvent:BulkEvent = new BulkEvent(BulkEvent.BULK_START);
				list.dispatchEvent(bulkEvent);
			}
			
			var itemEvent:BulkEvent = new BulkEvent(BulkEvent.ITEM_START);
			list.dispatchEvent(itemEvent);
		}
		
		protected function onItemProgress(event:BulkLoadingEvent):void
		{
			
		}
		
		protected function isFirstItemOfList(item:IBulkListItem, list:IBulkList):Boolean
		{
			var items:Vector.<IBulkListItem> = list.getItems();
			return (items.length > 0) && (items[0] == item);
		}
		
		protected function isEndItemOfList(item:IBulkListItem, list:IBulkList):Boolean
		{
			var items:Vector.<IBulkListItem> = list.getItems();
			return (items.length > 0) && (items[items.length-1] == item);
		}
		
		////////////////////////////////////////////////////////////////////////////
		public static function execute(list:IBulkList):void
		{
			_instance.addIntoLoadedLine(list);
			_instance.activeLoader();
		}
	}
}