package framy.routing 
{
	import framy.utils.Hash;
	
	/**
	 * Represents a point in history - each page change is recorded
	 * @author IvanK (ikerin@gmail.com)
	 */
	public class HistoryPoint 
	{
		private var _page:String
		private var _params:Hash
		private var _state:uint
		
		public function HistoryPoint(page:String, state:uint, params:Object = null) 
		{
			this._page = page
			this._params = new Hash(params)
			this._state = state
		}
		public function get page_name():String{ return _page }
		public function get parameters():Hash{ return _params }
		public function get state():uint { return _state }
		public function toString():String { return '[HistoryPoint ' + _page + ' ' + _params + ']' }
		
		/**
		 *	Redirect to this history point
		 */
		public function goTo():void {
			Router.redirectTo(this._page, this.parameters)
		}
	}
	
}