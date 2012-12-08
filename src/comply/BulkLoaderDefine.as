package comply
{
	import flash.system.LoaderContext;

	public class BulkLoaderDefine
	{
		/*file tyoe*/
		public static const FILE_AUTOMATIC:String = "file_automatic";
		public static const FILE_SWF:String = "file_swf";
		public static const FILE_XML:String = "file_xml";
		public static const FILE_CSS:String = "file_css";
		public static const FILE_MP3:String = "file_mp3";
		public static const FILE_WAV:String = "file_wav";
		public static const FILE_FLV:String = "file_flv";
		public static const FILE_IMAGE:String = "file_image";
		public static const FILE_BINARY:String = "file_binary";
		
		//
		public static const MAX_CONCURRENT:uint = 2;
		
		//
		public static function getFileTypeByUrl(url:String):String
		{
			var extension:String = getExtension(url);
			switch (extension)
			{
				case "png":return FILE_IMAGE;break;
				case "jpg":return FILE_IMAGE;break;
				case "bmp":return FILE_IMAGE;break;
				case "swf":return FILE_SWF;break;
				case "xml":return FILE_XML;break;
				case "css":return FILE_CSS;break;
				case "mp3":return FILE_MP3;break;
				case "wav":return FILE_WAV;break;
				case "flv":return FILE_FLV;break;
				
				default:
					return FILE_BINARY;
					break;
			}
		}
		
		//
		private static var _supportFileType:Array = [
			FILE_AUTOMATIC, 
			FILE_SWF, 
			FILE_XML, 
			FILE_CSS, 
			FILE_MP3, 
			FILE_WAV, 
			FILE_FLV, 
			FILE_IMAGE, 
			FILE_BINARY
		];
		public static function hasSupportFileType(fileType:String):Boolean
		{
			return _supportFileType.indexOf(fileType) != -1;
		}
		
		//
		public static function getExtension(url:String):String
		{
			var urlPath:Array = url.split("/");
			var extension:String = urlPath.length>0 ? urlPath[urlPath.length-1]:url;
			extension = String(extension.match(/\.[^?]*/));
			extension = String(extension.match(/[^\.].*/));
			return extension.toLowerCase();
		}
		
		//
		public static const ITEM_MINETYPE:String = "mineType";
		
		//
		private static var _loaderContext:LoaderContext;
		public static function setLoaderContext(value:LoaderContext):void
		{
			_loaderContext = value;
		}
		
		public static function getLoaderContext():LoaderContext
		{
			return _loaderContext;
		}
		
		//
		
	}
}