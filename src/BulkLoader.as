package
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;

	public class BulkLoader
	{
		private static var _instance:BulkLoader = new BulkLoader();
		public function BulkLoader()
		{
			if (_instance)
				new Error("BulkLoader is single instance.");
		}
		
		public static function loadList(list:BulkList):void
		{
			_instance.addToLoadFileList(list);
			_instance.activeLoader();
		}
		
		public static function set loaderContext(value:LoaderContext):void
		{
			_instance._loaderContext = value;
		}
		
		public static function get loaderContext():LoaderContext
		{
			return _instance._loaderContext;
		}
		
		/**
		 * 添加到加载队列
		 * @param list
		 * @return 
		 * 
		 */		
		private function addToLoadFileList(list:BulkList):uint
		{
			for (var i:int=0; i<list.length; i++)
			{
				var file:BulkFile = new BulkFile(list[i]);
				_loadFileList.push(file);
				
				_fileToList[file] = list;
			}
			
			return _loadFileList.length;
		}
		
		/**
		 * 激活加载
		 * 
		 */		
		private function activeLoader():void
		{
			while (BulkLoaderConst.MAX_CONCURRENT > _loadingFiles.length)
			{
				if (_loadFileList.length < _loadingIndex) /*所有列表文件都加载完毕*/
					return;
				
				var file:BulkFile = _loadFileList[_loadingIndex]; /*从待加载列表中取一文件*/
				_loadingIndex ++; /*更新加载指针位置*/
				
				var list:BulkList = _fileToList[file];
				
				if (!file || !list)
					continue;
				
				var handler:BulkLoadHandler = new BulkLoadHandler(file, list); /*开始加载文件*/
				handler.start();
			}
		}
		
		
		/*******************************/
		
		protected var _loadingIndex:uint = 0;
		
		protected var _loadingFiles:Array = [];
		
		protected var _loadFileList:Array = [];
		
		protected var _fileToList:Dictionary = new Dictionary(true);
		
		protected var _loaderContext:LoaderContext;
	}
}


import flash.display.Loader;
import flash.events.Event;
import flash.events.IEventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLStream;
import flash.system.LoaderContext;

class BulkFile
{
	public var key:*;
	public var url:String;
	
	public var type:int;
	
	public var listItem:Object;
	
	public function BulkFile(listItem:Object)
	{
		key = listItem.key;
		url = listItem.url;
		
		if (listItem.hasOwnProperty("mimeType"))
			type = listItem.mimeType;
		else
			type = BulkLoaderConst.FILE_AUTOMATIC;
		
		this.listItem = listItem;
	}
}

class BulkLoadHandler
{
	private var _file:BulkFile;
	private var _list:BulkList;
	
	public function BulkLoadHandler(file:BulkFile, list:BulkList)
	{
		_file = file;
		_list = list;
	}
	
	protected function onIoError(event:IOErrorEvent):void
	{
		var bulkEvent:BulkEvent = new BulkEvent(BulkEvent.ITEM_ERROR);
		_list.dispatchEvent(bulkEvent);
	}
	
	protected function onLoaderComplete(event:Event):void
	{
		var bulkEvent:BulkEvent = new BulkEvent(BulkEvent.ITEM_COMPLETE);
		bulkEvent.content = event.target.content;
		_list.dispatchEvent(bulkEvent);
	}
	
	protected function onLoaderProgress(event:ProgressEvent):void
	{
		var bulkEvent:BulkEvent = new BulkEvent(BulkEvent.ITEM_PROGRESS);
		bulkEvent.content = event.target.content;
		_list.dispatchEvent(bulkEvent);
	}
	
	protected function onLoaderStart(event:Event):void
	{
		var bulkEvent:BulkEvent = new BulkEvent(BulkEvent.ITEM_START);
		_list.dispatchEvent(bulkEvent);
	}
	
