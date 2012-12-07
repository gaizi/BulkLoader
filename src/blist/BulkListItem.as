package blist
{
	public class BulkListItem implements IBulkListItem
	{
		private var _url:String;
		private var _param:Object;
		
		public function BulkListItem(url:String, param:Object)
		{
			this._url = url;
			this._param = param;
		}
		
		public function get url():String
		{
			return _url;
		}
		
		public function get param():Object
		{
			return _param;
		}
	}
}