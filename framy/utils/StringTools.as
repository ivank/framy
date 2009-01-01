package framy.utils 
{
	import framy.errors.StaticClassError;
	
	/**
	 * ...
	 * @author IvanK (ikerin@gmail.com)
	 */
	public class StringTools 
	{
		
		public function StringTools() {	throw new StaticClassError()	}
		
		static public function camelize(str:String):String {
			return str.replace(/(.)(_)(.)/g,function(...arguments):String{ return arguments[1] + (arguments[3] as String).toUpperCase() })
		}
		
		static public function classify(str:String):String {
			return StringTools.camelize(str).replace(/^(.)/,function(...arguments):String { return (arguments[1] as String).toUpperCase() })
		}
		
		static public function underscore(str:String):String {
			return str.replace(/^(.)/,function(...arguments):String { return (arguments[1] as String).toLowerCase() }).replace(/(.)([A-ZА-Я])/g,function(...arguments):String{ return arguments[1] + '_' + (arguments[2] as String).toLowerCase() })
		}
		
		static public function fragment(n:Number, new_string:String, from:Number=0, to:Number=1):String{
			return new_string.substr(0,Math.round(new_string.length*NumberTools.fragment(n, from, to)))
		}
		
		static public function apart(n:Number, new_string:String, current:uint, parts:uint, options:Object = null):String{
			return new_string.substr(0,Math.round(new_string.length*NumberTools.apart(n, current, parts, options)))
		}		
	}
	
}