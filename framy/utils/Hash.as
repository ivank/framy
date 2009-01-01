package framy.utils {
	import flash.utils.getQualifiedClassName

	public dynamic class Hash extends Object{
		public function Hash(obj:Object = null){
			if(obj)this.merge(obj)
		}
		
		public function map_values(callback:Function):Hash {
			var h:Hash = new Hash()
			
			for (var name:String in this) {
				h[name] = callback(name, this[name])
			}
			return h			
		}
		
		public function isEmpty():Boolean {
			for(var name:String in this)return false
			return true
		}		
		
		public function equals(other:Hash):Boolean {
			var name:String
			for (name in this)if(this[name] != other[name])return false
			for (name in other)if(other[name] != this[name])return false
			return true
		}
		
		public function get dup():Hash {
			return new Hash(this)
		}
		
		public function remove(key:String):*{
			var elem:* = this[key]
			delete this[key]
			return elem
		}
		
		public function withKeys(keys:Array):Hash{
			var h:Hash = new Hash()
			for(var i:uint = 0; i < keys.length; i++){
				if(this[keys[i]] !== undefined)h[keys[i]] = this[keys[i]]
			}
			return h
		}
		
		public function withoutKeys(keys:Array):Hash {
			var h:Hash = new Hash()
			for(var name:String in this){
				if(keys.indexOf(name) < 0)h[name] = this[name]
			}			
			return h
		}
		
		public function diff(other:Object):Hash{
			var h:Hash = new Hash()
			for(var name:String in this){
				if(other[name] === undefined)h[name] = this[name]
			}
			return h
		}
		
		public function merge(obj:Object, recursive:Boolean = true, extend_functions:Boolean = false):Hash {
			for (var name:String in obj) {
				if( obj[name] !== null){
					var base_class:String = getQualifiedClassName(this[name])
					var merge_class:String = getQualifiedClassName(obj[name])
					if (recursive && ( base_class === 'Object' || base_class === "framy.utils::Hash") && ( merge_class === 'Object' || merge_class === "framy.utils::Hash")) this[name] = new Hash(this[name]).merge(obj[name])
					if (extend_functions && this[name] is Function && obj[name] is Function) {
						var base_func:Function = this[name] ;
						var extend_func:Function = obj[name] ;
						this[name] = function(...arguments):void { base_func.apply(this, arguments); extend_func.apply(this, arguments) }
					}
					else this[name] = obj[name]
				}
			}
			return this
		}
		
		public function extend(obj:Object, recursive:Boolean = true, extend_functions:Boolean = false):Hash {
			return this.merge(new Hash(obj).withoutKeys(this.keys), recursive, extend_functions)
		}
		
		public function get keys():Array{
			var k:Array = new Array()
			for(var name:String in this)k.push(name)
			return k;
		}
		
		public function has(...arguments):Boolean {
			for each (var needle:* in arguments) {
				if (needle is Array && this.has.apply(this, needle))return true
				else if(this[needle] !== undefined)return true
			}
			return false
		}
		
		public function empty():Boolean {
			for (var name:String in this) return true
			return false
		}
		
		public function get values():Array{
			var v:Array = new Array()
			for(var name:String in this)v.push(this[name])
			return v;
		}
				
		public function replace_values(arr:Array):Hash{
			var i:uint = 0
			var t:Hash = new Hash(this)
			for(var name:String in this){
				t[name] = arr[i]
				i++
			}
			return t
		}
		
		public function replace_keys(arr:Array):Hash{
			var i:uint = 0
			var t:Hash = new Hash(this)
			for(var name:String in this){
				t[arr[i]] = t[name]
				delete t[name] 
				i++
			}
			return t
		}
		
		
		public function toId():String{
			var out:Array = new Array()
			for(var name:String in this){
				out.push(name+'_'+this[name].toString())
			}
			return out.join('_')
		}
		
		public function toQueryString():String {
			var out:Array = new Array()
			for(var name:String in this){
				out.push(name+'='+this[name].toString())
			}
			return out.join('&')
		}
		
		public function toString():String{
			var out:Array = new Array()
			for(var name:String in this){
				out.push(name+': '+ (getQualifiedClassName(this[name]) ==="Object"? new Hash(this[name]).toString() : this[name].toString()))
			}
			return '{'+out.join(', ')+'}'
		}
		
		static public function fromKeysAndValues(keys:Array, values:Array):Hash {
			if (keys.length != values.length) throw Error("Keys and Values must have equal amount of items")
			var t:Hash = new Hash()
			for (var i:int = 0 ; i < keys.length; i++) {
				t[keys[i]] = values[i]
			}
			return t
		}
		
	}
	
}
