package framy.graphics.reflection {
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import framy.ActionSprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import framy.Rect;
	import framy.graphics.CustomEasings;
	import framy.tools.Options;
	import caurina.transitions.Tweener;
	import flash.display.GradientType;
	
	/**
	* ...
	* @author Ivan K (ikerin@gmail.com)
	*/
	public class ReflectionSprite extends ActionSprite {
		static public const SLIDE_IN:String = "SlideInEffect"
		static public const APPEAR:String = "AppearEffect"
		static public const NONE:String = "AppearNONE"		
		
		public var reflection:*
		private var content_mask:Rect
		public var content:ActionSprite
		private var options:Options
		
		public function ReflectionSprite(opts:Object = null) {
			this.content = new ActionSprite()
			this.addChildren(this.content)
			super(opts)
		}
		
		public function get image_width():uint { return this.content.width }
		public function set image_width(value:uint):* {	
			this.content_mask.width = value
			this.reflection.content_width = value
			return this.content.width = value
		}
		
		public function get image_height():uint { return this.content.height }
		public function set image_height(value:uint):* { 
			this.content_mask.height = value
			this.reflection.y = value
			return this.content.height = value
		}
		
		public function update_positions():void {
			this.reflection.y = this.content.height
			this.content_mask.dims = this.content.dims
		}
		
		
		public function create_reflection(opts:Object = null):void {
			this.options = new Options(opts, { solid:false, reflection_height: 50, appear: APPEAR, appear_time: 1.5 } )
			
			var info_content:BitmapData = new BitmapData(this.content.width,this.content.height, true)
			info_content.draw(this.content)
			if (this.options.solid) {
				this.reflection = new SolidReflection(new Bitmap(info_content), this.options )
			}else {
				this.reflection = new BitmapReflection(new Bitmap(info_content), this.options )
			}
			
			this.reflection.y = this.content.height
			
			this.content_mask = new Rect( { dims: this.content.dims } )
			this.content.mask = this.content_mask
			this.addChildren(this.reflection, this.content_mask)
		}
		
		public function slideIn():void {
			switch(this.options.appear) {
				case APPEAR:
					this.content.alpha = 0
					Tweener.addTween( this.content, { alpha: 1, time: this.options.appear_time, onComplete:onCompleteAppear } )
					break;
				case SLIDE_IN:
					this.content.y = this.image_height
					Tweener.addTween( this.content, { y: 0, time: this.options.appear_time, transition: CustomEasings.smooth, onComplete:onCompleteAppear } )
					this.reflection.slideIn(this.options.appear_time, CustomEasings.smooth)
					break;
			}
			
			this.reflection.slideIn(this.options.appear_time)
		}
		
		private function onCompleteAppear():void {
			this.dispatchEvent(new Event(Event.COMPLETE))
		}		
		
		public function slideOut(time:Number=0.5, transition:* = null):void {
			Tweener.addTween( this.content, { y: this.image_height, time: time, transition: CustomEasings.smooth, onComplete:onCompleteAppear } )
			this.reflection.slideOut(time, transition)
		}
	}
	
}