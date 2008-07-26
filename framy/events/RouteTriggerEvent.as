package framy.events {
	import flash.events.Event;
	
	/**
	* ...
	* @author Ivan K (ikerin@gmail.com)
	*/
	public class RouteTriggerEvent extends Event {
		public var path:Array
		
		public function RouteTriggerEvent(type:String, path:Array, bubbles:Boolean = false, cancelable:Boolean = false) { 
			this.path = path
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event { 
			return new RouteTriggerEvent(type, path, bubbles, cancelable);
		} 
		
		public override function toString():String { 
			return formatToString("RouteTriggerEvent", "type", "bubbles", "cancelable", "eventPhase", "path"); 
		}
		
	}
	
}