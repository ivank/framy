package framy.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author IvanK (ikerin@gmail.com)
	 */
	public class ChangeEvent extends Event 
	{
		static public const WIDGET_CHANGE:String = "ChangeWidgetView"
		static public const WIDGET_DESTROY:String = "DestroyWidgetView"
		
		private var _view_name:String
		public function ChangeEvent(type:String, view_name:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			_view_name = view_name
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new ChangeEvent(type, view_name, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("ChangeEvent", "type", "view_name", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get view_name():String { return _view_name; }
		
	}
	
}