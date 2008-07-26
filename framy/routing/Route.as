package framy.routing {
		import framy.tools.Hash;
		import flash.utils.getDefinitionByName;
	
	/**
	* ...
	* @author Ivan K (ikerin@gmail.com)
	*/
	public class Route {
		private var _address:String
		private var _parameters:Array
		private var _address_match:RegExp
		private var _module_class:String
		private var _children:Array = []
		protected var _parent:Route
		
		private var addres_regex:String
		
		public function Route(address:String, module_class:String, options:Object= null) {
			if (options && options.children) this._children = options.children
			for each(var child:Route in this._children)child._parent = this
			
			//add forward and trailing slash if there is none
			this._address = address.replace(/[^\/]$/m, "$&/").replace(/^[^\/]/m, "/$&")
			this._module_class = module_class
			
			//build the regular expression for matching with future url requests
			this.addres_regex = "^" + this._address.replace(/\:[^\/]+/g, "([^/]+)").replace(/\//g, "\\/") + "$"
			this._address_match = new RegExp(addres_regex)
			
			//extract the parameters from the address
			this._parameters = address.match(/\:([^\/])+/g).map(function(item:*, index:int, array:Array):*{ return item.slice(1) })
			
		}
		
		/**
		 * Check if a given url address matches with this route, and return all the matching parameters in the route
		 * @param	url	 url address to check 
		 * @return	Array		matches of the address
		 */
		public function match(url:String):Hash {
			var matches:Array = url.match(this._address_match)
			if (matches)return Hash.from_keys_and_values(this._parameters, matches.slice(1))
			else return null
		}
		
		public function get module_class():Class {
			return (getDefinitionByName(this._module_class) as Class)
		}
		
		public function toString():String {
			return "["+this._address+" => "+this._module_class+"; parameters: "+this._parameters+"]"
		}
		
		/**
		 * return all children routes, recursively going through all children's children, etc.
		 * @return	Array		all children routes, recursively
		 */
		public function get children():Array {
			var all_children:Array = []
			for each(var child:Route in _children) {
				all_children.push(child)
				all_children = all_children.concat(child.children)
			}
			return all_children
		}
		
	}
	
}