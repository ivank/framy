package framy.utils 
{
	
	/**
	 * ...
	 * @author IvanK
	 */
	public class EventTools 
	{
		
		public function EventTools() {}
		
		static private 
		
		static public function onLast(events:Object, callback:Function) {
			for (var name:String in events) {
				events[name].addEventListener(name, EventTools.onEventForLast)
			}
		}
		
	}
	
}