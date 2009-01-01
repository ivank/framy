package framy.graphics 
{
	import caurina.transitions.Tweener;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.display.DisplayObject;
	import framy.structure.Initializer;
	import framy.structure.Widget;
	import framy.utils.Colors;
	import framy.utils.FunctionTools;
	import framy.utils.Hash;
	
	/**
	 * Adds some functionality to the Sprite class - easy children add/remove, graphic functions.
	 * @see	framy.graphics.MaskableSprite MaskableSprite
	 * @author IvanK (ikerin@gmail.com)
	 */
	public class fySprite extends MaskableSprite
	{
		include './Position.mixin'
		include './VerticalPosition.mixin'
		
		public var progress:Number = 0
		
		/**
		 *	Creates a fySprite and assigns the attributes to it
		 *	@constructor
		 */
		public function fySprite(attributes:Object = null) 
		{
			super()
			this.attrs = attributes
		}
		
		/**
		 *	The same as addChild, but accepts more than one child, and adds them all
		 *	@param	arguments	 DisplayObjects to add to this sprite
		 *	@return		Returns itself
		 *	@see	framy.graphics.fySprite#removeChildren removeChildren
		 */
		public function addChildren(...arguments):void { FunctionTools.flatten_args(this.addChildren, this.addChild, arguments) }
		
		/**
		 *	The same as removeChild, but accepts more than one child, and removes them all
		 *	@param	arguments	 DisplayObjects to remove from this sprite
		 *	@return		Returns itself
		 *	@see	framy.graphics.fySprite#addChildren addChildren
		 */
		public function removeChildren(...arguments):void { FunctionTools.flatten_args(this.removeChildren, this.removeChild, arguments) }
		
		/*public function get widget():Widget{
		  return Initializer.getWidget(this)
		}*/
		
		/**
		 *	Applies Rectangle#inflate to the whole sprite
		 *	@see	flash.geom.Rectangle#inflate Rectangle#inflate
		 */
		public function inflate(dx:Number, dy:Number):fySprite {
			var new_rect:Rectangle = this.rect
			new_rect.inflate(dx, dy)
			this.rect = new_rect
			return this 
		}
		
		/**
		 *	A proxy for Tweener.addTween(this, arguments)
		 *	@param	arguments	 Fashes of parameters for the tween, each one is merged with the next
		 *	@return		Returns itslef
		 */		
		public function tween(...arguments):fySprite {
			var parameters:Hash = new Hash()
			for each( var parameters_elem:Object in arguments) parameters.merge(parameters_elem);
			Tweener.addTween(this, Colors.convertColors(parameters))
			return this
		}
		
		/**
		 *	A proxy for Tweener.removeTweens(this, params)
		 *	@return		Returns itslef
		 */		
		public function removeTweens(params:Object = null):fySprite {
			Tweener.removeTweens(this, params)
			return this
		}
		
		/**
		 *	Creates a new fySprite and draws a rectangle inside
		 *	@param	rect_options	 A hash of options, used to create the rectangle, accepts x, y, height, width, rect, color and alpha
		 *	@param	attributes	 Applies thoes attributes to the whole fySprite after drawing the rectangle
		 *	@example Create a red square with 0.5 alpha of the filling:<listing version="3.0">
fySprite.newRect({ width: 30, height: 30, color: 'red', alpha: 0.5})
	     *  </listing>
		 *	@return		The created fySprite
		 *	@see framy.graphics.fySprite#newFrame newFrame
		 *	@see framy.graphics.fySprite#newPoly newPoly
		 *	@see framy.graphics.fySprite#newCircle newCircle
		 */
		public static function newRect(rect_options:Object = null, attributes:Object = null):fySprite {
			var attrs:Hash = new Hash( { x: 0, y: 0, width: 150, height: 150 } ).merge(rect_options)
			var rect:Rectangle = attrs.rect || new Rectangle(attrs.x, attrs.y, attrs.width, attrs.height)
			return new fySprite().drawWithFilling(function():void{
  			this.graphics.drawRect(rect.x, rect.y, rect.width, rect.height)
			}, rect_options).setAttrs(attributes)
		}
		
		/**
		 *	Creates a new fySprite and draws a frame (holed rectangle) inside
		 *	The default width of the frame is 1 pixel
		 *	@param	rect_options	 A hash of options, used to create the rectangle, accepts x, y, height, width, rect, color, alpha and line_width
		 *	@param	attributes	 Applies thoes attributes to the whole fySprite after drawing the rectangle
		 *	@example Create a yellow one 2 pixel frame:<listing version="3.0">
fySprite.newFrame({ width: 30, height: 50, color: 'yellow', line_width: 1})
	     *  </listing>
		 *	@return		The created fySprite
		 *	@see framy.graphics.fySprite#newRect newRect
		 *	@see framy.graphics.fySprite#newPoly newPoly
		 *	@see framy.graphics.fySprite#newCircle newCircle
		 */		
		public static function newFrame(rect_options:Object = null, attributes:Object = null):fySprite {
			var attrs:Hash = new Hash({x: 0, y: 0, width: 50, height: 50, line_width:1}).merge(rect_options)
			var rect:Rectangle = attrs.rect || new Rectangle(attrs.x, attrs.y, attrs.width, attrs.height)
			return new fySprite().drawWithFilling(function():void{
			  this.graphics.drawRect(rect.x, rect.y, rect.width, rect.height)
			  rect.inflate( -attrs.line_width, -attrs.line_width)
			  this.graphics.drawRect(rect.x, rect.y, rect.width, rect.height)
			  this.scale9Grid = rect
			}, rect_options).setAttrs(attributes)
		}
		
		/**
		 *	Creates a new fySprite and draws a polygon inside it - the polygon is represented by an array of endpoints (corners)
		 *	Using this you can draw triangles, rectangles, pentagons, stars, etc ...
		 *	@param	points	 An array of points (using the Point class)
		 *	@param	options	 A hash of options, used to fill the polygon, accepts color and alpha
		 *	@param	attributes	 Applies thoes attributes to the whole fySprite after drawing the rectangle
		 *	@example Create an orange trinagle:<listing version="3.0">
import flash.geom.Point

fySprite.newPoly([new Point(0,0), new Point(100,50), new Point(0,100)], { color: 'orange' })
	     *  </listing>
		 *	@return		The created fySprite
		 *	@see framy.graphics.fySprite#newRect newRect
		 *	@see framy.graphics.fySprite#newPoly newFrame
		 *	@see framy.graphics.fySprite#newCircle newCircle
		 *	@see flash.geom.Point flash.geom.Point
		 */			
		public static function newPoly(points:Array, options:Object =null, attributes:Object=null):fySprite {
		  return new fySprite().drawWithFilling(function():void{
  		  this.graphics.moveTo(points[0].x, points[0].y)
  		  points.push(points.shift())
  		  for each( var p:Point in points)this.graphics.lineTo(p.x,p.y)
		  },options).setAttrs(attributes)
		}

		/**
		 *	Creates a new fySprite and draws a circle inside
		 *	@param	options	 A hash of options, used to create the circle, accepts x, y, radius, color and alpha
		 *	@param	attributes	 Applies thoes attributes to the whole fySprite after drawing the rectangle
		 *	@example Create a blue circle with 0.7 alpha of the filling:<listing version="3.0">
fySprite.newCircle({ radius: 10, x: 10, y:10, color: 'blue', alpha: 0.7})
	     *  </listing>
		 *	@return		The created fySprite
		 *	@see framy.graphics.fySprite#newFrame newFrame
		 *	@see framy.graphics.fySprite#newPoly newPoly
		 *	@see framy.graphics.fySprite#newCircle newRect
		 */
		public static function newCircle(options:Object =null, attributes:Object=null):fySprite {
		  var opts:Hash = new Hash({ x:0, y: 0, radius: 50 }).merge(options)
		  return new fySprite().drawWithFilling(function():void{
		    this.graphics.drawCircle(opts.x, opts.y, opts.radius)
		  },options).setAttrs(attributes)
		}
		
		/**
		 *	@private
		 */
		private function drawWithFilling(draw:Function, options:Object=null):fySprite{
		  var opts:Hash = new Hash({ color: Initializer.options.color, alpha: 1}).merge(options)
		  this.graphics.beginFill(Colors.get(opts.color), opts.alpha)
		  draw.apply(this)
		  this.graphics.endFill()
		  return this
		}

	}
	
}