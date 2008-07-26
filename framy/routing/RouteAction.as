package framy.routing {
	import framy.events.ActionEvent
	import framy.routing.Module
	import framy.events.TranslateEvent
	import framy.events.RouteEvent
	import flash.events.Event
	
	/**
	* ...
	* @author Ivan K (ikerin@gmail.com)
	*/
	public class RouteAction {
		static public const BUILD_START_EVENTS:Array = new Array(ActionEvent.BUILD_STARTED, ActionEvent.DESTROY_STARTED, ActionEvent.PREPARE_STARTED, ActionEvent.RESTORE_STARTED, ActionEvent.TRANSLATE_STARTED, ActionEvent.QUICK_DESTROY_STARTED)
		static public const BUILD_COMPLETE_EVENTS:Array = new Array(ActionEvent.BUILD_COMPLETE, ActionEvent.DESTROY_COMPLETE, ActionEvent.PREPARE_COMPLETE, ActionEvent.RESTORE_COMPLETE, ActionEvent.TRANSLATE_COMPLETE, ActionEvent.DESTROY_COMPLETE)
		
		public var type:String
		public var to_type:String
		public var module:Module
		public var from:Module
		public var to:Module
		
		public function RouteAction(type:String, module:Module, from:Module = null, to:Module = null) {
			this.type = type
			this.module = module
			this.from = from
			this.to = to
			this.to_type = BUILD_COMPLETE_EVENTS[BUILD_START_EVENTS.indexOf(type)]
		}
		
		public function toString():String {
			return "[RouteAction type=\""+type+"\" module=\""+module+"\"]"
		}
		
		public function execute():void {
			if(module.stage)module.dispatchEvent(new Event(ActionEvent.INIT_RESIZE))
			Router.dispatchEvent(new RouteEvent(type, module, to, from));
			
			module.dispatchEvent(new Event(ActionEvent.INIT_RESIZE))
			if (type == ActionEvent.TRANSLATE_STARTED) module.dispatchEvent(new TranslateEvent(type, from, to))
			else module.dispatchEvent(new RouteEvent(type, module, to, from))			
		}
		
	}
	
}