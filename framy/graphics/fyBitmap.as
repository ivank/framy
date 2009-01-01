package framy.graphics 
{
	import flash.display.Bitmap;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import framy.utils.Hash;
	import framy.utils.Colors;
	import caurina.transitions.Tweener;
	
	/**
	 * Adds some functionality to the Bitmap class - auto smoothing while tweeing, color sampling
	 * @author IvanK (ikerin@gmail.com)
	 */
	public class fyBitmap extends Bitmap
	{
		include './Position.mixin'
		include './VerticalPosition.mixin'
		
		static public const RESAMPLE_INVOKERS:Array = ['scaleX', 'scaleY', 'width', 'height', 'alpha']
		
		/**
		 *	creates a new bitmap - the same as the Bitmap class, but allows setting default attributes
		 *	@param	attributes	 a hash of attributes to be applyed on creation
		 *	@constructor
		 */
		public function fyBitmap(attributes:Object = null)
		{
			this.attrs = attributes
		}
		
		/**
		 *	A proxy for Tweener.addTween(this, arguments), but removes the smoothing if the parameters being tweened cause redraw
		 *	significantly improving performance, but while it's tweening it looks a bit pixelated
		 *	@param	arguments	 Fashes of parameters for the tween, each one is merged with the next
		 *	@return		Returns itslef
		 */
		public function tween(...arguments):fyBitmap {
			var parameters:Hash = new Hash()
			for each( var parameters_elem:Object in arguments) parameters.merge(parameters_elem);
			
			if (parameters.has(RESAMPLE_INVOKERS) && this.smoothing) parameters.merge( { smoothing: false, onComplete:function():void { this.smoothing = true }}, true, true)
			
			Tweener.addTween(this, Colors.convertColors(parameters))
			return this
		}
		
		/**
		 *	A proxy for Tweener.removeTweens(this, params)
		 *	@return		Returns itslef
		 */
		public function removeTweens(params:Object = null):fyBitmap {
			Tweener.removeTweens(this, params)
			return this
		}		
		
		/**
		 *	Calculates the average color of a given area. If there is no bitmapData, throws an error
		 *	@param	area	 A rectangle where the colors are sampled
		 *	@return		The avarage color in the rectangle area
		 */
		public function getAverageColor(area:Rectangle):uint {
			if(!this.bitmapData)throw new Error("No bitmap data - cannot sample avarage color")
			var samples:uint = 0;
			var colR:uint = 0;
			var colG:uint = 0;
			var colB:uint = 0;
			
			for (var i:int = area.x; i < area.right; i++) {
				for ( var j:int = area.y; j < area.bottom; j++) {
					var col:uint = this.bitmapData.getPixel(i, j)
					colR += (col & 0xFF0000) >>> 16;
					colG += (col & 0x00FF00) >>> 8;
					colB += (col & 0x0000FF);
					samples ++;
				}
			}
			
			var cR:uint = Math.round(colR / samples) << 16;
			var cG:uint = Math.round(colG / samples) << 8;
			var cB:uint = Math.round(colB / samples);			
			
			return cR | cG | cB;
		}
	}
	
}