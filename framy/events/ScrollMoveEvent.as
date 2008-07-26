package framy.events {
	import flash.events.Event;
	
	/**
	* ...
	* @author Default
	*/
	public class ScrollMoveEvent extends Event{
		public var y:int
		public var percent:Number
		public var offset:int
		static public const MOVED:String = "ScrollMoved"
		
		public function ScrollMoveEvent(y:int, percent:Number, offset:int) {
			this.y = y
			this.percent = percent
			this.offset = offset
			super(MOVED)
		}
		
	}
	
}