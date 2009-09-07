package framy.events 
{
	import flash.events.Event;
	
	
	/**
	 * ...
	 * @author ...
	 */
	public class LanguageChangeEvent extends Event 
	{
		static public const START:String = "LanguageChangeStart";
		static public const FINISH:String = "LanguageChangeFinish";
		
		public function LanguageChangeEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new LanguageChangeEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("LanguageChangeEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}