package framy.events {
	import flash.events.Event;
	import framy.routing.Module;
	
	/**
	* ...
	* @author Ivan K (ikerin@gmail.com)
	*/
	public class TranslateEvent extends Event {
		public var from:Module
		public var to:Module
		
		public function TranslateEvent(type:String, from:Module, to:Module) {
			this.from = from
			this.to = to
			super(type)
		}
		
		public override function clone():Event { 
			return new TranslateEvent(type, from, to);
		} 
		
		public override function toString():String { 
			return formatToString("TranslateEvent", "type", "from", "to", "eventPhase"); 
		}				
		
	}
	
}