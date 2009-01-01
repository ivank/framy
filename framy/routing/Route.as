package framy.routing 
{
	import framy.utils.Hash;
	
	/**
	 * This class is used to connect pages to urls
	 * @author IvanK (ikerin@gmail.com)
	 */
	public class Route 
	{
		private var _address:String
		private var _page:String
		private var _parameter_names:Array
		private var _address_match_regex:RegExp
		
		/**
		 *	Creates a route, connecting a page to an url address. The address can have parameters in it (identifiers started with ':'), which are passed to the page.
		 *	The pages are searched in the app.pages package with camelized name ending with 'Page' ('project_image' - app.pages.ProjectImagePage). 
		 *	@param	address	 The url address of the page
		 *	@param	page	 the name of the page - 'project' - app.pages.ProjectPage
		 *	@see framy.routing.Router Router
		 *	@constructor
		 */
		public function Route(address:String, page:String) 
		{
			this._address = address
			this._page = page
			
			this._parameter_names = address.match(/\:([^\/])+/g).map(function(item:*, index:int, array:Array):*{ return item.slice(1) } )
			
			this._address_match_regex = new RegExp("^" + this._address.replace(/\:[^\/]+/g, "([^/]+)").replace(/\//g, "\\/") + "$")
		}
		
		/**
		 *	Get the parameters from the url (/project/:project/:image will return ['project','image'])
		 *	@private
		 */
		public function get parameter_names():Array { return this._parameter_names }
		
		/**
		 *	@private
		 */
		public function get page_name():String { return this._page }
		
		/**
		 *	Chack if a given url matches to this route
		 *	@private
		 */
		public function matchUrl(url:String):Hash {
			var result:Array = url.match(this._address_match_regex)
			if (result) return Hash.fromKeysAndValues(this.parameter_names, result.slice(1))
			else return null
		}
		
		/**
		 *	Create a full url by filling the parameters with those provieded by the hash
		 *	@private
		 */
		public function constructUrl(params:Object = null):String {
			var url_params:Hash = new Hash(params)
			var url:String = new String(this._address)
			
			for (var param_name:String in url_params) {
				url = url.replace(':'+param_name, url_params[param_name])
			}
			return url
		}
	}
	
}