package loadinginfo
{
	import flash.display.Bitmap;
	import flash.media.Sound;
	import flash.text.StyleSheet;
	import flash.utils.ByteArray;

	public class BulkItemLoadingInfo implements IBulkItemLoadingInfo
	{
		public function BulkItemLoadingInfo()
		{
		}
		
		public var bytesTotal:uint;
		public var bytesLoaded:uint;
		public var percentage:Number;
		
		public var bitmap:Bitmap = null;
		public var css:StyleSheet = null;
		public var xml:XML = null;
		public var sound:Sound = null;
		public var bytes:ByteArray = null;
		
		
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
		
		// get data
		public function getBitmap():Bitmap
		{
			return bitmap;
		}
		
		public function getCss():StyleSheet
		{
			return css;
		}
		
		public function getXml():XML
		{
			return xml;
		}
		
		public function getSound():Sound
		{
			return sound;
		}
		
		public function getBytes():ByteArray
		{
			return bytes;	
		}
	}
}