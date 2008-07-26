package framy.texts {
	import caurina.transitions.Equations;
	import flash.events.Event;
	import flash.text.TextFormat;
	import framy.ActionText;
	import caurina.transitions.Tweener;
	import framy.events.NProgressEvent;
	import framy.tools.Html;

	public class ConstructEffect extends Effect {

		public function ConstructEffect(field:ActionText,opts:Object=null) {
			super(field,opts, {time:0.4, delay:0, transition:Equations.easeNone, noise:5})
		}
		
		public function start(new_text:String):void {
			this.field.setSelection(0,0)
			this.set_rand_chars(new_text)
			this.new_text = new_text
			this.effect_pos = 0
			Tweener.addTween(this, {effect_pos:new_text.length, time:this.options.time, delay:this.options.delay, onComplete:this.onComplete, onUpdate:this.step, transition:this.options.transition})
		}
		
		
		override protected function rounded_step():void{
			var max_noise:uint = Math.min(this.options.noise, this.new_text.length - this.rounded_effects_pos)
			this.field_text = this.new_text.substr(0,this.rounded_effects_pos) + this.generate_noise(max_noise)
		}
		
	}
	
}
