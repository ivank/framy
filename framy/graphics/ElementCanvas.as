package framy.graphics 
{
	import framy.graphics.fySprite;
	
	/**
	 * This is used when you want to manage the width/height of the sprite mannually (rather than changing the scale value)
	 * Simply use this class and override the width/height setters with the custom logic
	 * Alternatively, you can override the "position" function wich gets called after each width/height update
	 * @author IvanK (ikerin@gmail.com)
	 */
	public class ElementCanvas extends fySprite
	{
		protected var _width:Number = 0
		protected var _height:Number = 0
		
		public function ElementCanvas(attributes:Object = null) { 
			super(attributes) 
		}
		
		override public function get width():Number { return this._width; }
		
		override public function set width(value:Number):void 
		{
			this._width = value;
			this.position()
		}
		
		override public function get height():Number { return this._height; }
		
		override public function set height(value:Number):void 
		{
			this._height = value;
			this.position()
		}
		
		public function position():void {
			
		}
	}
	
}