package framy.debug 
{
	import framy.errors.StaticClassError;
	import flash.display.DisplayObject;
	import flash.utils.getQualifiedClassName
	/**
	 * ...
	 * @author IvanK (ikerin@gmail.com)
	 */
	public class DebugUtils 
	{
		
		public function DebugUtils() { throw new StaticClassError() }
		
		static public function backtrace_var(elem:DisplayObject, name:String):Array {
			var current_elem:DisplayObject = elem
			var vars:Array = new Array()
			while (current_elem) {
				vars.push(getQualifiedClassName(current_elem)+': '+current_elem[name])
				current_elem = current_elem.parent
			}
			return vars
		}
		
	}
	
}