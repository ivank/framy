package framy.texts {
	import framy.ActionText;
	import framy.tools.Options;
	import flash.events.Event;
	import caurina.transitions.Equations;
	import caurina.transitions.Tweener;
	
	public class DestructEffect extends Effect{
		
		public function DestructEffect(field:ActionText,opts:Object=0) {
			super(field,opts, {time:0.4, delay:0, transition:Equations.easeNone, noise:3})
		}
		
		public function start():void {
			this.field.setSelection(0,0)
			this.set_rand_chars(this.field.text)
			this.old_text = this.field_text
			
			this.effect_pos = this.old_text.length
			Tweener.addTween(this, {effect_pos:0, time:this.options.time,  delay:this.options.delay, onComplete:this.onComplete, onUpdate:this.step, transition:this.options.transition})
		}
		
		
		override protected function rounded_step():void{
			var max_noise:uint = Math.min(this.options.noise,this.rounded_effects_pos,this.old_text.length-this.rounded_effects_pos)
			this.field_text = this.old_text.substr(0,this.rounded_effects_pos) + this.generate_noise(max_noise)
		}
		
	}
	
}
