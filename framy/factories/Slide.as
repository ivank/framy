package framy.factories {
	import caurina.transitions.Tweener;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import framy.tools.Options;
	
	/**
	 * Allows defininig a "slide box" with a magnifier-like scroll effect within
	 */
	public class Slide {
		private var holder:DisplayObject
		public var width:uint = 0
		public var height:uint = 0
		public var x:int = 0
		public var y:int = 0
		public var time:Number
		
		public function Slide(holder:DisplayObject, opts:Object) {
			var options:Options = new Options(opts, { x:0, y:0, width:0, height:0, time: 0.5 } )
			options.parse_pos()
			options.parse_size()
			
			this.height = options.height
			this.width = options.width
			this.x = options.x
			this.y = options.y
			this.time = options.time
			
			this.holder = holder
		}
		
		public function start():void {
			this.holder.parent.addEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMove)
		}
		
		public function stop():void {
			this.holder.parent.removeEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMove)
		}
		
		private function onMouseMove(event:MouseEvent):void {
			if (event.currentTarget == this.holder.parent) {
				if (this.width) this._update((event.currentTarget as DisplayObject).mouseX, 'x','width')
				if (this.height) this._update((event.currentTarget as DisplayObject).mouseY, 'y','height')
			}
		}
		
		public function normalize():void {
			if (this.width && this.holder.width >= this.holder.width && this.holder.x != this.x)Tweener.addTween(this.holder, {x: this.x, time: this.time})
			if (this.height && this.holder.height >= this.holder.height && this.holder.y != this.y )Tweener.addTween(this.holder, {y: this.y, time: this.time}) 
		}
		
		private function _update(local:Number, pos_metric:String, dim_metric:String):void {
			if (this[dim_metric] < this.holder[dim_metric]) {
				local = Math.min(this[dim_metric], Math.max(local, 0))
				var tw:Object = { time: this.time }
				tw[pos_metric] = Math.round(local - (local) * (this.holder[dim_metric] / this[dim_metric]) + this[pos_metric])
				Tweener.addTween(this.holder, tw )
			}else {
				this.holder[pos_metric] =  this[pos_metric]
			}
		}
		
	}
	
}
