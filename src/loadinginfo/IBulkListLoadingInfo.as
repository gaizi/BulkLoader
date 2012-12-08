package loadinginfo
{
	public interface IBulkListLoadingInfo
	{
		function getBytesTotal():uint;
		
		function getBytesLoaded():uint;
		
		function getPercentage():Number;
	}
}