package framy.routing {
		import flash.display.Stage;
		import flash.events.Event;
		import flash.events.EventDispatcher;
		import flash.events.MouseEvent;
		import flash.utils.Dictionary;
		import framy.events.ActionEvent;
		import framy.events.RouteEvent;
		import framy.loading.I18n;
		import framy.loading.Library;
		import framy.routing.Route;
		import framy.tools.Grawl;
		import framy.tools.Hash;
		import framy.events.SWFAddressEvent;
		import flash.utils.getDefinitionByName;
		import framy.tools.Options;
	
	/**
	* ...
	* @author Ivan K (ikerin@gmail.com)
	*/
	public class Router {
		static private var _routes:Array = new Array()
		static private var _modules:Array = new Array()
		static private var _triggers:Dictionary = new Dictionary(true)
		static private var _titles:Dictionary = new Dictionary(true)
		static private var _root:Route
		static public var locked:Boolean = false
		static private var _dispatcher:EventDispatcher = new EventDispatcher()
		static public var last_route:String 
		static private var _options:Options
		static public var title_base:*
		static private var current_title:*
		static private var _stage:Stage
		
		static public function init(stage:Stage):void {
			_stage = stage
			_stage.addEventListener(ActionEvent.I18N_CHANGE_COMPLETE, onLangChanged)
		}
		
		static private function onLangChanged(event:Event):void {
			if(current_title)setTitle(current_title)
		}
		
		static public function setTitle(new_title:*):void {
			current_title = new_title
			SWFAddress.setTitle(I18n.extract(current_title) + (title_base ? ' - ' + I18n.extract(title_base) : ''))
		}
		
		static public function dispatchEvent(event:Event):void {
			_dispatcher.dispatchEvent(event)
		}
		
		static public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReferance:Boolean = false):void {
			_dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReferance)
		}
		
		static public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
			_dispatcher.removeEventListener(type,listener,useCapture)
		}
		
		
		static public function create(route:Route, options:Object = null):void {
			_options = new Options(options, {  } )
			if(_options.languages)I18n.lang = _options.languages[0]
			
			_root = route
			_routes.push(route)
			_routes = _routes.concat(route.children)
			
			SWFAddress.addEventListener(SWFAddressEvent.CHANGE, swfAddressRoute)
		}
		
		static public function addModule(module:Module):void {
			_modules.push(module)
		}
		
		public static function link_to(trigger:EventDispatcher, address:*, title:String=null):void {
			_triggers[trigger] = address.replace(/[^\/]$/m, "$&/").replace(/^[^\/]/m, "/$&")
			if(title)_titles[trigger] = title
			trigger.addEventListener(MouseEvent.CLICK, triggerClicked)
		}
		
		private static function triggerClicked(event:MouseEvent):void {
			if (!_triggers[event.target]) throw Error("No address assigned for this trigger (" + String(event.target) + '")')
			redirect_to(_triggers[event.target])
			if(_titles[event.target])SWFAddress.setTitle(_titles[event.target])
		}
		
		public static function redirect_to(address:String):void {
			if (_options.languages && !get_lang(address)) address = '/' + I18n.lang + address
			SWFAddress.setValue(address)
		}
		
		static public function resumeLastRoute():void {
			if (last_route) {
				findRoute(last_route)
				last_route = null
			}
		}
		
		static private function swfAddressRoute(event:Event):void {
			if (!Library.loaded || locked) {
				last_route = SWFAddress.getValue()
			}else {
				findRoute(SWFAddress.getValue())
			}
		}
		
		static private function get_lang(addr:String):Array {
			if (_options.languages) {
				return addr.match(RegExp("^\/(" + (_options.languages as Array).join('|') + ")(\/.*)"))
			}else return null
		}
		static public function changeLangTo(lang:String):void {
			var current_lang:Array = get_lang(SWFAddress.getValue())
			SWFAddress.setValue('/'+lang+current_lang[2])
		}
		
		static public function findRoute(addr:String):void {
			var r:Route
			var parameters:Hash
			
			if (_options.languages) {
				var lang:Array = get_lang(addr)
				if (lang) {
					if(lang[1] != I18n.lang)
						I18n.changeLangTo(lang[1])
					addr = lang[2]
				}
			}
			
			
			for each(var route:Route in _routes) {
				parameters = route.match(addr)
				if (parameters) {
					r = route;
					break;
				}
			}
			
			
			var matching_module:Module 
			if (!r) throw Error("No matching route found for address " + addr)
			
			for each(var module:Module in _modules) {
				if((module is r.module_class) && module.parameters.equals(parameters))matching_module = module
			}
			if (!r) throw Error("No matching route found for address " + addr)
				
			if (matching_module) {
				matching_module.buildChain()
				for (var t:* in _triggers) {
					if (_triggers[t] == addr) {
						Router._dispatcher.dispatchEvent(new RouteEvent(ActionEvent.ROUTE_MATCHED, matching_module))
						t.dispatchEvent(new Event(ActionEvent.ROUTE_MATCHED))
					}
				}
			}else {
				throw Error("No matching module found for route " + r)
			}
		}
	}
	
}