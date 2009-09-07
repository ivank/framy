package framy.graphics 
{
	import caurina.transitions.Tweener;
	import flash.display.GradientType;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.display.DisplayObject;
	import framy.structure.Initializer;
	import framy.structure.Widget;
	import framy.utils.Colors;
	import framy.utils.FunctionTools;
	import framy.utils.Hash;
	import flash.display.Graphics;
	
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
		public function fySprite(attributes:Object = null, ...new_children) 
		{
			super()
			this.attrs = attributes
			this.addChildren(new_children)
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
		public static function newRect(rect_options:Object = null, attributes:Object = null):fySprite { return new fySprite().drawRect(rect_options, attributes) }
		
		/**
		 * @see framy.graphics.fySprite#newRect fySprite.newRect    
		 */
		public function drawRect(rect_options:Object = null, attributes:Object = null):fySprite {
			var attrs:Hash = new Hash( { x: 0, y: 0, width: 150, height: 150, round: 0 } ).merge(rect_options)
			var rect:Rectangle = attrs.rect || new Rectangle(attrs.x, attrs.y, attrs.width, attrs.height)
			return this.drawWithFilling(function():void{
				this.drawRectangleWithRound(rect,attrs)
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
		public static function newFrame(rect_options:Object = null, attributes:Object = null):fySprite { return new fySprite().drawFrame(rect_options, attributes) }
		
		/**
		 * @see framy.graphics.fySprite#newFrame fySprite.newFrame    
		 */		
		public function drawFrame(rect_options:Object = null, attributes:Object = null):fySprite {
			var attrs:Hash = new Hash({x: 0, y: 0, width: 50, height: 50, line_width:1}).merge(rect_options)
			var rect:Rectangle = attrs.rect || new Rectangle(attrs.x, attrs.y, attrs.width, attrs.height)
			return this.drawWithFilling(function():void{
				this.drawRectangleWithRound(rect,attrs)
				rect.inflate( -attrs.line_width, -attrs.line_width)
				this.drawRectangleWithRound(rect,attrs)
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
		public static function newPoly(points:Array, options:Object =null, attributes:Object=null):fySprite { return new fySprite().drawPoly(points, options, attributes) }
		
		/**
		 * @see framy.graphics.fySprite#newPoly fySprite.newPoly    
		 */	
		public function drawPoly(points:Array, options:Object =null, attributes:Object=null):fySprite {
		  return this.drawWithFilling(function():void{
  		  this.graphics.moveTo(points[0].x, points[0].y)
  		  points.push(points.shift())
  		  for each( var p:Point in points)this.graphics.lineTo(p.x,p.y)
		  },options).setAttrs(attributes)
		}
		
		public static function newCross(options:Object = null, attributes:Object = null):fySprite { return new fySprite().drawCross(options, attributes) }
			
		/**
		 * @see framy.graphics.fySprite#newCross fySprite.newCross    
		 */				
		public function drawCross(options:Object = null, attributes:Object = null):fySprite {		
			var attrs:Hash = new Hash({x: 0, y: 0, width: 50, height: 50, line_thickness:1}).merge(options)
			var rect:Rectangle = attrs.rect || new Rectangle(attrs.x, attrs.y, attrs.width, attrs.height)
			return this.drawWithFilling(function():void {
				this.graphics.moveTo(rect.x, rect.y)
				this.graphics.lineTo(rect.x+rect.width, rect.y+rect.height)
				
				this.graphics.moveTo(rect.x, rect.y + rect.height)
				this.graphics.lineTo(rect.x + rect.width, rect.y)
			}, attrs).setAttrs(attributes)
		}
		

		/**
		 *	Creates a new fySprite and draws a circle inside
		 *	@param	options	 A hash of options, accepts x, y, radius, color and alpha
		 *	@param	attributes	 Applies thoes attributes to the whole fySprite after drawing the rectangle
		 *	@example Create a blue circle with 0.7 alpha of the filling:<listing version="3.0">
fySprite.newCircle({ radius: 10, x: 10, y:10, color: 'blue', alpha: 0.7})
	     *  </listing>
		 *	@return		The created fySprite
		 *	@see framy.graphics.fySprite#newFrame newFrame
		 *	@see framy.graphics.fySprite#newPoly newPoly
		 *	@see framy.graphics.fySprite#newCircle newRect
		 */
		public static function newCircle(options:Object = null, attributes:Object = null):fySprite { return new fySprite().drawCircle(options, attributes) }
		
		/**
		 * @see framy.graphics.fySprite#newCircle fySprite.newCircle    
		 */		
		public function drawCircle(options:Object = null, attributes:Object = null):fySprite {
			var opts:Hash = new Hash({ x:0, y: 0, radius: 50 }).merge(options)
			return this.drawWithFilling(function():void{
				this.graphics.drawCircle(opts.x, opts.y, opts.radius)
			},options).setAttrs(attributes)
		}
		
		/**
		 *	Creates a new fySprite and draws an arc inside
		 *	@param	options	 A hash of options, accepts x, y, radius, color, angle, start_angle, steps, closed and alpha
		 *	@param	attributes	 Applies thoes attributes to the whole fySprite after drawing the rectangle
		 *	@example Create a blue circle with 0.7 alpha of the filling:<listing version="3.0">
fySprite.newCircle({ radius: 10, x: 10, y:10, color: 'blue', alpha: 0.7})
	     *  </listing>
		 *	@return		The created fySprite
		 *	@see framy.graphics.fySprite#newFrame newFrame
		 *	@see framy.graphics.fySprite#newPoly newPoly
		 *	@see framy.graphics.fySprite#newCircle newRect
		 */		
		public static function newArc(options:Object = null, attributes:Object = null):fySprite { return new fySprite().drawArc(options, attributes) }
		
		
		/**
		 * @see framy.graphics.fySprite#drawArc fySprite.drawArc    
		 */
		public function drawArc(options:Object = null, attributes:Object = null):fySprite {
			var opts:Hash = new Hash( { x: 0, y: 0, radius: 50, start_angle: 0, angle: 360, steps: 8, closed: false } ).merge(options)
			
			return this.drawWithFilling(function():void {
				if(Math.abs(opts.angle) > 360)opts.angle = opts.angle % 360
				
				opts.angle = Math.PI / 180 * opts.angle
				var nAngleDelta:Number = opts.angle / 8;
				var nCtrlDist:Number = opts.radius / Math.cos(nAngleDelta / 2);
				
				opts.start_angle = Math.PI / 180 * (opts.start_angle % 360)
				
				var nAngle:Number = opts.start_angle;
				var nCtrlX:Number;
				var nCtrlY:Number;
				var nAnchorX:Number;
				var nAnchorY:Number;
				
				var nStartingX:Number = opts.x + Math.cos(opts.start_angle) * opts.radius;
				var nStartingY:Number = opts.y + Math.sin(opts.start_angle) * opts.radius;
				
				if (opts.closed) {
					this.graphics.moveTo(opts.x, opts.y);
					this.graphics.lineTo(nStartingX, nStartingY);
				}
				else {
					this.graphics.moveTo(nStartingX, nStartingY);
				}
				
				for (var i:Number = 0; i < 8; i++) {
					nAngle += nAngleDelta;
					nCtrlX = opts.x + Math.cos(nAngle-(nAngleDelta/2))*(nCtrlDist);
					nCtrlY = opts.y + Math.sin(nAngle-(nAngleDelta/2))*(nCtrlDist);
					nAnchorX = opts.x + Math.cos(nAngle) * opts.radius;
					nAnchorY = opts.y + Math.sin(nAngle) * opts.radius;
					this.graphics.curveTo(nCtrlX, nCtrlY, nAnchorX, nAnchorY);
				}
				if(opts.closed) {
					this.graphics.lineTo(opts.x, opts.y);
				}
			},new Hash({alpha: 0, line_thickness: 1, line_color: 'black'}).merge(options)).setAttrs(attributes)
		}
		
		/**
		 * pass a 'gradient' hash to set set a gradient fill
		 * it has 'type', 'colors', 'alphas', 'ratios' 'rotation' and 'matrix' options, 'colors' array can contain named colors
		 *	@private
		 */
		public function drawWithFilling(draw:Function, options:Object=null):fySprite{
			var opts:Hash = new Hash( { 
				line_thickness: 0, 
				line_color: 'black', 
				line_alpha: 1, 
				line_pixel_hinting: false,
				line_scale_mode: LineScaleMode.NORMAL,
				line_caps: null,
				line_joints: null,
				line_miter_limit: 3,
				color: Initializer.options.color, 
				alpha: 1
			}).merge(options)
			
			if (opts.alpha > 0) {
				if (opts.gradient) {
					if(opts.gradient is Boolean)opts.gradient = {}
					opts.gradient.type = opts.gradient.type || GradientType.LINEAR;
					opts.gradient.colors = opts.gradient.colors || [ 0x000000, 0xFFFFFF ];
					opts.gradient.colors = opts.gradient.colors.map(function(e:*, i:int, arr:Array):* { return Colors.get(e) } );
					opts.gradient.alphas = opts.gradient.alphas || new Array(opts.gradient.colors.length).map(function(e:*, i:int, arr:Array):* { return 1 } );
					opts.gradient.ratios = opts.gradient.ratios || new Array(opts.gradient.colors.length).map(function(e:*, i:int, arr:Array):* { return Math.round(255 * (i / (arr.length-1))) } )
					if (!opts.gradient.matrix) {
						opts.gradient.matrix = new Matrix()
						opts.gradient.matrix.createGradientBox(opts.gradient.width || opts.width || 50, opts.gradient.height || opts.height || 50, opts.gradient.rotation || 0)
					}
					this.graphics.beginGradientFill(opts.gradient.type, opts.gradient.colors, opts.gradient.alphas, opts.gradient.ratios, opts.gradient.matrix )
				}
				else this.graphics.beginFill(Colors.get(opts.color), opts.alpha)
			}
			
			if (opts.line_thickness > 0) {
				this.graphics.lineStyle(
					opts.line_thickness, 
					Colors.get(opts.line_color), 
					opts.line_alpha, 
					opts.line_pixel_hinting, 
					opts.line_scale_mode, 
					opts.line_caps, 
					opts.line_joints, 
					opts.line_miter_limit) 
				}
				
			draw.apply(this)
			if (opts.alpha > 0)this.graphics.endFill()
			return this
		}
		
		/**
		 *	@private
		 */
		private function drawRectangleWithRound(rect:Rectangle, attrs:Hash):void
		{
			if(attrs.round)
  				this.graphics.drawRoundRect(rect.x, rect.y, rect.width, rect.height, attrs.round, attrs.round)
			else
  				this.graphics.drawRect(rect.x, rect.y, rect.width, rect.height)			
		}

	}
	
}