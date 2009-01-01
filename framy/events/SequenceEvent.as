package framy.events 
{
	import flash.events.Event;
	
	/**
	 * @private
	 * @author IvanK (ikerin@gmail.com)
	 */
	public class SequenceEvent extends Event 
	{
		static public const PROGRESS:String = "SequenceItemProgressEvent"
		static public const START:String = "SequenceItemStartEvent"
		static public const COMPLETE:String = "SequenceItemCompleteEvent"
		public var current:int
		
		public function SequenceEvent(type:String, current:int, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			this.current = current
		} 
		
		public override function clone():Event 
		{ 
			return new SequenceEvent(type, current, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("SequenceEvent", "current", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}