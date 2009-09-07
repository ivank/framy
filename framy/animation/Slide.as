package framy.animation {
	import caurina.transitions.Tweener;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import framy.utils.Hash;
	
	/**
	 * Allows defininig a "slide box" with a magnifier-like scroll effect within, When the mouse moves over the box,
	 * thie inner box is moved proportionaly, so that you can slide through all the width of the inner object,
	 * while sliding the smaller width of the container
	 */
	public class Slide {
		private var holder:DisplayObject
		public var frame:Rectangle
		public var padding:Point
		private var y:int = 0
		private var options:Hash
		private var container:DisplayObject
		
		/**
		 * Create a slider effect ( mangifier-like scroll ). 
		 * You can pass a "padding" parameter - a number or a Point object (for setting different x and y paddings). You can also pass a 'time' parameter in the options
		 * 
		 * @param	container global holder
		 * @param	holder element to slide
		 * @param	frame
		 * @param	opts
		 */
		public function Slide(container:DisplayObject, holder:DisplayObject, frame:Rectangle, opts:Object=null) {
			this.options = new Hash( { time: 0.5, padding: new Point(0,0) } ).merge(opts)
			this.frame = frame
			this.holder = holder
			this.container = container
			this.padding = this.options.padding is Point ? this.options.padding : new Point(this.options.padding, this.options.padding)
			delete this.options.padding
		}
		
		
		public function start():void {
			this.container.addEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMove)
		}
		
		public function stop():void {
			this.container.removeEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMove)
		}
		
		private function onMouseMove(event:MouseEvent):void {
			if (event.currentTarget == this.container) {
				if (this.frame.width) this._update((event.currentTarget as DisplayObject).mouseX, 'x','width')
				if (this.frame.height) this._update((event.currentTarget as DisplayObject).mouseY, 'y','height')
			}
		}
		
		public function normalize():void {
			if (this.frame.width && this.holder.width >= this.holder.width && this.holder.x != this.frame.x)Tweener.addTween(this.holder, {x: this.frame.x, time: this.options.time})
			if (this.frame.height && this.holder.height >= this.holder.height && this.holder.y != this.frame.y )Tweener.addTween(this.holder, {y: this.frame.y, time: this.options.time}) 
		}
		
		private function _update(local:Number, pos_metric:String, dim_metric:String):void {
			if ((this.frame[dim_metric]) < this.holder[dim_metric]) {
				var first_local:Number = local;
				var left_margin:Number = this.frame[pos_metric] + this.padding[pos_metric];
				var right_margin:Number = this.frame[pos_metric] + this.frame[dim_metric] - 2*this.padding[pos_metric];
				
				local = Math.max(left_margin, Math.min(right_margin, local))
				local -= (this.frame[pos_metric] +this.padding[pos_metric])

				var tw:Hash = this.options.dup
				tw[pos_metric] = Math.round( (local+this.frame[pos_metric] )- local*((this.holder[dim_metric]-3*this.padding[pos_metric])/(right_margin-left_margin)) )
				Tweener.addTween(this.holder, tw )
			}else {
				var snap:Hash = this.options.dup
				snap[pos_metric] = this.frame[pos_metric]
				Tweener.addTween(this.holder, snap )
				
			}
		}
		
	}
	
}
