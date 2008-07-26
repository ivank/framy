package framy.graphics.reflection {
	import flash.display.Bitmap;
	import flash.display.GradientType;
	import flash.display.BitmapData
	import flash.geom.Matrix;
	import framy.ActionSprite;
	import framy.tools.Options;
	import flash.geom.Rectangle;
	
	/**
	* ...
	* @author Ivan K (ikerin@gmail.com)
	*/
	public class SolidReflection extends Reflection{
		
		public function SolidReflection(image_content:Bitmap, opts:Object = null) {
			this.options = new Options(opts, { reflection_height: 70 } )
			this.reflection = new ActionSprite()
			var gradient_matrix:Matrix = new Matrix()
			gradient_matrix.createGradientBox(image_content.width, this.options.reflection_height, Math.PI/2)
			this.reflection.graphics.beginGradientFill(GradientType.LINEAR, this.options.solid, [1, 1], [0x00, 0xFF], gradient_matrix)
			this.reflection.graphics.drawRect(0, 0, image_content.width, this.options.reflection_height)
			this.reflection.graphics.endFill();
			
			this.reflection.scrollRect = new Rectangle(0, 0, this.reflection.width, this.reflection.height)
			this.addChild(this.reflection)
			
			super(image_content,opts)
		}
		
		override public function set content_width(value:uint):* {	
			return this.reflection.width = value
		}
		override public function set content_height(value:uint):* {
			return this.reflection.height = value	
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