package framy.loading {
	import flash.display.Loader;
	import flash.display.LoaderInfo
	import flash.utils.Dictionary;

	/**
	* Simple key/value cache engine
	* stores the cache in memory, using a string as a key
	* 
	* Extend this class, and override the "calculate" method for your custom calculations
	* @author Ivan K
	*/	
	public class Cache {
		static private var entries:Object = new Object()
		
		static public function add(name:String, entry:*):void{
			if(!exists(name))entries[name] = entry
		}
		
		static public function retrieve(name:String):*{
			return entries[name]
		}
		
		static public function exists(name:String):Boolean{
			return entries[name] !== undefined
		}
		
	}
}
