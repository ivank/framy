package framy.graphics {

	public class Aspect {
		private var _width:Number = 0
		private var _height:Number = 0
		
		private var _x:Number = 0
		private var _y:Number = 0
		
		private var ratio:Number = 0
		
		public function Aspect(w:Number, h:Number) {
			this._width = w
			this._height = h
			
			this.ratio = w/h
		}
		
		
		public function get width():Number{ return this._width }
		public function get height():Number{ return this._height }
		public function get x():Number{ return this._x }
		public function get y():Number{ return this._y }
		
		public function set width(w:Number):*{
			this._height = w/this.ratio
			return this._width = w
		}
		public function dup():Aspect {
			return new Aspect(this._width, this._height)
		}

		public function set height(h:Number):*{
			this._width = h*this.ratio
			return this._height = h
		}
		
		public function get dims():Array { return [this._width, this._height] }
		public function set dims(d:Array):*{ 
			this._width = d[0]
			this._height = d[1]
			
			this.ratio = this._width/this._height
			
			return [this._width, this._height]
		}
		public function get pos():Array{ return [this.x, this.y] }
		
		
		/**
		 * The new height/width will be the largest posible to fit the given width/height, without going out of those dimensions
		 * @param	w
		 * @param	h
		 * @return
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
		
		public function inflate(w:Number, h:Number):Aspect {
			this._x = this._y = 0
			if ((w / h) < this.ratio) {
				if ( this.width < w) {
					this.width = w
					this._y = (h - this._height) / 2.0
				}else {
					this._x = Math.round((w - this._width) / 2.0)
					this._y = Math.round((h - this._height) / 2.0)					
				}
			}
			else {
				if(this.height < h){
					this.height = h
					this._x = (w - this._width) / 2.0
				}else {
					this._x = Math.round((w - this._width) / 2.0)
					this._y = Math.round((h - this._height) / 2.0)					
				}
			}
			
			return this
			
		}
		
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
		
		public function center(w:Number, h:Number):Aspect {
			this._x = Math.round((w - this._width) / 2.0)
			this._y = Math.round((h - this._height) / 2.0)
			return this
		}
		
		public function toString():String{
			return "[Aspect] { x: "+this._x+", y:"+this._y+",  width:"+this._width+", height:"+this._height+" }"
		}
	}
	
}
