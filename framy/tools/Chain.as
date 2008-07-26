package framy.tools {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import framy.ActionSprite;

	public class Chain{
		private var this_object:ActionSprite
		private var chain_rings:Array = new Array()
		private var fire_events:Dictionary = new Dictionary()
		private var event_dispatchers:Dictionary = new Dictionary()
		private var current:uint = 0
		
		public function Chain(thisObject:ActionSprite, clusure:Function) {
			this.chain_rings.push(clusure)
			this.this_object = thisObject
		}
		
		public function chain(event_type:String, dispatcher:EventDispatcher, closure:Function):Chain{
			this.chain_rings.push(closure)
			this.fire_events[closure] = event_type
			this.event_dispatchers[closure] = dispatcher
			return this
		}
		
		public function start():void{
			for(var i:uint=1; i < this.chain_rings.length; i++){
				var closure:Function = this.chain_rings[i]
				this.event_dispatchers[closure].addEventListener(this.fire_events[closure], this.onChainFire)
			}
			this.onChainFire(new Event(Event.ACTIVATE))
		}
		
		private function onChainFire(event:Event):void{
			var closure:Function = this.chain_rings[this.current]
			if(this.event_dispatchers[closure])this.event_dispatchers[closure].removeEventListener(this.fire_events[closure], this.onChainFire)
			closure.apply(this.this_object)
			this.current++
		}
		
	}
	
}
