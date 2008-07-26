package framy.texts {
	import caurina.transitions.Tweener;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import framy.ActionText;
	import framy.events.ActionEvent;
	import framy.events.NProgressEvent;
	import framy.tools.Html;
	import framy.tools.Options;
	import flash.utils.setTimeout;

	public class Effect extends EventDispatcher {
		static private const RAND_CHARS:String = "qwertyuiopasdfghjklzxcvbnm"
		static private const RAND_CHARS_BG:String = "чявертъуиопшщасдфгхйклзьцжбнмю"
		static private const RAND_CHARS_NUM:String = "0123456789"
		
		public var effect_pos:Number = 0
		protected var new_text:String = ""
		protected var old_text:String = ""
		public var field:ActionText
		protected var options:Options
		private var rand_chars:String = RAND_CHARS
		protected var rounded_effects_pos:uint = 0;
		private var customOnComplete:Function
		
		
		public function Effect(field:ActionText, opts:Object, def:Object) {
			this.field = field
			this.options = new Options(opts, def)
			if(this.options.onComplete)this.customOnComplete = this.options.onComplete
		}
		
		protected function set_rand_chars(txt:String):void{
			var last_char:String = txt.charAt(txt.length-1)
			if (RAND_CHARS_BG.indexOf(last_char.toLowerCase()) >= 0) this.rand_chars = RAND_CHARS_BG
			else if(RAND_CHARS_NUM.indexOf(txt.charAt(0)) >= 0 && RAND_CHARS_NUM.indexOf(txt.charAt(1)) >=0)this.rand_chars = RAND_CHARS_NUM
			else this.rand_chars = RAND_CHARS
			
			this.rand_chars = last_char.match(/[A-ZА-Я]{1}/) ? this.rand_chars.toLocaleUpperCase() : this.rand_chars
		}
		
		protected function step():void{
			this.dispatchEvent(new Event(ActionEvent.EFFECT_PROGRESS))
			if(Math.round(this.effect_pos) != this.rounded_effects_pos){
				this.dispatchEvent(new Event(ActionEvent.EFFECT_PROGRESS_ROUND))
				this.rounded_effects_pos = Math.round(this.effect_pos)
				this.rounded_step()
			}
		}
		
		public function stop():void {
			Tweener.removeTweens(this)
		}
		
		public function dispatchAfter(delay:Number,event:Event):int{
			return setTimeout(this.onDispatchAfterReached,delay*1000,event)
		}
		
		private function onDispatchAfterReached(event:Event):void{this.dispatchEvent(event)}		
		
		protected function rounded_step():void{}
		
		protected function generate_noise(len:uint):String{
			var noise:String = ""
			for(var i:int = 0; i < len; i++)noise += this.rand_chars.charAt(Math.random()*this.rand_chars.length)
			return noise;
		}
		
		protected function onComplete():void {
			if(this.customOnComplete != null)this.customOnComplete.apply(this.field)
			this.dispatchEvent(new Event(ActionEvent.EFFECT_COMPLETE))
		}
		
		protected function set field_text(new_text:String):*{
			if (this.options.html)
				this.field.htmlText = new_text
			
			else this.field.text = new_text
		}
		
		protected function get field_text():String{
			return this.options.html ? this.field.htmlText : this.field.text
		}
		
	}
	
}
