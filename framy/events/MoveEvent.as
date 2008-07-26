package framy.events {
	import flash.events.Event;

	public class MoveEvent extends Event{

		public static const MOVE:String = "MoveEvent"
		public var x:int
		public var y:int
		
		public function MoveEvent(type:String, x:int, y:int) {
			super(MOVE)
			this.x = x
			this.y = y
		}
	}
	
}
