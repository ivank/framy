package framy.events {
	import flash.events.Event;

	public class ChangeStartEvent extends Event{
		public var new_height:uint
		public var new_width:uint
		
		public function ChangeStartEvent(nw:uint = 0, nh:uint = 0) {
			this.new_height = nh
			this.new_width = nw
			super(ActionEvent.I18N_CHANGE)
		}

		public override function clone():Event { 
			return new ChangeStartEvent(this.new_width, this.new_height);
		} 
		
		public override function toString():String { 
			return formatToString("TranslateEvent", "type", "new_width", "new_height", "eventPhase"); 
		}				
				
	}
	
}
