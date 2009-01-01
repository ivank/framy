package framy.utils 
{
	import framy.errors.StaticClassError;
	
	/**
	 * A collection of usefull methods for arrays
	 * @author IvanK (ikerin@gmail.com)
	 */
	public class ArrayTools 
	{
		
		public function ArrayTools(){ throw new StaticClassError() }
		
		static public function remove(array:Array, elem:*):Array {
			return array.filter(function(item:*, index:int, arr:Array):Boolean{ return item != elem })
		}
		
		static public function last(array:Array):*{
			return array[array.length-1]
		}
		
		/**
		 *	An easier to read method of saying array.indexOf(x) >= 0
		 */
		static public function has(array:Array, what:*):Boolean {
			return array.indexOf(what) >= 0
		}
		
		/**
		 *	Check if an array is empty - this is a more declaretive and easy to read way of saying "!some_array"
		 */
		static public function is_empty(array:Array):Boolean{
			return !Boolean(array.length)
		}
		
	}
	
}