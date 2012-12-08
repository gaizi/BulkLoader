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
			return bytesTotal;
		}
		
		public function getBytesLoaded():uint
		{
			return bytesLoaded;
		}
		
		public function getPercentage():Number
		{
			return percentage;
		}
	}
}