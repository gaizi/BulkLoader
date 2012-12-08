package loadinginfo
{
	import flash.display.Bitmap;
	import flash.media.Sound;
	import flash.text.StyleSheet;
	import flash.utils.ByteArray;

	public interface IBulkItemLoadingInfo
	{
		function getBytesTotal():uint;
		
		function getBytesLoaded():uint;
		
		function getPercentage():Number;
		
		// get data
		function getBitmap():Bitmap;
		
		function getCss():StyleSheet;
		
		function getXml():XML;
		
		function getSound():Sound;
		
		function getBytes():ByteArray;
	}
}