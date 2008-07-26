package framy.core {
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import framy.ActionSprite;
	import framy.events.ActionEvent;

	public class Resizable extends EventDispatcher{
		private var subject:ActionSprite;
		
		private var timer:Timer = new Timer(250, 1)
		static public var wait:Boolean = false
		private var _captured_event:Event
		
		public function Resizable(subject:ActionSprite) {
			this.subject = subject
			this.subject.addEventListener(Event.ADDED_TO_STAGE, this.init)
			this.subject.addEventListener(Event.REMOVED_FROM_STAGE, this.clear)
			if(this.subject.stage)this.init(new Event(Event.ADDED_TO_STAGE))
		}
		
		public function remove():void {
			this.subject.removeEventListener(Event.ADDED_TO_STAGE,this.init)
			this.subject.removeEventListener(Event.REMOVED_FROM_STAGE,this.clear)
		}
		
		private function init(event:Event):void {
			this.subject.dispatchEvent(new Event(ActionEvent.INIT_RESIZE))
			this.subject.stage.addEventListener(Event.RESIZE, this.onInitResize)
			this.subject.stage.addEventListener(Event.RESIZE, this.onResize)
			this.timer.addEventListener(TimerEvent.TIMER_COMPLETE, this.onTimeoutResize)
		}
		
		private function clear(event:Event):void {
			this.subject.stage.removeEventListener(Event.RESIZE, this.onInitResize)
			this.subject.stage.removeEventListener(Event.RESIZE, this.onResize)
		}
		
		private function onInitResize(event:Event):void {
			this.subject.dispatchEvent(new Event(ActionEvent.INIT_RESIZE))
		}
		
		private function onTimeoutResize(timeout_resize:Event):void {
			this.subject.dispatchEvent(_captured_event)
		}
		
		private function onResize(resize:Event):void {
			
			if (wait) {
				this.subject.dispatchEvent(new Event(ActionEvent.RESIZE_STARTED))
				this._captured_event = resize
				timer.reset()
				timer.start()
			}
			else this.subject.dispatchEvent(resize)
		}
		
	}
	
}
