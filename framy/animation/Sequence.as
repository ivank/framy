package framy.animation 
{
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import framy.routing.Router;
	import framy.structure.Page;
	import framy.structure.WidgetLoader;
	import framy.utils.ArrayTools;
	import framy.utils.FunctionTools;
	import framy.utils.Hash;
	import framy.utils.NumberTools;
	import caurina.transitions.Tweener;
	import flash.events.Event;
	
	
/**
 *  Dispatched when the last tween of the sequence has finished.
 *
 *  @eventType flash.event.Event.PROGRESS
 */
[Event(name="complete", type="flash.event.Event")]

	/**
	 * This class is used to arange tweens and execute funtions on an object, at predefined time intervals
	 * This is used internally by the animation class
	 * @author IvanK (ikerin@gmail.com)
	 */
	public class Sequence extends EventDispatcher
	{
		private var _seq:Array = new Array
		private var _elem:*
		private var _current:int = 0
		public var widget_name:String
		public var default_parameters:Hash
		
		public function Sequence(...arguments)
		{
			this._seq = arguments
		}
		
		public function get length():uint { return this._seq.length}
		public function get items():Array { return _seq }
		public function get last():Hash { return ArrayTools.last(_seq) }
		
		public function start(_content:*):void {
			_current = -1
			Tweener.removeTweens(_content)
			if (default_parameters) this.offsetFrom(default_parameters)
			this.nextStep(_content)
		}
		
		public function stop():void {
			_current =  this._seq.length
		}
		
		private function doStep(_content:*, elems:*):void {
			if (elems == 'set') {
				Tweener.addTween(_content, default_parameters)
				this.nextStep(_content)
			}else {
				var events:Array = elems.keys.filter(function(e:*, i:int, arr:Array):Boolean { return e.match(/^on/) } )
				if ( ! ArrayTools.is_empty( events ) ) {
					
					
					events.push('_onSequenceLongestTime')
					
					var completed_events:Array = new Array()
					var seq:Sequence = this
					var check_for_next:Function = function():void {
						if (ArrayTools.is_empty( ArrayTools.diff(events, completed_events) ))
						seq.nextStep(_content)
					}
					
					Tweener.addTween(_content, { time: 0, delay: Sequence.extractLongestTime(elems), onComplete: function():void {
						completed_events.push('_onSequenceLongestTime')
						check_for_next()
					}})
					
					for each (var name:String in events) {
						if ( name != '_onSequenceLongestTime') {
							var eventName:String = name.match(/^on(.*)/)[1]
							var listener:Function = function(event:*):void {
								
								var eventName:String = (event is Event) ? event.type : event
								completed_events.push('on' + eventName)
								
								var params:Hash = elems['on' + eventName].dup.extend(default_parameters)
								
								if (FunctionTools.getMethod(_content, 'on' + eventName) != null)_content['on' + event.type](params);
								check_for_next()
								if(event is Event)Router.removeEventListener(eventName, listener)
							}
							if (Router.alreadyDispatched(eventName))listener(eventName)
							else Router.addEventListener(eventName, listener)
						}
					}
				}else {
					Tweener.addTween(_content, { time: 0, delay: Sequence.extractLongestTime(elems), onCompleteScope: this, onComplete:function():void { this.nextStep(_content) } } )
				}
				
				elems.eachPair(function(name:String, elem_params:Hash):void {
					if (!name.match(/^on/)) {
						var params:Hash = elem_params.dup.extend(default_parameters)
						
						switch(name) {
							case 'tween':
								Tweener.addTween(_content, elem_params); 	
							break;
							case 'position':
								Tweener.addTween(_content, params);
							break;
							default:
								if (FunctionTools.getMethod(_content, name) != null)_content[name](params);
						}
					}
				}, this)
			}
		}
		
		static private function extractLongestTime(elems:Hash):Number {
			var max_complete:Number = 0
			elems.eachPair(function(name:String, elem_params:Hash):void { 
				max_complete = Math.max((elem_params.time || 0) + (elem_params.delay || 0)) 
			})
			return max_complete
		}
		
		private function nextStep(_content:*):void {
			_current ++
			if (_current < this._seq.length) this.doStep(_content, this._seq[_current])
			else {
				this.dispatchEvent(new Event(Event.COMPLETE))
			}
		}
		
		public function offsetFrom(from:Hash):Sequence {
			this._seq = this._seq.map(function(e:*, i:int, arr:Array):* { 
				if(e == 'set')return e
				else return new Hash(e).mapValues(function(name:String, value:*):* { 
					return new Hash(value).mapValues(function(name:String, value:*):* { 
						return NumberTools.stringOffset(from[name], value)
					})
				})
			})
			return this
		}
		
		override public function toString():String 
		{
			return "[Sequence "+this._seq.map(function(e:*, i:int, arr:Array):Hash { return new Hash(e).mapValues(function(name:String, value:*):* { return new Hash(value) }) }) + ']'
		}
	}
	
}