	public function start():void
	{
		if (_file.type == BulkLoaderConst.FILE_AUTOMATIC) /*没有定义文件类型时根据文件后缀区别文件类型*/
		{
			var extension:String = getExtension(_file.url);
			switch (extension)
			{
				case "swf":
					_file.type = BulkLoaderConst.FILE_SWF;
					break;
				case "xml":
					_file.type = BulkLoaderConst.FILE_XML;
					break;
				case "jpg":
					_file.type = BulkLoaderConst.FILE_IMAGE;
					break;
				case "png":
					_file.type = BulkLoaderConst.FILE_IMAGE;
					break;
				case "bmp":
					_file.type = BulkLoaderConst.FILE_IMAGE;
					break;
				case "flv":
					_file.type = BulkLoaderConst.FILE_FLV;
					break;
				case "wav":
					_file.type = BulkLoaderConst.FILE_WAV;
					break;
				case "zip":
					_file.type = BulkLoaderConst.FILE_ZIP;
					break;
				case "mp3":
					_file.type = BulkLoaderConst.FILE_MP3;
					break;
				case "css":
					_file.type = BulkLoaderConst.FILE_CSS;
					break;
				default:
					_file.type = BulkLoaderConst.FILE_BINARY;
					break;
			}
		}
		else /*当操作者定义了文件类型情况下启用检测*/
		{
			var types:Array;
			with(BulkLoaderConst)
				types = [FILE_IMAGE, FILE_SWF, FILE_XML, FILE_CSS, FILE_MP3, FILE_ZIP, FILE_WAV, FILE_FLV, FILE_BINARY];
			if (types.indexOf(_file.type) == -1)
				_file.type = BulkLoaderConst.FILE_BINARY;
			
			types = null;
		}
		
		/*创建加载器*/
		var loader:* = null;
		if (_file.type == BulkLoaderConst.FILE_BINARY)
		{
			loader = new URLStream();
			setListenHandler(loader);
		}
		else if (_file.type == BulkLoaderConst.FILE_CSS)
		{
			loader = new URLLoader();
			setListenHandler(loader);
		}
		else if (_file.type == BulkLoaderConst.FILE_FLV)
		{
			new Error("can't supports flv of file type!");
			return;
		}
		else if (_file.type == BulkLoaderConst.FILE_IMAGE)
		{
			loader = new Loader();
			setListenHandler(loader.contentLoaderInfo);
		}
		else if (_file.type == BulkLoaderConst.FILE_MP3)
		{
			loader = new URLLoader();
			setListenHandler(loader);
		}
		else if (_file.type == BulkLoaderConst.FILE_SWF)
		{
			loader = new Loader();
			setListenHandler(loader.contentLoaderInfo);
		}
		else if (_file.type == BulkLoaderConst.FILE_WAV)
		{
			loader = new URLLoader();
			setListenHandler(loader);
		}
		else if (_file.type == BulkLoaderConst.FILE_XML)
		{
			loader = new URLLoader();
			setListenHandler(loader);
		}
		else if (_file.type == BulkLoaderConst.FILE_ZIP)
		{
			loader = new URLStream();
			setListenHandler(loader);
		}
		else
			return;
		
		var urlRequest:URLRequest = new URLRequest(_file.url);
		loader.load(urlRequest, BulkLoader.loaderContext);
	}
	
	private function setListenHandler(evtDispatcher:IEventDispatcher):void
	{
		evtDispatcher.addEventListener(Event.OPEN, onLoaderStart);
		evtDispatcher.addEventListener(ProgressEvent.PROGRESS, onLoaderProgress);
		evtDispatcher.addEventListener(Event.COMPLETE, onLoaderComplete);
		evtDispatcher.addEventListener(IOErrorEvent.IO_ERROR, onIoError);
	}
	
	private function getExtension(url:String):String
	{
		var urlPath:Array = url.split("/");
		var extension:String = urlPath.length>0 ? urlPath[urlPath.length-1]:url;
		extension = String(extension.match(/\.[^?]*/));
		extension = String(extension.match(/[^\.].*/));
		return extension.toLowerCase();
	}
}