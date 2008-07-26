package framy.texts {
	import flash.display.DisplayObject;
	import framy.ActionSprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import framy.events.ScrollMoveEvent;
	/**
	* ...
	* @author Default
	*/
	public class Scroller extends ActionSprite{
		protected var bg:ActionSprite
		protected var scroller:ActionSprite
		protected var scrollable:DisplayObject
		
		public function Scroller(bg:ActionSprite, scroller:ActionSprite, scrollable:DisplayObject) {
			this.bg = bg
			this.scroller = scroller
			this.scrollable = scrollable
			
			this.scroller.addEventListener(MouseEvent.MOUSE_DOWN, this.onStartDrag)
			this.scroller.buttonMode = true
		}
		
		private function onStartDrag(event:MouseEvent):void {
			this.scroller.startDrag(false, new Rectangle(0, 0, 0, this.bg_height - this.scroller_height))
			this.stage.addEventListener(MouseEvent.MOUSE_UP, this.onRelease)
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE, this.onMove)
		}

		
		private function onMove(event:MouseEvent):void {
			var n:Number = this.scroller_position
			this.dispatchEvent(new ScrollMoveEvent(this.scroller.y, n, n*(this.bg_height - this.content_height)))
		}
		
		private function onMouseWheel(event:MouseEvent):void {
			var new_y:int = this.scroller.y + -event.delta * 3
			event.stopPropagation()
			this.scroller.y = Math.min(Math.max(new_y, 0), this.bg_height - this.scroller_height)
			this.onMove(event)
		}
		
		protected function get scroller_position():Number {
			return this.scroller.y / (this.bg_height - this.scroller_height)
		}
		
		private function onRelease(event:MouseEvent):void {
			this.scroller.stopDrag()
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, this.onRelease)
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.onMove)
		}
		
		public function reset():void {
			this.scroller.y = 0
		}
		
		public function resize(height:uint):void {
			var new_scroller_height:Number = height * (height / this.content_height)
			this.scroller_height = new_scroller_height
			this.bg_height = height
			
			if (height < (this.scroller.y + new_scroller_height)) this.scroller.y = height - new_scroller_height
			if(this.scroller.y < 0)this.scroller.y = 0
			
			if ( height >= this.content_height) {
				if (this.alpha > 0) {
					this.tween( { alpha:0, time: 0.5 } )
					this.scroller.mouseEnabled = false
					this.scrollable.removeEventListener(MouseEvent.MOUSE_WHEEL, this.onMouseWheel)					
				}
			}
			else if (this.alpha < 1) {
				this.tween( { alpha:1, time: 0.7 } )
				this.scroller.mouseEnabled = true
				this.scrollable.addEventListener(MouseEvent.MOUSE_WHEEL, this.onMouseWheel)
			}
		}		
		
		// Getter and Setters
		// ========================================
		protected function get bg_height():uint {
			return this.bg.height
		}
		
		protected function set bg_height(h:uint):*{
			return this.bg.height = h
		}
		
		protected function get scroller_height():uint {
			return this.scroller.height
		}
		
		protected function set scroller_height(h:uint):*{
			return this.scroller.height = h
		}
		
		public function get content_height():uint {
			return this.scrollable.height
		}
		
	}
	
}