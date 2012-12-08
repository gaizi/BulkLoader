package loadinginfo
{
	public class BulkListLoadingInfo implements IBulkListLoadingInfo
	{
		public function BulkListLoadingInfo()
		{
		}
		
		public var bytesTotal:uint;
		public var bytesLoaded:uint;
		public var percentage:Number;
		
		public function getBytesTotal():uint
		{
			return 0;
		}
		
		public function getBytesLoaded():uint
		{
			return 0;
		}
		
		public function getPercentage():Number
		{
			return 0;
		}
	}
}