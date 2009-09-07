package framy.utils 
{
	import framy.errors.StaticClassError;
	
	/**
	 * A collection of usefull methods for arrays
	 * @author IvanK (ikerin@gmail.com)
	 */
	public class ArrayTools 
	{
		
		public function ArrayTools() { throw new StaticClassError() }
		
		static public function flatten(array:Array):Array {
			var flattened:Array = new Array()
			for each(var item:* in array)
				if (item is Array) flattened = flattened.concat(flatten(item))
				else flattened.push(item)
			return flattened
		}
		
		static public function diff(array:Array, compare:Array):Array {
			var diff_arr:Array = new Array()
			for each(var item:* in array)if(!ArrayTools.has(compare, item))diff_arr.push(item)
			return diff_arr
		}
		
		static public function shuffle(array:Array, startIndex:int = 0, endIndex:int = 0):Array{ 
			if(endIndex == 0) endIndex = array.length-1;
			for (var i:int = endIndex; i>startIndex; i--) {
				var randomNumber:int = Math.floor(Math.random()*endIndex)+startIndex;
				var tmp:* = array[i];
				array[i] = array[randomNumber];
				array[randomNumber] = tmp
			}
			return array
		}
		
		static public function remove(array:Array, elem:*):Array {
			return array.filter(function(item:*, index:int, arr:Array):Boolean{ return item != elem })
		}
		
		static public function last(array:Array):*{
			return array.length ? array[array.length-1] : null
		}
		
		static public function middle(array:Array, method:String = 'floor'):* {
			return array[Math[method](array.length/2)]
		}
		
		static public function first(array:Array):*{
			return array.length ? array[0] : null
		}
		
		static public function clear(array:Array):Array{
			return array.splice(0,array.length)
		}
		
		
		/**
		 *	An easier to read method of saying array.indexOf(x) >= 0
		 */
		static public function has(array:Array, what:*):Boolean {
			if (what is Function) {
				return array.filter(what).length > 0
			}else {
				return array.indexOf(what) >= 0
			}
		}
		
		/**
		 *	Check if an array is empty - this is a more declaretive and easy to read way of saying "!some_array"
		 */
		static public function is_empty(array:Array):Boolean{
			return !Boolean(array.length)
		}
		
	}
	
}