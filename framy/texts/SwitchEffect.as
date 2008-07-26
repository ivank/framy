package framy.texts {
	import caurina.transitions.Tweener;
	import flash.events.EventDispatcher;
	import framy.ActionText;
	import framy.tools.Options;
	import caurina.transitions.Equations;
	import framy.tools.Options;
	import flash.events.Event;

	public class SwitchEffect extends Effect{
		
		public function SwitchEffect(field:ActionText, options:Object=null) {
			super(field,options, {time:0.5, transition:Equations.easeNone, noise:4})
		}
		
		
		public function start(new_text:String = null):void {
			this.field.setSelection(0,0)
			this.set_rand_chars(new_text)
			this.new_text = new_text 
			this.old_text = this.field_text
			
			this.effect_pos = 0
			Tweener.addTween(this,{effect_pos: Math.max(this.new_text.length, this.old_text.length), onComplete:this.onComplete, onUpdate:this.step, time:options.time, transition: options.transition})
		}
		
		override protected function rounded_step():void{
			var max_noise:int = Math.min(
				Math.round(this.options.noise/2), 
				this.rounded_effects_pos, 
				Math.max(this.new_text.length,this.old_text.length)-this.rounded_effects_pos
			)
			this.field_text = this.new_text.substr(0, Math.min(this.rounded_effects_pos,this.new_text.length)-max_noise) + 
				this.generate_noise(max_noise*2) +
				this.old_text.substr(Math.min(this.rounded_effects_pos,this.old_text.length)+max_noise)
				
		}		
		
	}
	
}
