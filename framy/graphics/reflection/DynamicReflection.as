package framy.graphics.reflection {
	import flash.display.Bitmap;
	import framy.ActionSprite;
	import framy.Rect;
	import framy.tools.Options;
	
	/**
	* ...
	* @author Ivan K (ikerin@gmail.com)
	*/
	public class DynamicReflection extends Reflection{
		private var window:Rect
		
		public function DynamicReflection(image_content:Bitmap, options:Object ) {
			this.options = new Options(options, { reflection_height: 70 } )
			this.reflection = new ActionSprite({})
			this.reflection.addChild(new Bitmap(image_content.bitmapData))
			this.reflection.getChildAt(0).transform = image_content.transform
			this.reflection.getChildAt(0).scaleY = -this.reflection.getChildAt(0).scaleY
			this.reflection.cacheAsBitmap = true
			this.reflection.getChildAt(0).y = image_content.height
			this.reflection.y = 0
			this.addChildren(this.reflection)
			
			super(image_content,this.options)
		}
		
		override public function slideIn(time:Number = 0.5, transition:* = "easeOutExpo"):void {
			this.reflection.y = -this.reflection.height
			this.reflection.tween( {  y:0, time: time, transition:transition})
		}
		
		override public function slideOut(time:Number = 0.5, transition:* = "easeOutExpo"):void {
			this.reflection.y = 0
			this.reflection.tween( {  y:-this.reflection.height, time: time, transition:transition})
		}
	}
	
}