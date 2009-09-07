package framy.utils {
	import flash.geom.Rectangle;

	/**
	 *  An easy width/height manipulations with preservation of aspect ratio
	 *  
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Ivan K
	 *  @since  28.12.2008
	 */
	public class Aspect {
		
		private var _width:Number = 0
		private var _height:Number = 0
		
		private var _x:Number = 0
		private var _y:Number = 0
		
		private var ratio:Number = 0
		
		/**
		 *	After it's created with given width/height the aspect object preserves their ratio, so that for example if you modify the width,
		 *	the height will be changed accordingly. This also allows for more complex manipulation - as centering and cropping
		 *	
		 *	@example Usage: <listing version="3.0">
//create a sprite with a circle drawn in it
var img:fySprite = fySprite.newCircle({ radius: 30, x: 15, y: 15, color: 'pink' })

var img_aspect = new Aspect(img.width, img.height)

//If I want to center that circle in a 500x500 container
img_aspect.center(500,500)
//That aspect object now holds the new position. We can simply assign it
img.pos = img_aspect.pos
//Or do something more complex like tweening
img.tween({ x: img_aspect.x, y: img_aspect.y, time: 1 })
	
You can chain the transformations, and fySprite, fyBitmap and fyTextField have the "aspect" setter that setts x, y, width and height in one operation
img.aspect = img_aspect.inflate(30,30).center(600,600)

		 *	</listing>
		 *	@constructor
		 */
		public function Aspect(width:Number, height:Number) {
			this._width = width
			this._height = height
			
			this.ratio = width/height
		}
		
		
		public function get width():Number{ return this._width }
		public function get height():Number{ return this._height }
		public function get x():Number{ return this._x }
		public function get y():Number { return this._y }
		public function set x(x:Number):void { this._x = x }
		public function set y(y:Number):void { this._y = y }
		
		/**
		 *	get x + width
		 */
		public function get right():Number { return this._x + this._width }
		
		/**
		 *	get y + height
		 */
		public function get bottom():Number { return this._y + this._height }
		
		/**
		 *	set y + height(const)
		 */
		public function set bottom(value:Number):void { this._y = value - this._height }		

		/**
		 *	set x + width(const)
		 */
		public function set right(value:Number):void { this._x = value - this._width }		
		
		
		public function set width(w:Number):void{
			this._height = w/this.ratio
			this._width = w
		}
		public function dup():Aspect {
			return new Aspect(this._width, this._height).setAttrs({x:this._x, y:this._y})
		}

		public function set height(h:Number):void{
			this._width = h*this.ratio
			this._height = h
		}
		
		public function get dims():Array { return [this._width, this._height] }
		public function set dims(d:Array):void { 
			this._width = d[0]
			this._height = d[1]
			
			this.ratio = this._width/this._height
		}
		
		public function get pos():Array{ return [this.x, this.y] }
		
		/**
		 * The new height/width will be the largest posible to fit the given width/height, without going out of those dimensions
		 * @return Returns Itself
		 */
		public function constrain(w:Number, h:Number):Aspect{
			this._x = this._y = 0
			if((w/h) < this.ratio) {
				this.width = w
				this._y = (h - this._height) / 2.0
			}
			else {
				this.height = h
				this._x = (w - this._width) / 2.0
			}
			return this
		}
		
		/**
		 *	@return Returns itself
		 */
		public function inflate(w:Number, h:Number):Aspect {
			this._width += w
			this._height += h
			this._x -= w/2
			this._y -= h/2
			
			return this
			
		}
		
		/**
		 *	The width and height will become the smallest possible so that they fully enclose those dimensions
		 *	@return		Returns itself
		 */
		public function crop(w:Number, h:Number):Aspect{
			this._x = this._y = 0
			if((w/h) > this.ratio) {
				this.width = w
				this._y = (h - this._height) / 2.0
			}
			else {
				this.height = h
				this._x = (w - this._width) / 2.0
			}
			
			return this
		}
		public function toRect():Rectangle {
			return new Rectangle(this._x, this._y, this._width, this._height)
		}
		
		/**
		 *	@return		Return itself
		 */
		public function center(w:Number, h:Number):Aspect {
			return this.relative(w,h, 0.5, 0.5)
		}
		
		/**
		 * Position an element in a relative position of the parent
		 *	@return		Return itself
		 */
		public function relative(w:Number, h:Number, xPart:Number, yPart:Number):Aspect {
			this._x = ((w - this._width) * xPart)
			this._y = ((h - this._height) * yPart)
			return this
		}
		
		public function roundAll():Aspect {
			this._x = Math.round(this._x)
			this._y = Math.round(this._y)
			this._width = Math.round(this._width)
			this._height = Math.round(this._height)
			return this
		}
		
		public function toString():String{
			return "[Aspect] { x: "+this._x+", y:"+this._y+",  width:"+this._width+", height:"+this._height+" }"
		}
		
		/**
		 * Apply attributes as a hash, for example { x:10, height:20 } will set the x and height respectively
		 * @param attributes A hash with attributes
		 * @return Returns itself
		 */	
		public function setAttrs(attrs:Object = null):Aspect{
		  this.attrs = new Hash(attrs)
		  return this
		}
		
		/**
		 * Apply attributes as a hash, for example { x:10, height:20 } will set the x and height respectively
		 * @param attributes A hash with attributes
		 */
		public function set attrs(attributes:Object):* {
			if(attributes)for (var n:String in attributes) this[n] = attributes[n]
			return attributes
		}
		
		public function get attrs():Object{ return { x: _x, y: _y, width: _width, height: _height } }
	}
	
}
