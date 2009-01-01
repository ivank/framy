package framy.utils 
{
	import framy.errors.StaticClassError;
	import flash.utils.describeType;
	
	/**
	 * ...
	 * @author IvanK (ikerin@gmail.com)
	 */
	public class FunctionTools 
	{
		public function FunctionTools(){ throw new StaticClassError() }
		
		static public function flatten_args(array_function:Function, element_fnction:Function, args:Array):void {
			for each(var elem:* in args) {
				if (elem is Array) array_function.apply(elem,elem)
				else element_fnction(elem)
			}
		}
		
		/**
		 * Get a method of a non-dynamic object, if it doesn't exist, return null
		 * @param	obj
		 * @param	method_name
		 * @return
		 */
		static public function getMethod(obj:*, method_name:String):Function {
			try { return obj[method_name] }
			catch (e:ReferenceError){ return null }
			return null
		}
		
		static public function getAccessor(obj:*, accessor_name:String):* {
			try { return obj[accessor_name] }
			catch (e:ReferenceError){ return null }
			return null
		}
		
		/**
		 *	This is a workaround a restriction of ActionScript 3 that does not allow to pass arguments to the constructor as an array
		 *	@param	cls		The class of the new object
		 *	@param	args	The arguments passed to the constructor of the class
		 */
		static public function newWithArguments(cls:Class, args:Array=null):*{
		  args = args || new Array()
		  switch(args.length){
		    case 0: return new cls(); break;
		    case 1: return new cls(args[0]); break;
		    case 2: return new cls(args[0], args[1]); break;
		    case 3: return new cls(args[0], args[1], args[2]); break;
		    case 4: return new cls(args[0], args[1], args[2], args[3]); break;
		    case 5: return new cls(args[0], args[1], args[2], args[3], args[4]); break;
		    case 6: return new cls(args[0], args[1], args[2], args[3], args[4], args[5]); break;
		    case 7: return new cls(args[0], args[1], args[2], args[3], args[4], args[5], args[6]); break;
		    case 8: return new cls(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7]); break;
		    case 9: return new cls(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8]); break;
		    default: return new cls(args);
		  }
		}
	}
	
}