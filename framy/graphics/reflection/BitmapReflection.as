package framy.graphics.reflection {
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.display.GradientType;
	import flash.display.BitmapData
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	import flash.geom.Transform;
	import framy.ActionSprite;
	import flash.geom.Rectangle;
	import framy.tools.Options;
	import flash.geom.Point;
	
	/**
	* ...
	* @author Ivan K (ikerin@gmail.com)
	*/
	public class BitmapReflection extends Reflection{
		public function BitmapReflection(image_content:Bitmap, opts:Object) {
			this.options = new Options(opts, { reflection_height: 70 } )
			
			
			var reflection_bitmap:BitmapData = new BitmapData(image_content.width/image_content.scaleX, this.options.reflection_height/image_content.scaleY)
			var copy_rect:Rectangle = new Rectangle(0, (image_content.height - this.options.reflection_height)/image_content.scaleX, image_content.width/image_content.scaleX, this.options.reflection_height/image_content.scaleY)
			reflection_bitmap.copyPixels((image_content as Bitmap).bitmapData, copy_rect, new Point(0, 0))
			
			this.reflection = new ActionSprite()
			this.reflection.addChild(new Bitmap(reflection_bitmap))
			
			if(!(image_content.scaleX == image_content.scaleY == 1))this.reflection.getChildAt(0).transform = image_content.transform
			this.reflection.getChildAt(0).scaleY = -this.reflection.getChildAt(0).scaleY
			this.reflection.cacheAsBitmap = true
			this.reflection.getChildAt(0).y = this.reflection.height
			
			
			this.reflection.scrollRect = new Rectangle(0, 0, this.reflection.width, this.reflection.height)
			
			this.addChildren(this.reflection)
			super(image_content,this.options )
		}
		
		override public function slideIn(time:Number = 0.5, transition:* = "easeOutExpo"):void {
			this.reflection.scrollRectY = this.reflection.height
			this.reflection.tween( { scrollRectY:0 , time: time, transition:transition})
		}
		
		override public function slideOut(time:Number = 0.5, transition:* = "easeOutExpo"):void {
			this.reflection.scrollRectY = 0
			this.reflection.tween( { scrollRectY:this.reflection.height , time: time, transition:transition})
		}				
	}
	
}