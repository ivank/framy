package framy.graphics.reflection {
	import flash.display.DisplayObject;
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.display.GradientType;
	import flash.display.BitmapData
	import framy.ActionSprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import framy.tools.Options;
	
	/**
	* ...
	* @author Ivan K (ikerin@gmail.com)
	*/
	public class Reflection extends ActionSprite{
		protected var gradient_mask:ActionSprite;
		protected var options:Options
		protected var reflection:ActionSprite
		
		public function Reflection(image_content:DisplayObject, options:Object ) {
			this.options = new Options(options, { reflection_height: 70 } )
			if (!this.options.solid) {
				this.gradient_mask = new ActionSprite()
				var gradient_matrix:Matrix = new Matrix()
				gradient_matrix.createGradientBox(image_content.width, this.options.reflection_height, Math.PI/2)
				this.gradient_mask.graphics.beginGradientFill(GradientType.LINEAR, [0x000000, 0x000000, 0x000000], [0.2, 0.05, 0], [0x00, 0x88, 0xFF], gradient_matrix)
				this.gradient_mask.graphics.drawRect(0, 0, image_content.width, this.options.reflection_height)
				this.gradient_mask.graphics.endFill()
				this.gradient_mask.cacheAsBitmap = true
				this.reflection.mask = this.gradient_mask
				this.addChildren(this.gradient_mask)
			}
		}
		
		public function set content_width(value:uint):* {	
			this.gradient_mask.width = value
			return this.reflection.width = value
		}
		public function set content_height(value:uint):* {
			this.gradient_mask.width = value
			return this.reflection.height = value	
		}		
		public function get content_width():uint { return this.reflection.width; }
		public function get content_height():uint { return this.reflection.height; }		
		
		public function slideIn(time:Number = 0.5, transition:* = "easeOutExpo"):void { throw Error("This is a virtual method") }
		public function slideOut(time:Number = 0.5, transition:* = "easeOutExpo"):void { throw Error("This is a virtual method") }
	}
}