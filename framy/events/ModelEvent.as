package framy.events 
{
	import flash.events.Event;
	
	
	/**
	 * @author IvanK (ikerin@gmail.com)
	 */
	public class ModelEvent extends Event 
	{
		static public const PROGRESS:String = "ModelLoadingProgress"
		static public const COMPLETE:String = "ModelLoadingComplete"
		
		public function ModelEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new ModelEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("ModelEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}