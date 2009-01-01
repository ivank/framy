package framy.routing 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import framy.debug.DebugPanel;
	import swfaddress.SWFAddress;
	import swfaddress.SWFAddressEvent;
	import framy.errors.StaticClassError;
	import framy.structure.Page;
	import framy.utils.FunctionTools;
	import framy.utils.Hash;
	
	/**
	 *  Dispatched when the page starts to change to another one.
	 *
	 *  @eventType flash.events.Event.COMPLETE
	 */
	[Event(name="change", type="flash.events.Event.CHANGE")]	
	
	/**
	 * Manages the integration with SWFAddress and transitions between pages
	 * @author IvanK (ikerin@gmail.com)
	 */
	public class Router 
	{
		static private var _dispatcher:EventDispatcher = new EventDispatcher()
		static private var _routes:Array = new Array()
		static private var _routes_hash:Hash = new Hash()
		static private var _current_page:Page
		static private var _old_page:Page
		static private var _current_parameters:Hash = new Hash()
		static private var _current_state:uint = 0
		static private var _history:Array = new Array()
		static private var _current_point:HistoryPoint
		
		/**
		 *	@private
		 */
		static public function init():void {
			SWFAddress.addEventListener(SWFAddressEvent.CHANGE, onRouteChanged)
		}
		

		static private function onRouteChanged(e:SWFAddressEvent):void 
		{
			for each (var r:Route in _routes) {
				var params:Hash = r.matchUrl(e.value)
				if (params && (!_current_page || !(_current_page.name == r.page_name && _current_parameters == params))) {
					goToPage(r.page_name, params);
					break;
				}
			}
		}
		
		public function Router(){ throw new StaticClassError() }
		
		/**
		 *	Add routes to the system - best done at the start of the application
		 *	each route must have a unique name
		 */
		static public function addRoutes(...arguments):void { FunctionTools.flatten_args(addRoutes, addRoute, arguments); }
		
		/**
		 *	@private
		 */
		static public function addRoute(route:Route):void {
			if (!_routes_hash.has(route.page_name)) {
				_routes.push(route)
				_routes_hash[route.page_name] = route
			}else throw Error("A route with this name (" + route.page_name + ") is already defined, please choose another name")
		}
		
		/**
		 *	Internal function that actualy transforms one page to another
		 *	@private
		 */
		static private function goToPage(page_name:String, parameters:Object = null):void {
			stateChanged()
			
			_old_page = _current_page
			if(_old_page)_old_page.dispatchEvent(new Event(Event.REMOVED))
			
			_current_page = Page.create(page_name, parameters)
			_current_parameters = new Hash(parameters)
			
			_history.push(_current_point = new HistoryPoint(page_name, current_state, _current_parameters))
			if (_current_page.title) SWFAddress.setTitle(_current_page.title)
			
			Page.transition(_old_page, _current_page)
		  _dispatcher.dispatchEvent(new Event(Event.CHANGE))
		}
		
		/**
		 *	Redirect the page to another one, providing page_name and parameters. If a route to this page exists, changes the browser url to match the page
		 */
		static public function redirectTo(page_name:String, parameters:Object = null):void {
			if(_routes_hash[page_name])
				SWFAddress.setValue(_routes_hash[page_name].constructUrl(parameters))
			else 
				goToPage(page_name, parameters)
		}
		
		static public function get history_length():uint { return _history.length }
		
		/**
		 *	Get a HistoryPoint from the page change history
		 *	@param	where	 offset from the current point
		 *	@see framy.routing.HistoryPoint		HistoryPoint
		 */
		static public function history(where:int = 0):HistoryPoint { 
			return _history[_history.indexOf(_current_point)+where]
		}
		
		/**
		 *	@private
		 */
		static public function stateChanged():void {
			_current_state++;
		}
		
		/**
		 *	Get the current page parameters
		 */
		static public function get parameters():Hash { return _current_parameters }
		
		/**
		 *	After each page change, the state is incremented
		 */
		static public function get current_state():uint { return _current_state }
		
		/**
		 *	Returns the current page object
		 */
		static public function get current_page():Page { return _current_page }
		
		/**
		 *	Returns the preious page object
		 */
		static public function get old_page():Page { return _old_page }
		
		/**
		 *	@private
		 */
		static public function prepareName(name:String):String {
			return name.replace(/([a-z_]+)\:current/g, "$1_%$1%").replace(/([a-z_]+)\:([a-z_]+)/g, "$1_$2").replace(/[\{\,]/g, '_').replace(/[\s\}]/g,'')
		}
		
		/**
		 *	@private
		 */
		static public function getName(name:String):String {
			return name.replace(/\%([^\%]+)\%/g, function(...arguments):String{ return _current_parameters[arguments[1]] })
		}
		
		/**
		 * Registers an event listener.
		 * @param type Event type.
		 * @param listener Event listener.
		 */
		static public function addEventListener(type:String, listener:Function):void {
			_dispatcher.addEventListener(type, listener, false, 0, false);
		}

		/**
		 * Removes an event listener.
		 * @param type Event type.
		 * @param listener Event listener.
		 */
		static public function removeEventListener(type:String, listener:Function):void {
			_dispatcher.removeEventListener(type, listener, false);
		}					
		
	}
	
}