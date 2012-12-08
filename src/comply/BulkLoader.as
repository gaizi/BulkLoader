package comply
{
	
	import blist.BulkList;
	import blist.IBulkList;
	import blist.IBulkListItem;
	
	import events.BulkEvent;
	import events.BulkItemLoadingEvent;
	
	import flash.utils.Dictionary;
	
	import handler.BulkHandler;
	import handler.BulkHandler_Binary;
	import handler.BulkHandler_Css;
	import handler.BulkHandler_Img;
	import handler.BulkHandler_Sound;
	import handler.BulkHandler_Swf;
	import handler.BulkHandler_Xml;
	
	import loadinginfo.BulkItemLoadingInfo;
	import loadinginfo.BulkListLoadingInfo;
	import loadinginfo.IBulkItemLoadingInfo;
	import loadinginfo.IBulkListLoadingInfo;

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
			_fileTypeToHandlerCls = new Dictionary(true);
			_fileTypeToHandlerCls[BulkLoaderDefine.FILE_BINARY] = BulkHandler_Binary;
			_fileTypeToHandlerCls[BulkLoaderDefine.FILE_CSS] = BulkHandler_Css;
			_fileTypeToHandlerCls[BulkLoaderDefine.FILE_FLV] = null;
			_fileTypeToHandlerCls[BulkLoaderDefine.FILE_IMAGE] = BulkHandler_Img;
			_fileTypeToHandlerCls[BulkLoaderDefine.FILE_MP3] = BulkHandler_Sound;
			_fileTypeToHandlerCls[BulkLoaderDefine.FILE_SWF] = BulkHandler_Swf;
			_fileTypeToHandlerCls[BulkLoaderDefine.FILE_WAV] = BulkHandler_Sound;
			_fileTypeToHandlerCls[BulkLoaderDefine.FILE_XML] = BulkHandler_Xml;
		}
		
		private var _loadedProcessIn:uint = 0; /*文件池加载进度*/
		private var _loadedLinePool:Vector.<IBulkFile> = new Vector.<IBulkFile>(); /*文件池*/
		private var _loading:Vector.<int> = new Vector.<int>(); /*正在加载的文件*/
		
		private var _fileTypeToHandlerCls:Dictionary; /*BulkFileType-BulkHandler Class Type*/
		private var _fileToHandlerInstance:Dictionary = new Dictionary(true); /*BulkFile-BulkHandler*/
		private var _fileToList:Dictionary = new Dictionary(true); /*BulkFile-BulkList*/
		private var _fileToitem:Dictionary = new Dictionary(true); /*BulkFile-BulkListItem*/
		private var _itemToFile:Dictionary = new Dictionary(true); /*BulkListItem-BulkFile*/
		private var _fileToLoadingInfo:Dictionary = new Dictionary(true); /*BulkFile-BulkItemLoadingInfo*/
		private var _listToLoadingInfo:Dictionary = new Dictionary(true); /*BulkList-BulkListLoadingInfo*/
		
		private function addIntoLoadedLine(bulkList:IBulkList):void
		{
			var listItems:Vector.<IBulkListItem> = bulkList.getItems(); /*Copy浅列表*/
			
			for (var i:int=0; i<listItems.length; i++)
			{
				var listItem:IBulkListItem = listItems[i];
				var file:IBulkFile = new BulkFile(listItem); /*创建文件并添加到文件池*/
				_loadedLinePool.push(file);
				
				_fileToList[file] = bulkList;
				_fileToitem[file] = listItem;
				_itemToFile[listItem] = file;
				_fileToLoadingInfo[file] = new BulkItemLoadingInfo();
			}
			
			_listToLoadingInfo[bulkList] = new BulkListLoadingInfo();
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
		}
		
		private function gotoLoadFile(file:IBulkFile):void
		{
			var handlerCls:Class = _fileTypeToHandlerCls[file.fileType];
			if (!handlerCls) /*找不到该文件类型的加载处理程序*/
			{
//				handlerCls = _fileTypeToHandlerCls[BulkLoaderDefine.FILE_BINARY];
				// or to new error,,
				new Error("you may load fileType("+file.fileType+") of BulkLoader is not support.");
			}
			
			var loadHandler:BulkHandler = new handlerCls(file, _fileToLoadingInfo[file]);
			loadHandler.addEventListener(BulkItemLoadingEvent.ITEM_START, onItemStart);
			loadHandler.addEventListener(BulkItemLoadingEvent.ITEM_PROGRESS, onItemProgress);
			loadHandler.addEventListener(BulkItemLoadingEvent.ITEM_COMPLETED, onItemComplete);
			loadHandler.addEventListener(BulkItemLoadingEvent.ITEM_ERROR, onItemError);
			_fileToHandlerInstance[loadHandler] = loadHandler;
			loadHandler.load();
		}
		
		/////////////////////////////////////////////////////////////////////////////////////////////
		protected function onItemError(event:BulkItemLoadingEvent):void
		{
			var file:IBulkFile = event.fileInfo;
			var listItem:IBulkListItem = _fileToitem[file];
			var list:BulkList = _fileToList[file];
			
			/*更新计数*/
			var index:int = _loading.indexOf(file);
			if (index != -1)
			{
				_loading.splice(index, 1);
				activeLoader();
			}
			
			/*throw event*/
			if (isFirstItemOfList(listItem, list))
				throwListStart(file);
			
			var itemErrorEvent:BulkEvent = new BulkEvent(BulkEvent.ITEM_ERROR);
			itemErrorEvent.item = listItem;
			itemErrorEvent.itemLoadingInfo = event.loadingInfo;
			itemErrorEvent.list = list;
			itemErrorEvent.listLoadingInfo = getLatestListLoadingInfo(list);
			list.dispatchEvent(itemErrorEvent);
			
			if (isEndItemOfList(listItem, list))
				throwListComplete(file);
		}
		
		private function throwListComplete(file:IBulkFile):void
		{
			var listItem:IBulkListItem = _fileToitem[file];
			var list:BulkList = _fileToList[file];
			
			var listCompleteEvent:BulkEvent = new BulkEvent(BulkEvent.LIST_COMPLETE);
			listCompleteEvent.item = listItem;
			listCompleteEvent.itemLoadingInfo = _fileToLoadingInfo[file];
			listCompleteEvent.list = list;
			listCompleteEvent.listLoadingInfo = getLatestListLoadingInfo(list);
			list.dispatchEvent(listCompleteEvent);
		}
		
		private function throwListStart(file:IBulkFile):void
		{
			var listItem:IBulkListItem = _fileToitem[file];
			var list:BulkList = _fileToList[file];
			
			var listStartEvent:BulkEvent = new BulkEvent(BulkEvent.LIST_START);
			listStartEvent.item = listItem;
			listStartEvent.itemLoadingInfo = _fileToLoadingInfo[file];
			listStartEvent.list = list;
			listStartEvent.listLoadingInfo = getLatestListLoadingInfo(list);
			list.dispatchEvent(listStartEvent);
		}
		
		protected function onItemComplete(event:BulkItemLoadingEvent):void
		{
			var file:IBulkFile = event.fileInfo;
			var listItem:IBulkListItem = _fileToitem[file];
			var list:BulkList = _fileToList[file];
			
			/*更新计数*/
			var index:int = _loading.indexOf(file);
			if (index != -1)
			{
				_loading.splice(index, 1);
				activeLoader();
			}
			
			/*throw event*/
			var itemCompleteEvent:BulkEvent = new BulkEvent(BulkEvent.ITEM_COMPLETE);
			itemCompleteEvent.item = listItem;
			itemCompleteEvent.itemLoadingInfo = event.loadingInfo;
			itemCompleteEvent.list = list;
			itemCompleteEvent.listLoadingInfo = getLatestListLoadingInfo(list);
			list.dispatchEvent(itemCompleteEvent);
			
			if (isEndItemOfList(listItem, list))
				throwListComplete(file);
		}
		
		protected function onItemStart(event:BulkItemLoadingEvent):void
		{
			var file:IBulkFile = event.fileInfo;
			var listItem:IBulkListItem = _fileToitem[file];
			var list:BulkList = _fileToList[file];
			
			/*throw event*/
			if (isFirstItemOfList(listItem, list))
				throwListStart(file);
			
			var itemStartEvent:BulkEvent = new BulkEvent(BulkEvent.ITEM_START);
			itemStartEvent.item = listItem;
			itemStartEvent.itemLoadingInfo = event.loadingInfo;
			itemStartEvent.list = list;
			itemStartEvent.listLoadingInfo = getLatestListLoadingInfo(list);
			list.dispatchEvent(itemStartEvent);
		}
		
		protected function onItemProgress(event:BulkItemLoadingEvent):void
		{
			var file:IBulkFile = event.fileInfo;
			var listItem:IBulkListItem = _fileToitem[file];
			var list:BulkList = _fileToList[file];
			
			var itemProgressEvent:BulkEvent = new BulkEvent(BulkEvent.ITEM_START);
			var listProgressEvent:BulkEvent = new BulkEvent(BulkEvent.LIST_PROGRESS);
			itemProgressEvent.item = listProgressEvent.item = listItem;
			itemProgressEvent.itemLoadingInfo = listProgressEvent.itemLoadingInfo = event.loadingInfo;
			itemProgressEvent.list = listProgressEvent.list = list;
			itemProgressEvent.listLoadingInfo = listProgressEvent.listLoadingInfo = getLatestListLoadingInfo(list);
			list.dispatchEvent(itemProgressEvent);
			list.dispatchEvent(listProgressEvent);
		}
		
		private function getLatestListLoadingInfo(list:IBulkList):IBulkListLoadingInfo
		{
			var listLoadingInfo:BulkListLoadingInfo = _listToLoadingInfo[list];
			if (!listLoadingInfo)
				return null;
			
			listLoadingInfo.bytesTotal = 0;
			listLoadingInfo.bytesLoaded = 0;
			listLoadingInfo.percentage = 0;
			
			var listItems:Vector.<IBulkListItem> = list.getItems();
			var listItemsInLoadingCount:uint = 0;
			for (var i:int=0; i<listItems.length; i++)
			{
				var item:IBulkListItem = listItems[i];
				var file:IBulkFile = _itemToFile[item];
				var fileLoadingInfo:IBulkItemLoadingInfo = _fileToLoadingInfo[file];
				
				listLoadingInfo.bytesTotal += fileLoadingInfo.getBytesTotal();
				listLoadingInfo.bytesLoaded += fileLoadingInfo.getBytesLoaded();
				
				if (fileLoadingInfo.getBytesTotal() > 0 && fileLoadingInfo.getBytesLoaded() > 0)
					listItemsInLoadingCount ++;
				
				var percentage:Number = fileLoadingInfo.getPercentage();
				if (!isNaN(percentage))
					listLoadingInfo.percentage += percentage/listItems.length;
			}
			
			return listLoadingInfo;
		}
		
		protected function isFirstItemOfList(item:IBulkListItem, list:IBulkList):Boolean
		{
			var items:Vector.<IBulkListItem> = list.getItems();
			return (items.length > 0) && (items[0] == item);
		}
		
		protected function isEndItemOfList(item:IBulkListItem, list:IBulkList):Boolean
		{
			var items:Vector.<IBulkListItem> = list.getItems();
			return (items.length > 0) && (items.pop() == item);
		}
		
		////////////////////////////////////////////////////////////////////////////
		public static function to(list:IBulkList):void
		{
			_instance.addIntoLoadedLine(list);
			_instance.activeLoader();
		}
		
		public static function getItemLoadingInfo(paramKey:String, paramValue:*):IBulkItemLoadingInfo
		{
			var loadedFiles:Vector.<IBulkFile> = _instance._loadedLinePool.slice(0, _instance._loadedProcessIn);
			while (loadedFiles.length)
			{
				var file:IBulkFile = loadedFiles.pop();
				var item:IBulkListItem = _instance._fileToitem[file];
				if (item.param && 
					item.param[paramKey] == paramValue)
					return _instance._fileToLoadingInfo[file];
			}
			return null;
		}
	}
}