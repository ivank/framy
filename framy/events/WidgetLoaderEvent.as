package framy.events 
{
	import flash.events.Event;
	import framy.structure.WidgetLoader;
	
	/**
	 * ...
	 * @author IvanK
	 */
	public class WidgetLoaderEvent extends Event 
	{
		static public const ASSIGNED:String = "WidgetLoaderAssigned"
		
		private var _loader:WidgetLoader
		private var _created:Boolean = true
		public function WidgetLoaderEvent(type:String, loader:WidgetLoader, created:Boolean = true, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			this._loader = loader
			this._created = created
			super(type, bubbles, cancelable);
		} 
		
		public override function clone():Event 
		{ 
			return new WidgetLoaderEvent(type, loader, created, bubbles, cancelable);
		} 
		
		public override function toString():String
		{ 
			return formatToString("WidgetLoaderEvent", "type", "bubbles", "cancelable", "eventPhase");
		}
		
		public function get loader():WidgetLoader { return _loader; }
		public function get created():Boolean { return _created; }
		
	}
	
}