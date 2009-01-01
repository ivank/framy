package framy.animation 
{
	import flash.events.EventDispatcher;
	import framy.events.SequenceEvent;
	import framy.structure.Page;
	import framy.utils.ArrayTools;
	import framy.utils.FunctionTools;
	import framy.utils.Hash;
	import framy.utils.NumberTools;
	import caurina.transitions.Tweener;
	import flash.events.Event;
	
	/**
	 * This class is used internally to organize tween animations between pages
	 * @author IvanK (ikerin@gmail.com)
	 */
	public class Sequence extends EventDispatcher
	{
		private var _seq:Array = new Array
		private var _event_dispatcher:Page
		
		public function Sequence(...arguments)
		{
			this.merge(arguments)
		}
		
		public function extend(base:Hash):void {
			this._seq.map(function(e:*,i:int,a:Array):Hash{ return e.extend(base) })
		}
		
		public function get length():uint { return this._seq.length}
		
		public function get items():Array { return _seq }
		public function get last():Hash { return ArrayTools.last(_seq) }
		
		public function offsetFrom(from:Hash):Sequence {
			this._seq = this._seq.map(function(e:*, i:int, arr:Array):Hash { 
				return (e as Hash).map_values(function(name:String, value:*):* { 
					return NumberTools.stringOffset(from[name], value)
				} ) 
			})
			return this
		}
		
		public function apply(elem:*):void {
			Tweener.removeTweens(elem)
			for (var i:int = 0; i < this._seq.length; i++) {
				if (this._seq[i].wait_for ) {
					var current_sequence:uint = i
					var tween_for :String = this._seq[i].wait_for
					var _dispatcher:Page = _event_dispatcher
					
					if (_event_dispatcher.eventTriggered(tween_for )) {
						this.applyToElement(elem, current_sequence)
					}
					else {
						var _seq:Sequence = this
						var tweening:Function = function(e:Event):void { 
							
							_seq.applyToElement(elem,current_sequence)
							_dispatcher.removeEventListener(tween_for, tweening)
						}
						_event_dispatcher.addEventListener(tween_for , tweening)
					}
				}else {
				  this.applyToElement(elem,i)
				}
			}
		}
		
		private function applyToElement(elem:*, i:uint):void {
			elem.progress = 0;
			Tweener.addTween(elem, this._seq[i].withoutKeys(['wait_for']).extend({time: 0, delay: 0}).merge({ 
			  progress: 1, 
			  onCompleteScope: this, onCompleteParams:[i], onComplete: this.onItemComplete, 
			  onStartScope: this, onStartParams: [i, elem], onStart: this.onItemStart, 
			  onUpdateScope: this, onUpdateParams: [i], onUpdate: this.onItemUpdate 
			}))
		  
		}

		public function merge(new_seq:*):Sequence {
			var arr:Array
			if (new_seq is Array) arr = new_seq
			else if (new_seq is Sequence) arr =  new_seq._seq 
			else arr = [ new_seq ]
			
			var i:int
			for (i = _seq.length; i < arr.length; i++) this._seq.push(new Hash())
			
			for (i = 0; i < arr.length; i++) {
				this._seq[i].merge(arr[i])
			}
			return this
		}
		
		public function get dup():Sequence {
			return FunctionTools.newWithArguments(Sequence, this._seq).setDispatcher(_event_dispatcher)
		}
		
		public function setDispatcher(d:Page):Sequence
		{
			this._event_dispatcher = d
			return this
		}
		
		
		private function onItemUpdate(current:int):void { this.dispatchEvent(new SequenceEvent(SequenceEvent.PROGRESS, current)) }
		
		private function onItemStart(current:int, elem:*):void { elem.progress = 0;  this.dispatchEvent(new SequenceEvent(SequenceEvent.START, current)) }
		
		private function onItemComplete(current:int):void{ this.dispatchEvent(new SequenceEvent(SequenceEvent.COMPLETE, current)) }
		
		
	}
	
}