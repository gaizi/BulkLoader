package comply
{
	import blist.IBulkListItem;

	public class BulkFile implements IBulkFile
	{
		private var _fileType:String;
		private var _fileUrl:String;
		
		public function BulkFile(item:IBulkListItem)
		{
			_fileUrl = item.url;
			_fileType = getFileType(item);
		}
		
		private function getFileType(item:IBulkListItem):String
		{
			if (item.param.hasOwnProperty(BulkLoaderDefine.ITEM_MINETYPE))
			{
				if (BulkLoaderDefine.hasSupportFileType(item.param[BulkLoaderDefine.ITEM_MINETYPE]))
					return item.param[BulkLoaderDefine.ITEM_MINETYPE];
				else
					return BulkLoaderDefine.FILE_BINARY;
			}
			else
			{
				return BulkLoaderDefine.getFileTypeByUrl(item.url);
			}
		}
		
		public function get fileType():String
		{
			return _fileType;
		}
		
		public function get fileUrl():String
		{
			return _fileUrl;
		}
	}
}