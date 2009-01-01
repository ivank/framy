package framy.utils 
{
	import framy.errors.StaticClassError;
	
	/**
	 * Useful methods for numeric transformations, mainly for animations
	 * @author IvanK (ikerin@gmail.com)
	 */
	public class NumberTools 
	{
		
		public function NumberTools() {	throw new StaticClassError() }
		
		/**
		 *	Takes a number in the 0-1 range and scales it to fit in the given boundaries
		 *	</listing>
		 */
		static public function fragment(n:Number, from:Number=0, to:Number=1):Number{
		  return (n > from) ? ( n <= to  ? (n-from)/(to-from) : 1 ) : 0
		}
		
		static public function center( container:Number, content:Number):int {
			return Math.round((container - content)/2)
		}
		
		/**
		 *	Makes a "fragment" number transformation for each element of the array, with a consistant spacing between them
		 */
		static public function apart(n:Number, current:uint, parts:uint, options:Object = null):Number{
		  var opts:Hash = new Hash({ each_part: 0.7, reverse: false }).merge(options)
		  if(opts.reverse)current = parts - current
		  
		  return fragment(n ,(current/parts)*(1-opts.each_part), 1-(1-current/parts)*(1-opts.each_part))
		}
		
		static public function move(n:Number, new_x:Number, old_x:Number):Number {
			return old_x * (1-n) + new_x * n
		}
		
		/**
		 *	@private
		 */
		static public function stringOffset(n:*, of: * ):* {
			if (n is Number && of is String ) {
				if(isNaN(Number(of)))throw SyntaxError('Can only offset by numerical values ("'+of+'" is not a number)')
				return (n || 0) + Number(of)
			}else {
				return of
			}
			
		}
	}
	
}