package framy.tools {
	import flash.display.DisplayObject;
	import flash.text.TextField;
	import flash.utils.getQualifiedClassName

	public class Utils {
		
		
		static public function max(arr:Array, f:Function):int {
			var max:int = 0
			for( var i:int=0; i < arr.length; i++) max = Math.max(max, f(arr[i]))
			return max
		}
		
		static public function sum(arr:Array, f:Function):Number {
			var sum:Number = 0
			for( var i:int=0; i < arr.length; i++) sum += f(arr[i])
			return sum
		}		
		
		static public function shuffle(a:Array):Array {
			return a.sort(function(a:*, b:*):int { return Math.round(Math.random() * 2) - 1 } )
		}		
		
		static public function urldecode(str:String):String {
			return unescape(str).replace("+"," ")
		}
		
		static public function backtrace_var(elem:DisplayObject, name:String):void {
			var current_elem:DisplayObject = elem
			var vars:Array = new Array()
			while (current_elem) {
				vars.push(getQualifiedClassName(current_elem)+': '+current_elem[name])
				current_elem = current_elem.parent
			}
			trace('backtracing',name, ' => ',vars)
		}
		
		static public function next(arr:Array, elem:*):* {
			var index:int = arr.indexOf(elem)
			if (index < 0) throw new VerifyError("Element is not part of the array")
			if (index >= arr.length) return null
			else return arr[index+1]
		}
		
		static public function previous(arr:Array, elem:*):*{
			var index:int = arr.indexOf(elem)
			if (index < 0) throw new VerifyError("Element is not part of the array")
			if (index == 0) return null
			else return arr[index-1]
		}
		
		static public function in_groups_of(arr:Array, size:uint):Array {
			var groups:Array = new Array()
			var current_group:Array
			for ( var i:int = 0; i < arr.length; i++) {
				if (i % size == 0 )groups.push(current_group = new Array())
				current_group.push(arr[i])
			}
			return groups
		}
		
		static public function sign(val:*):int{
			return val/Math.abs(val)
		}
	}
	
}
