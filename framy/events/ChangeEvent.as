package framy.events 
{
	import flash.events.Event;
	import framy.animation.Sequence;
	import framy.utils.Hash;
	import framy.utils.NumberTools;
	import framy.utils.StringTools;
	
	/**
	 *  This event is triggered for widgets when transitioning between pages
	 * @author IvanK (ikerin@gmail.com)
	 */
	public class ChangeEvent extends Event 
	{
		static public const PROGRESS:String = 'progress'
		static public const LAST_PROGRESS:String = 'lastProgress'
		static public const FIRST_PROGRESS:String = 'firstProgress'
		static public const LAST_START:String = 'lastStart'
		static public const LAST_FINISH:String = 'lastFinish'
		static public const FIRST_START:String = 'firstStart'
		static public const FIRST_FINISH:String = 'firstFinish'
		static public const START:String = 'start'
		static public const FINISH:String = 'finish'
		
		private var _advance:Number
		private var _data:Object;
		private var _first_view:Boolean;
		private var _sequence_length:uint = 1
		private var _current_sequence:uint = 0
		
		public function ChangeEvent(type:String, progress:Number = 0, sequence_length:uint=1, current_sequence:uint=0, data:Object = null, first_view:Boolean=true, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			this._advance = progress
			this._sequence_length = sequence_length
			this._current_sequence = current_sequence
			this._first_view = first_view
			this._data = data || {}
		}
		
		public function get data():Object{return _data;}
		public function get advance():Number{return _advance;}
		public function get retreat():Number{return 1 - _advance;}
		public function get sequence_length():uint{return _sequence_length;}
		public function get current_sequence():uint{return _current_sequence;}
		public function get first_view():Boolean{return _first_view;}
		
		public function advance_fragment(from:Number = 0, to:Number = 1):Number { return NumberTools.fragment(advance, from, to) }
		public function retreat_fragment(from:Number = 0, to:Number = 1):Number { return NumberTools.fragment(retreat, from, to) }
		
		public function advance_apart( current:uint, parts:uint, options:Object = null):Number { return NumberTools.apart(advance, current, parts, options) }
		public function retreat_apart( current:uint, parts:uint, options:Object = null):Number { return NumberTools.apart(retreat, current, parts, options) }

		public function advance_text_fragment(string:String, from:Number = 0, to:Number = 1):String { return StringTools.fragment(advance, string, from, to) }
		public function retreat_text_fragment(string:String, from:Number = 0, to:Number = 1):String { return StringTools.fragment(retreat, string, from, to) }
		
		public function advance_text_apart( string:String, current:uint, parts:uint, options:Object = null):String { return StringTools.apart(advance, string, current, parts, options) }
		public function retreat_text_apart( string:String, current:uint, parts:uint, options:Object = null):String { return StringTools.apart(retreat, string, current, parts, options) }
		
		
		public override function clone():Event 
		{ 
			return new ChangeEvent(type, advance, sequence_length, current_sequence, data, bubbles, cancelable);
		}
		
		public function firstInSequence():Boolean {
			return this.current_sequence == 0
		}
		
		public function lastInSequence():Boolean {
			return this.current_sequence == (this.sequence_length - 1)
		}
		
		
		public override function toString():String 
		{ 
			return formatToString("ChangeEvent", "type", "advance", "current_sequence", "sequence_length", "data", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}