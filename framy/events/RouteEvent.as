package framy.events {
	import flash.events.Event;
	import framy.routing.Module;
	
	/**
	* ...
	* @author Ivan K (ikerin@gmail.com)
	*/
	public class RouteEvent extends Event {
		public var affected:Module
		public var new_module:Module
		public var previous_module:Module
		public function RouteEvent(type:String, affected:Module, new_module:Module=null, previous_module:Module=null) {
			this.affected = affected
			this.new_module = new_module
			this.previous_module = previous_module
			super(type)
		}
		
		public override function clone():Event { 
			return new RouteEvent(type, affected, new_module);
		} 
		
		public override function toString():String { 
			return formatToString("RouteEvent", "type", "affected", "new_module", "previous_module", "eventPhase"); 
		}		
	}
	
}